//
//  UIView+UIHelper.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 7/4/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIHelper)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic, getter=left, setter=setLeft:) CGFloat x;
@property (nonatomic, getter=top, setter=setTop:) CGFloat y;

- (void)integralizeFrame;
- (void)zeroFrame;
- (void)animateShake;

@end