//
//  ChaptersTableViewController.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/11/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VolumeDelegate;

@interface ChaptersTableViewController : UITableViewController

@property (nonatomic, weak) id<VolumeDelegate> delegate;

- (instancetype)initWithVolume:(Volume *)volume resume:(BOOL)resume;
- (instancetype)initWithVolume:(Volume *)volume;
- (instancetype)initResumingChapter;

@end

@protocol VolumeDelegate <NSObject>

- (Volume *)volumeViewController:(UIViewController *)viewController didAskForNextVolumeForCurrentVolume:(Volume *)currentVolume;
- (Volume *)volumeViewController:(UIViewController *)viewController didAskForPreviousVolumeForCurrentVolume:(Volume *)currentVolume;

@end