//
//  ChapterContentViewController.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/13/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChaptersTableViewController.h"

@protocol ChapterDelegate;

@interface ChapterContentViewController : UIViewController

@property (nonatomic, weak) id<ChapterDelegate> delegate;
@property (nonatomic, strong) Chapter *chapter;

- (instancetype)initWithChapter:(Chapter *)chapter;

@end

@protocol ChapterDelegate <NSObject>

- (void)chapterViewController:(UIViewController *)viewController didFetchChapter:(Chapter *)chapter;
- (Chapter *)chapterViewController:(UIViewController *)viewController didAskForNextChapterForCurrentChapter:(Chapter *)currentChapter;
- (Chapter *)chapterViewController:(UIViewController *)viewController didAskForPreviousChapterForCurrentChapter:(Chapter *)currentChapter;

@end