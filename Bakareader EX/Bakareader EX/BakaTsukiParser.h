//
//  BakaTsukiParser.h
//  LNReader
//
//  Created by Commix Company on 8/16/13.
//  Copyright (c) 2013 Erakk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BakaTsukiParser : NSObject

+ (void)parseNovelListFromData:(NSData *)data;
+ (void)parseNovelInfo:(Novel *)novel fromData:(NSData *)data;
+ (void)parseChapterContent:(Chapter *)chapter fromData:(NSData *)data;

@end
