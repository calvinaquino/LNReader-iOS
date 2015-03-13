//
//  BakaTsukiParser.h
//  LNReader
//
//  Created by Commix Company on 8/16/13.
//  Copyright (c) 2013 Erakk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BakaTsukiParser : NSObject

//@property (retain) id<BTParserDelegate> delegate;
+ (void)fetchNovelList;
+ (void)fetchNovelInfo:(Novel *)novel;
+ (void)fetchChapterContent:(Chapter *)chapter;


@end
