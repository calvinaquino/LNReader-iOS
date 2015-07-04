//
//  BakaReaderTableViewCell.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 7/4/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRTableViewCell : UITableViewCell

@property (nonatomic, weak) NSString *title;
@property (nonatomic, weak) NSString *subtitle;
@property (nonatomic, assign, getter=isMarkedAsRead) BOOL markedAsRead;
@property (nonatomic, assign, getter=isOverflowEnabled) BOOL overflowEnabled;
@property (nonatomic, copy) void (^overflowActionBlock)(BRTableViewCell *cell);

+ (NSString *)identifier;
+ (CGFloat)height;

@end

