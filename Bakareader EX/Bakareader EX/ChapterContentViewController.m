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

@property (nonatomic, strong) Chapter *chapter;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ChapterContentViewController

- (instancetype)initWithChapter:(Chapter *)chapter {
    self = [super init];
    if (self) {
        self.chapter = chapter;
        self.title = chapter.title;
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
    if (self.chapter.content) {
        [self loadContentFromDatabase];
    } else {
        [self loadContentFromInternet];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.textView.frame = self.view.frame;
}


#pragma mark - Data Loading

- (void)loadContentFromDatabase {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.textView.text = weakSelf.chapter.content;
        [weakSelf.textView setNeedsDisplay];
    }];

}

- (void)loadContentFromInternet {
    __weak typeof(self) weakSelf = self;
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [BakaTsukiParser fetchChapterContent:self.chapter];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf loadContentFromDatabase];
        }];
    }];
}

@end
