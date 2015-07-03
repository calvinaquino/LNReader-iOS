//
//  NovelDetailViewController.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/26/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NovelDetailDelegate;

@interface NovelDetailViewController : UITableViewController

@property (nonatomic, weak) id<NovelDetailDelegate> delegate;

- (instancetype)initWithNovel:(Novel *)novel resume:(BOOL)resume;
- (instancetype)initWithNovel:(Novel *)novel;
- (instancetype)initResumingChapter;

@end

@protocol NovelDetailDelegate <NSObject>

- (void)novelDetailViewController:(NovelDetailViewController *)novelDetailViewController didFetchNovel:(Novel *)novel;

@end
