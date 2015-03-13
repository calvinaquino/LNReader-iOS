//
//  NSString+containsCategory.m
//  LNReader
//
//  Created by Andrey Ilskiy on 19/02/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "NSString+containsCategory.h"

@implementation NSString (containsCategory)

- (BOOL)containsString:(NSString*)substring {
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

@end
