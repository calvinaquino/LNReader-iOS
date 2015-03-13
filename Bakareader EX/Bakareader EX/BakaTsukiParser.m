//
//  BakaTsukiParser.m
//  LNReader
//
//  Created by Commix Company on 8/16/13.
//  Copyright (c) 2013 Erakk. All rights reserved.
//

#import "BakaTsukiParser.h"
#import "RXMLElement.h"
#import "NSString+containsCategory.h"

NS_RETURNS_NOT_RETAINED NSURL* novelcoverURLFromElement(RXMLElement* element) {
    NSURL *coverUrl = nil;

    if (element) {
        NSArray *coverNodes = [element childrenWithRootXPath:kXPATHNovelCover];

        if (coverNodes.count == 0) {
            NSLog(@"Node for Cover URL - Not Found");
        } else {
            coverUrl = [NSURL URLWithString:[(RXMLElement *)[coverNodes firstObject] attribute:@"src"] relativeToURL:[NSURL URLWithString:kBakaTsukiBaseUrl]];
        }
    }

    return coverUrl;
}

@implementation BakaTsukiParser

+ (void)fetchNovelList {
    NSData *btHtmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kBakaTsukiMainUrlEnglish]];
    
    RXMLElement *element = [RXMLElement elementFromHTMLData:btHtmlData];
    NSArray *btNodes = [element childrenWithRootXPath:kXPATHMainNovelList];
    
    for (RXMLElement *element in btNodes) {
        NSString *novelTitle = [[element child:@"a"] text];
        NSString *novelUrl = [[NSURL URLWithString:[[element child:@"a"] attribute:@"href"] relativeToURL:[NSURL URLWithString:kBTBaseUrl]] absoluteString];
        
        if ([CoreDataController novelAlreadyExistsForUrl:novelUrl]) {
            Novel *existingNovel = [CoreDataController novelWithUrl:novelUrl];
            existingNovel.title = novelTitle;
        } else {
            Novel *newNovel = [CoreDataController newNovel];
            newNovel.title = novelTitle;
            newNovel.url = novelUrl;
        }
        
        [CoreDataController saveContext];
    }
}

+ (NSURL*)novelCoverURLWithHTMLData:(NSData*)novelData {
    return novelcoverURLFromElement([RXMLElement elementFromHTMLData:novelData]);
}

+ (NSURL*)novelCoverURLWithXMLData:(NSData*)novelData {
    return novelcoverURLFromElement([RXMLElement elementFromXMLData:novelData]);
}

+ (void)fetchNovelInfo:(Novel *)novel {
    NSData *novelData = [NSData dataWithContentsOfURL:[NSURL URLWithString:novel.url]];
    [BakaTsukiParser parseNovelSynopsisWithData:novelData forNovel:novel];
    [BakaTsukiParser parseNovelVolumesWithData:novelData forNovel:novel];
}

+ (void)fetchChapterContent:(Chapter *)chapter {
    NSData *chapterData = [NSData dataWithContentsOfURL:[NSURL URLWithString:chapter.url]];
    chapter.content = [BakaTsukiParser parseChapterContentWithData:chapterData];
    [CoreDataController saveContext];
}


+ (void)parseNovelSynopsisWithData:(NSData*)novelData forNovel:(Novel*)novel {
    RXMLElement *novelXMLRoot = [RXMLElement elementFromXMLData:novelData];
    
    __block BOOL parseSynopsis = NO;
    __block NSMutableString *synopsis = [[NSMutableString alloc]init];
    
    [novelXMLRoot iterateWithRootXPath:@"//*[@id='mw-content-text']/*" usingBlock: ^(RXMLElement *element) {
        if ([element.tag isEqualToString:@"p"]) {
            if (parseSynopsis) {
                [synopsis appendString:element.text];
            }
        }
        if ([element.tag isEqualToString:@"h2"]) {
            parseSynopsis = NO;
            if ([element children:@"span"]) {
                for (RXMLElement *child in [element children:@"span"]) {
                    if ([[child attribute:@"id"] containsString:@"Synopsis"] || [[child attribute:@"id"] containsString:@"synopsis"]) {
                        parseSynopsis = YES;
                    }
                }
            }
        }
    }];
    novel.synopsis = synopsis;
}


