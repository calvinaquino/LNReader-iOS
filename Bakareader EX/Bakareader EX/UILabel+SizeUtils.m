//
//  UILabel+SizeUtils.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 12/6/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "UILabel+SizeUtils.h"

@implementation UILabel (SizeUtils)

- (CGFloat)heightForText:(NSString *)text containedInWidth:(CGFloat)width {
    if (text && text.length) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:self.font}];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return rect.size.height;
    }
    
    return 0;
}

- (CGFloat)heightForCurrentTextAndWidth {
    return [self heightForText:self.text containedInWidth:self.frame.size.width];
}

- (void)calculateHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self heightForCurrentTextAndWidth]);
}

@end
