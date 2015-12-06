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

@interface ChapterContentViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, readonly) NSString *chapterContent;
@property (nonatomic, assign) BOOL firstTimeLoad;
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

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
    self.view.backgroundColor = [UIColor backgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationWillTerminateNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreWhite"] style:UIBarButtonItemStyleDone target:self action:@selector(showActionSheet)];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor backgroundColor];
    self.webView.opaque = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGesture.numberOfTouchesRequired = 1;
    self.tapGesture.numberOfTapsRequired = 2;
    self.tapGesture.delegate = self;
    self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    self.swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeRightGesture.delegate = self;
    self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    self.swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeLeftGesture.delegate = self;
    
    [self.webView addGestureRecognizer:self.tapGesture];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveState];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.frame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        self.fullScreen = !self.navigationController.isNavigationBarHidden;
        
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

- (void)setFullScreen:(BOOL)fullScreen {
    if (_fullScreen != fullScreen) {
        _fullScreen = fullScreen;
        
        [self.navigationController setNavigationBarHidden:fullScreen animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:fullScreen withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)nextChapterIfPossible {
    if ([self.delegate respondsToSelector:@selector(chapterViewController:didAskForNextChapterForCurrentChapter:)]) {
        Chapter *nextChapter = [self.delegate chapterViewController:self didAskForNextChapterForCurrentChapter:self.chapter];
        if (nextChapter) {
            [self saveProgress];
            [CoreDataController saveContext];
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
            [self saveProgress];
            [CoreDataController saveContext];
            self.chapter = previousChapter;
            [self loadChapterContent];
        } else {
            NSLog(@"no previous chapter");
        }
    }
}

- (void)saveState {
    @synchronized(self) {
        [CoreDataController user].lastChapterRead = self.chapter;
        self.chapter.volume.novel.lastChapterRead = self.chapter;
        [self saveProgress];
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

- (void)loadProgress {
    CGFloat heightOffset = self.chapter.readingProgressionValue * (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
    if (heightOffset > 1) {
        self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, heightOffset);
    }
}

- (void)saveProgress {
    CGFloat progression = self.webView.scrollView.contentOffset.y / (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
    self.chapter.readingProgressionValue = progression;
}


#pragma mark - Private Methods

- (void)showActionSheet {
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:self.chapter.title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *previousAction = [UIAlertAction actionWithTitle:@"Go to previous" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf previousChapterIfPossible];
    }];
    
    UIAlertAction *nextAction = [UIAlertAction actionWithTitle:@"Go to next" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf nextChapterIfPossible];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [actionSheet addAction:previousAction];
    [actionSheet addAction:nextAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (NSString *)chapterContent {
    NSString *backgroundColor = [[UIColor backgroundColor] hexString];
    NSString *borderColor = [[UIColor darkGrayColor] hexString];
    NSString *textColor = [[UIColor textColor] hexString];
    NSString *linkColor = [[UIColor orangeColor] hexString];
//    NSNumber *fontSize = @(kFontSizeSmall);
    
    NSMutableString *style = [[NSMutableString alloc] init];
    [style appendString:@"<head><style>"];
    //body
    [style appendString:@"body{"];
    [style appendString:[NSString stringWithFormat:@"background-color:#%@;",backgroundColor]];
    [style appendString:[NSString stringWithFormat:@"border-color:#%@;",borderColor]];
    [style appendString:[NSString stringWithFormat:@"color:#%@;",textColor]];
//    [style appendString:[NSString stringWithFormat:@"font-size:%@;",fontSize]];
    [style appendString:@"}"];
    //link
    [style appendString:@"a{"];
    [style appendString:[NSString stringWithFormat:@"color:#%@;",linkColor]];
    [style appendString:@"}"];
    //table
    [style appendString:@"table, td, th{"];
    [style appendString:[NSString stringWithFormat:@"background-color:#%@;",backgroundColor]];
    [style appendString:@"}"];
    
    [style appendString:@"</style></head>"];
    
    return [NSString stringWithFormat:@"<html>%@<body>%@</body></html>",style, self.chapter.content];
//    return [NSString stringWithFormat:@"<html><body bgcolor=\"#%@\" text=\"#%@\" size=\"%@\">%@</body></html>", backgroundColor, textColor, fontSize, self.chapter.content];
}

- (void)loadChapterContent {
    if (self.chapter.content) {
        [self loadContentFromDatabase];
    } else {
        [self loadContentFromInternet];
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self loadProgress];
        [self saveState];
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
    if ([requestUrl containsString:@".jpg"] || [requestUrl containsString:@".jpeg"] || [requestUrl containsString:@".png"]) {
        Image *image = [self.chapter imageForUrl:requestUrl];
        ImageViewerController *imageViewerController = [[ImageViewerController alloc] initWithImage:image];
        self.fullScreen = NO;
        [self.navigationController pushViewController:imageViewerController animated:YES];
        return NO;
    }
    
    NSLog(@"unhandled request");
    return NO;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL shouldRecognize = YES;
    
    NSUInteger numberOfKnownGesturesInvolved = 0;
    
    BOOL isTapInvolved = ( gestureRecognizer == self.tapGesture || otherGestureRecognizer == self.tapGesture);
    BOOL isSwipeLeftInvolved = ( gestureRecognizer == self.swipeLeftGesture || otherGestureRecognizer == self.swipeLeftGesture);
    BOOL isSwipeRightInvolved = ( gestureRecognizer == self.swipeRightGesture || otherGestureRecognizer == self.swipeRightGesture);
    
    numberOfKnownGesturesInvolved += isTapInvolved ? 1 : 0;
    numberOfKnownGesturesInvolved += isSwipeLeftInvolved ? 1 : 0;
    numberOfKnownGesturesInvolved += isSwipeRightInvolved ? 1 : 0;
    
    shouldRecognize = numberOfKnownGesturesInvolved == 1;
    
    return shouldRecognize;
}


@end
