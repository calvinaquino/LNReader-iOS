//
//  ChapterContentViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/13/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChapterContentViewController.h"
#import "ImageViewerController.h"
#import "BakaTsukiParser.h"

@interface ChapterContentViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, readonly) NSString *chapterContent;
@property (nonatomic, assign) BOOL firstTimeLoad;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightGesture;

@end

@implementation ChapterContentViewController

- (instancetype)initWithChapter:(Chapter *)chapter {
    self = [super init];
    if (self) {
        self.chapter = chapter;
        self.firstTimeLoad = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationWillTerminateNotification object:nil];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    self.swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    self.swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.swipeRightGesture];
    [self.view addGestureRecognizer:self.swipeLeftGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.firstTimeLoad) {
        self.firstTimeLoad = NO;
        [self loadChapterContent];
    }
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveReadingProgression];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.frame;
}


#pragma mark - Property Accessors

- (void)setChapter:(Chapter *)chapter {
    _chapter = chapter;
    self.title = chapter.title;
    
    if (self.isViewLoaded) {
        [self loadChapterContent];
    }
}


#pragma mark - Private Methods

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        
    }
}

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)swipeGesture {
    if (swipeGesture.state == UIGestureRecognizerStateRecognized) {
        [self nextChapterIfPossible];
    }
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)swipeGesture {
    if (swipeGesture.state == UIGestureRecognizerStateRecognized) {
        [self previousChapterIfPossible];
    }
}

- (void)nextChapterIfPossible {
    if ([self.delegate respondsToSelector:@selector(chapterViewController:didAskForNextChapterForCurrentChapter:)]) {
        Chapter *nextChapter = [self.delegate chapterViewController:self didAskForNextChapterForCurrentChapter:self.chapter];
        if (nextChapter) {
            self.chapter = nextChapter;
            [self loadChapterContent];
        } else {
            NSLog(@"no next chapter");
        }
    }
}

- (void)previousChapterIfPossible {
    if ([self.delegate respondsToSelector:@selector(chapterViewController:didAskForPreviousChapterForCurrentChapter:)]) {
        Chapter *previousChapter = [self.delegate chapterViewController:self didAskForPreviousChapterForCurrentChapter:self.chapter];
        if (previousChapter) {
            self.chapter = previousChapter;
            [self loadChapterContent];
        } else {
            NSLog(@"no previous chapter");
        }
    }
}

- (void)saveState {
    @synchronized(self) {
        CGFloat progression = self.webView.scrollView.contentOffset.y / (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
        self.chapter.readingProgressionValue = progression;
    
        [CoreDataController user].lastChapterRead = self.chapter;
        self.chapter.volume.novel.lastChapterRead = self.chapter;
        [CoreDataController saveContext];
    }
}

#pragma mark - Data Loading

- (void)loadContentFromDatabase {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf.webView loadHTMLString:[weakSelf chapterContent] baseURL:[NSURL URLWithString:kBakaTsukiBaseUrl]];
        [weakSelf.webView setNeedsDisplay];
    }];
}

- (void)loadContentFromInternet {
    __weak typeof(self) weakSelf = self;
    [[BakaReaderDownloader sharedInstance] downloadChapter:self.chapter withCompletion:^(BOOL success) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([weakSelf.delegate respondsToSelector:@selector(chapterViewController:didFetchChapter:)]) {
                [weakSelf.delegate chapterViewController:weakSelf didFetchChapter:weakSelf.chapter];
            }
            [weakSelf loadContentFromDatabase];
        }];
    }];
}

- (void)loadReadingProgression {
    CGFloat heightOffset = self.chapter.readingProgressionValue * (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
    if (heightOffset > 1) {
        self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, heightOffset);
    }
}

- (void)saveReadingProgression {
    CGFloat progression = self.webView.scrollView.contentOffset.y / (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
    self.chapter.readingProgressionValue = progression;
    [CoreDataController saveContext];
}


#pragma mark - Private Methods

- (NSString *)chapterContent {
    NSString *backgroundColor = [[UIColor whiteColor] hexString];
    NSString *textColor = [[UIColor blackColor] hexString];
    NSNumber *fontSize = @(12);
    
    return [NSString stringWithFormat:@"<html><body bgcolor=\"#%@\" text=\"#%@\" size=\"%@5\">%@</body></html>", backgroundColor, textColor, fontSize, self.chapter.content];
}

- (void)loadChapterContent {
    if (self.chapter.content) {
        [self loadContentFromDatabase];
    } else {
        [self loadContentFromInternet];
    }
    [self saveState];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self loadReadingProgression];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.chapter.isExternalValue) {
        NSLog(@"external chapter");
        return YES;
    }
    NSString *requestUrl = [request.URL absoluteString];
    NSString *standardContentUrl = [NSString stringWithFormat:@"%@/", kBakaTsukiBaseUrl];
    NSString *blankUrl = @"about:blank";
    
    //is standard load.
    if ([requestUrl isEqualToString:standardContentUrl]) {
        NSLog(@"standard content loading");
        return YES;
    }
    
    //is standard load without base URL
    if ([requestUrl isEqualToString:blankUrl]) {
        return YES;
    }
    
    //is footer reference
    if ([requestUrl containsString:@"#"]) {
        NSLog(@"footer reference");
        return YES;
    }
    
    //is image
    if ([requestUrl containsString:@".jpg"] || [requestUrl containsString:@".png"]) {
        Image *image = [self.chapter imageForUrl:requestUrl];
        ImageViewerController *imageViewerController = [[ImageViewerController alloc] initWithImage:image];
        [self.navigationController pushViewController:imageViewerController animated:YES];
        return NO;
    }
    
    NSLog(@"unhandled request");
    return NO;
}


@end