+ (void)parseNovelVolumesWithData:(NSData*)novelData forNovel:(Novel *)novel {
    RXMLElement *novelXMLRoot = [RXMLElement elementFromXMLData:novelData];

    __block NSString *novelName = @"";

    [novelXMLRoot iterateWithRootXPath:@"//*[@id='firstHeading']/span" usingBlock: ^(RXMLElement *element) {
        novelName = element.text;
    }];
    NSString *novelNameSimple = [self simpleName:novelName];

    __block NSMutableArray *volumes = [[NSMutableArray alloc] init];
//    __block NSMutableArray *chapters = [[NSMutableArray alloc] init];
    __block Volume *currentVolume;
    
    __block NSUInteger volumeOrder = 0;
    __block NSUInteger chapterOrder = 0;
    
    [novelXMLRoot iterateWithRootXPath:@"//*/a" usingBlock:^(RXMLElement *element) {
        for (NSString *attributeName in element.attributeNames) {
            NSString *content = [element attribute:attributeName];
            
            NSLog(@"content %@", content);
            
            if ([content containsString:@"/project/index.php?title="] || [content containsString:@"external"]) {
                if ([self checkForNames:[self getArrayOfPossibleNamesFor:novelNameSimple] inString:content]) {
                    
                    if ([self checkStringForUndesiredContent:content]) {
                        break;
                    }
                    if ([self checkStringForDesiredContent:content]) {
                        NSDictionary *currentInfo = [self getVolumeAndChapterWithURL:content];
                        if (!currentInfo) {
                            break;
                        }
                        
                        if (!currentVolume || ![currentVolume.title isEqualToString:currentInfo[@"volume"]]) {
//                            if (currentVolume && chapters.count) {
//                                [currentVolume addChapters:[NSSet setWithArray:chapters]];
//                                chapters = [[NSMutableArray alloc] init];
//                            }
                            currentVolume = [CoreDataController newVolume];
                            currentVolume.orderValue = volumeOrder;
                            currentVolume.title = currentInfo[@"volume"];
                            volumeOrder++;
                            [volumes addObject:currentVolume];
                            chapterOrder = 0;
                        }
                        Chapter *chapter = [CoreDataController newChapter];
                        chapter.orderValue = chapterOrder;
                        chapterOrder++;
                        
                        chapter.title = currentInfo[@"chapter"];
                        chapter.volume = currentVolume;
                        
                        chapter.url = [[NSURL URLWithString:content relativeToURL:[NSURL URLWithString:kBakaTsukiBaseUrl]] absoluteString];
                        
                        if ([chapter.title isEqualToString:kNoChapterNameError]) {
                            chapter.title = @"Chapter";
                        }
                        
//                        [chapters addObject:chapter];
                        [currentVolume.chaptersSet addObject:chapter];
                    }
                }
            }
        }
    }];
    
//    for (Volume *volume in volumes) {
//        for (Chapter *chapter in volume.chapters) {
//            NSLog(@"%@ - %@", volume.title, chapter.title);
//        }
//    }

    
    
    [novel setVolumes:[NSSet setWithArray:volumes]];
    novel.fetchedValue = YES;
    [CoreDataController saveContext];
}

+ (NSString *)parseChapterContentWithData:(NSData*)chapterContent {
    RXMLElement *chapterXMLRoot = [RXMLElement elementFromXMLData:chapterContent];
    
    NSMutableString *content = [[NSMutableString alloc] init];
    
    [chapterXMLRoot iterateWithRootXPath:@"//*[@id='mw-content-text']/*" usingBlock: ^(RXMLElement *element) {
        [content appendString:@"\n"];
        [content appendString:element.text];
    }];
    return content;
}

