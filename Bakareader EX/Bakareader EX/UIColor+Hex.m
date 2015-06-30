//
//  UIColor+Hex.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 6/29/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

- (NSString *)hexString {
    if (self == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
}

@end
