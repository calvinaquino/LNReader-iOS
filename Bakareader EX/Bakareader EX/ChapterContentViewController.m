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

@end

@implementation ChapterContentViewController

- (instancetype)initWithChapter:(Chapter *)chapter {
    self = [super init];
    if (self) {
        self.chapter = chapter;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadChapterContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveReadingProgression];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


#pragma mark - Data Loading

- (void)loadContentFromDatabase {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf.webView loadHTMLString:[weakSelf chapterContent] baseURL:[NSURL URLWithString:kBakaTsukiBaseUrl]];
        [weakSelf.webView setNeedsDisplay];
    }];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf loadReadingProgression];
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
//    CGFloat heightOffset = self.chapter.readingProgressionValue * (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
//    self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, heightOffset);
}

- (void)saveReadingProgression {
//    CGFloat progression = self.webView.scrollView.contentOffset.y / (self.webView.scrollView.contentSize.height - self.webView.frame.size.height);
//    self.chapter.readingProgressionValue = progression;
//    [CoreDataController saveContext];
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
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestUrl = [request.URL absoluteString];
    NSString *standardContentUrl = [NSString stringWithFormat:@"%@/", kBakaTsukiBaseUrl];
    
    //is standard load.
    if ([requestUrl isEqualToString:standardContentUrl]) {
        NSLog(@"standard content loading");
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
