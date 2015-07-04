//
//  UIFont+BakaReader_EX.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 7/4/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "UIFont+BakaReader_EX.h"

@implementation UIFont (BakaReader_EX)

+ (UIFont *)textFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:kFontSizeSmall];
}

+ (UIFont *)cellTitleFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:kFontSizeMedium];
}

+ (UIFont *)cellSubtitleFont {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:kFontSizeSmall];
}

+ (UIFont *)titleFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:kFontSizeMedium];
}

@end
