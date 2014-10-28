//
//  UIView+Constraints.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/28/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraints)

#pragma mark - Constraints methods

- (NSArray *)addConstraintsWithFormat:(NSString *)format views:(NSDictionary *)views;
- (NSArray *)addConstraintsWithFormat:(NSString *)format metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
- (NSArray *)addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)opts views:(NSDictionary *)views;
- (NSArray *)addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

- (id)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
- (id)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2;


@end
