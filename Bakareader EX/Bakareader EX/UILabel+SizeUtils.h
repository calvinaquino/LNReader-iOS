//
//  UILabel+SizeUtils.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 12/6/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SizeUtils)
+ (CGFloat)heightForText:(NSString *)text containedInWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGFloat)heightForText:(NSString *)text containedInWidth:(CGFloat)width;
- (CGFloat)heightForCurrentTextAndWidth;
- (void)calculateHeight;

@end
