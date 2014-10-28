//
//  UIView+Constraints.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/28/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

#pragma mark - Constraints methods

- (NSArray *)addConstraintsWithFormat:(NSString *)format views:(NSDictionary *)views {
    return [self addConstraintsWithFormat:format options:0 metrics:nil views:views];
}

- (NSArray *)addConstraintsWithFormat:(NSString *)format metrics:(NSDictionary *)metrics views:(NSDictionary *)views {
    return [self addConstraintsWithFormat:format options:0 metrics:metrics views:views];
}

- (NSArray *)addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)opts views:(NSDictionary *)views {
    return [self addConstraintsWithFormat:format options:opts metrics:nil views:views];
}

- (NSArray *)addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views {
    format = [format stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *components = [format componentsSeparatedByString:@"&&"];
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    for (NSString *visualFormat in components) {
        if (visualFormat.length > 0) {
            NSArray *partialConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:opts metrics:metrics views:views];
            [constraints addObjectsFromArray:partialConstraints];
        }
    }
    
    [self addConstraints:constraints];
    return constraints;
}

- (id)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    [self addConstraint:constraint];
    return constraint;
}

- (id)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 {
    return [self addConstraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:1 constant:0];
}


@end
