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
+(NSArray*)novelListWithHTMLData:(NSData*)htmlData;
+(NSURL*)novelCoverURLWithHTMLData:(NSData*)htmlData;
+(NSURL*)novelCoverURLWithXMLData:(NSData*)xmlData;
+(NSString*)parseNovelSynopsisWithData:(NSData*)novelData;
+(NSArray*)parseNovelVolumesWithData:(NSData*)novelData;
+(NSArray*)parseChapterContentWithData:(NSData*)chapterContent;

@end
