//
//  ChapterContentViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/13/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChapterContentViewController.h"
#import "BakaTsukiParser.h"

@interface ChapterContentViewController ()

@property (nonatomic, strong) UITextView *textView;

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
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
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
    
    self.textView.frame = self.view.frame;
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
        weakSelf.textView.text = weakSelf.chapter.content;
        [weakSelf.textView setNeedsDisplay];
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
    CGFloat heightOffset = self.chapter.readingProgressionValue * (self.textView.contentSize.height - self.textView.frame.size.height);
    self.textView.contentOffset = CGPointMake(self.textView.contentOffset.x, heightOffset);
}

- (void)saveReadingProgression {
    CGFloat progression = self.textView.contentOffset.y / (self.textView.contentSize.height - self.textView.frame.size.height);
    self.chapter.readingProgressionValue = progression;
    [CoreDataController saveContext];
}


#pragma mark - Private Methods

- (void)loadChapterContent {
    if (self.chapter.content) {
        [self loadContentFromDatabase];
    } else {
        [self loadContentFromInternet];
    }
}


@end
