//
//  ImageViewerController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 6/30/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ImageViewerController.h"

@interface ImageViewerController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *imageUrl;

@end

@implementation ImageViewerController

- (instancetype)initWithImageUrl:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        self.imageUrl = imageUrl;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressView = [[UIProgressView alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2.5;
    self.scrollView.minimumZoomScale = 0.2;
    self.imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.progressView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.progressView.hidden = NO;
    [BakaReaderDownloader sharedInstance].progressView = self.progressView;
    
    __weak ImageViewerController *weakSelf = self;
    [[BakaReaderDownloader sharedInstance] downloadImageFromUrl:self.imageUrl withCompletion:^(BOOL success, UIImage *image) {
        [BakaReaderDownloader sharedInstance].progressView = nil;
        weakSelf.progressView.hidden = YES;
        if (success && image) {
            weakSelf.imageView.image = image;
            [weakSelf.view setNeedsLayout];
            [weakSelf setInitialZoomScale];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [BakaReaderDownloader sharedInstance].progressView = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 10);
    
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.frame = self.view.frame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)setInitialZoomScale {
    CGFloat horizontalScale = self.imageView.image.size.width / self.view.bounds.size.width;
    CGFloat verticalScale = self.imageView.image.size.height / self.view.bounds.size.height;
    
    CGFloat initialZoomScale = horizontalScale > verticalScale ? (1.0 / horizontalScale) : (1.0 / verticalScale);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.scrollView setZoomScale:initialZoomScale];
    }];
}

@end