//Strings that might interest us.
+ (BOOL)checkStringForDesiredContent:(NSString*)string {
    if ([string containsString:@"Chapter"]||
        [string containsString:@"Volume"]||
        [string containsString:@"Vol"]||
        [string containsString:@"Part"]|| //Chapter???
        [string containsString:@"Act"]|| //Volume???
        [string containsString:@"Illustrations"]) {
        return YES;
    }
    return NO;
}

//Stuff that we might not want
+ (BOOL)checkStringForUndesiredContent:(NSString*)string {
    if ([string containsString:@"&action="]||
        [string containsString:@"Registration_Page"]||
        [string containsString:@"Updates"]||
        [string containsString:@"oldid"]||
        [string containsString:@".jpg"]||
        [string containsString:@"&printable"]||
        [string containsString:@"Special:"]) {
        return YES;
    }
    return NO;
}

+ (NSArray*)getArrayOfPossibleNamesFor:(NSString*)name {
    NSArray *nameArray = [name componentsSeparatedByString:@" "];
    return nameArray;
}

+ (BOOL)checkForNames:(NSArray*)nameArray inString:(NSString*)string {
    int hits = 0;
    
    for (NSString *name in nameArray) {
        if ([string containsString:name]) {
            hits++;
        }
    }
    if (hits > 0) {
        return YES;
    }
    return NO;
}

+ (NSString*)simpleName:(NSString*)string {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
    NSString *simpleName = [[[string componentsSeparatedByCharactersInSet:charSet][0] stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return simpleName;
}

+ (NSString*)getName:(NSString*)string isVolume:(BOOL)isVolume {
    NSString *volumeString;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    [scanner scanUpToCharactersFromSet:numbers intoString:&volumeString];
    
    NSString *numberString;
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    if (!numberString) {
        numberString = @"";
    }
    NSString *returnVString = [NSString stringWithFormat:@"%@%@",volumeString,numberString];
    
    NSString *returnCString = [[string componentsSeparatedByString:returnVString] lastObject];
    
    if ([returnVString componentsSeparatedByString:@" "].count == 1) {
        returnVString = [NSString stringWithFormat:@"%@ %@",volumeString,numberString];
    }
    
    if (isVolume) {
        return returnVString;
    }
    return returnCString;
}


+ (NSDictionary*)getVolumeAndChapterWithURL:(NSString *)volumeRelativeURL {
    NSString *baseName = [volumeRelativeURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *baseName2 = [baseName stringByReplacingOccurrencesOfString:@"/project/index.php?title=" withString:@""];
    NSArray *tempArray = [baseName2 componentsSeparatedByString:@":"];
    NSMutableString * mutableBaseName3 = [[NSMutableString alloc] init];
    for (int i = 1; i < tempArray.count; i++) {
        NSString *separator = @":";
        if (i == tempArray.count-1) {
            separator = @"";
        }
        [mutableBaseName3 appendFormat:@"%@%@",tempArray[i],separator];
    }
    NSString *baseName3 = [NSString stringWithFormat:@"%@",mutableBaseName3];
    NSString *baseName4 = [baseName3 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    NSMutableString *VolumeName = [[NSMutableString alloc]init];
    NSMutableString *ChapterName = [[NSMutableString alloc]init];
    [VolumeName appendString:[self getName:baseName4 isVolume:YES]];
    [ChapterName appendString:[self getName:baseName4 isVolume:NO]];
    
    if ([ChapterName isEqualToString:@""]) {
        NSLog(@"chapter name was nil for %@",baseName);
        return nil;
    }
    
//    NSLog(@"%@ - %@",VolumeName,ChapterName);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:VolumeName,ChapterName, nil] forKeys:[NSArray arrayWithObjects:@"volume",@"chapter", nil]];
    return dict;
}

@end
