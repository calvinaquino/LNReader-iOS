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

//static NSString *const kXPATHMainNovelList = @"//html/body/div[@id='mw-navigation']/div[@id='mw-panel']/div[@id='p-Light_Novels']/div[@class='body']/ul/li";
//static NSString *const kXPATHNovelContent = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";
//static NSString *const kXPATHNovelCover = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']/div/div/a[@class='image']/img";
//static NSString *const kXPATHNovelSynopsis = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";
//static NSString *const kXPATHNovelVolumes = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";

static NSString *const kXPATHMainNovelList = @"//*[@id='mw-pages']/div/table/tr/td/ul/li";
static NSString *const kXPATHNovelContent = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";
static NSString *const kXPATHNovelCover = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']/div/div/a[@class='image']";
static NSString *const kXPATHNovelSynopsis = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";
static NSString *const kXPATHNovelVolumes = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";

//static NSString* const kNoChapterNameError = @"NO_CHAPTER_NAME_FOUND";

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

+ (NSArray*)novelListWithHTMLData:(NSData*)htmlData {
    NSMutableArray *novelsArray = nil;
    RXMLElement *element = [RXMLElement elementFromHTMLData:htmlData];

    if ([element isValid]) {
        novelsArray = [[NSMutableArray alloc] init];
        for (RXMLElement *node in [element childrenWithRootXPath:kXPATHMainNovelList]) {
            Novel *novelData = [CoreDataController newNovel];
            RXMLElement *subNode = [node child:@"a"];
            novelData.title = subNode.text;
            novelData.url = [[NSURL URLWithString:[subNode attribute:@"href"] relativeToURL:[NSURL URLWithString:kBakaTsukiBaseUrl]] absoluteString];

            [novelsArray addObject:novelData];
        }
    } else {
        NSLog(@"Invalid data - parsing failed");
    }

    return [novelsArray copy];
}

+ (NSURL*)novelCoverURLWithHTMLData:(NSData*)novelData {
    return novelcoverURLFromElement([RXMLElement elementFromHTMLData:novelData]);
}

+ (NSURL*)novelCoverURLWithXMLData:(NSData*)novelData {
    return novelcoverURLFromElement([RXMLElement elementFromXMLData:novelData]);
}


+ (NSString*)parseNovelSynopsisWithData:(NSData*)novelData {
    RXMLElement *novelXMLRoot = [RXMLElement elementFromXMLData:novelData];
    
    __block BOOL parseSynopsis = NO; //this decides if should parse the <p>
    __block NSMutableString *synopsis = [[NSMutableString alloc]init]; //our synopsis text
    
    [novelXMLRoot iterateWithRootXPath:@"//*[@id='mw-content-text']/*" usingBlock: ^(RXMLElement *element) {
//        NSLog(@"<%@>", element.tag);
        
        //Checks if tag is <p>
        if ([element.tag isEqualToString:@"p"]) {
            //if we went pass h2 with child id synopsis, then add text
            if (parseSynopsis) {
//                NSLog(@"%@",element.text);
                [synopsis appendString:element.text];
            }
        }
        if ([element.tag isEqualToString:@"h2"]) {
            //For safety
            parseSynopsis = NO;
            //if we found someone with span as a child
            if ([element children:@"span"]) {
                //then iterate all child spans
                for (RXMLElement *child in [element children:@"span"]) {
                    if ([[child attribute:@"id"] isEqualToString:@"Story_Synopsis"]) {
                        parseSynopsis = YES;
                    }
                }
            }
        }
    }];
//    NSLog(@"%@",synopsis);
    return synopsis;
}


+ (NSArray*)parseNovelVolumesWithData:(NSData*)novelData {
    //read data
    RXMLElement *novelXMLRoot = [RXMLElement elementFromXMLData:novelData];
    //get name

    __block NSString *novelName = @"";

    [novelXMLRoot iterateWithRootXPath:@"//*[@id='firstHeading']/span" usingBlock: ^(RXMLElement *element) {novelName = element.text;}];
    NSString *novelNameSimple = [self simpleName:novelName];

    //alloc resources
    __block NSMutableArray *volumes = [[NSMutableArray alloc] init]; //our volumes
    __block NSMutableArray *chapters = [[NSMutableArray alloc] init]; //our chapters
    __block Volume *bufferVolume;
    
    //iterate data
    [novelXMLRoot iterateWithRootXPath:@"//*/a" usingBlock:^(RXMLElement *element) {
        //            NSLog(@"found volumes for rule //*/a");
        for (NSString *attributeName in element.attributeNames) {

            NSString *content = [element attribute:attributeName];
            if ([content containsString:@"/project/index.php?title="]) {
                //checks names by separating words.
                if ([self checkForNames:[self getArrayOfPossibleNamesFor:novelNameSimple] inString:content]) {

                    //Must not contain
                    if ([self checkStringForUndesiredContent:content]) {
                        break;
                    }
                    //contains
                    if ([self checkStringForDesiredContent:content]) {

                        //alloc data for use
                        Volume *volume = [CoreDataController newVolume];
                        Chapter *chapter = [CoreDataController newChapter];

                        //get dict with info names
                        NSDictionary *currObject = [self getVolumeAndChapterWithURL:content];
                        if (!currObject)break; //empty name, no data, quit this iteration

                        //set the names
                        volume.title = currObject[@"volume"];
                        chapter.title = currObject[@"chapter"];
                        chapter.volume = currObject[@"volume"];

                        chapter.url = [[NSURL URLWithString:content relativeToURL:[NSURL URLWithString:kBakaTsukiBaseUrl]] absoluteString];
                        //                        NSLog(@"link %@",chapterUrl);

                        if ([chapter.title isEqualToString:kNoChapterNameError]) {
                            [chapter setTitle:@"Chapter"];
                        }

                        //organize (badly)
                        if ([volume.title isEqualToString:bufferVolume.title]) {
                            //still on the same volume, add more chapters
                            [chapters addObject:chapter];
                        } else {
                            //volume changed OR first volume, add volume
                            if (bufferVolume) {
                                //if buffer was allocated before, then add it
                                if (chapters.count > 0) {
                                    //if there are volumes, add them
                                    [bufferVolume setChapters:[NSSet setWithArray:chapters]];
                                }
                                [volumes addObject:bufferVolume];
                            }
                            bufferVolume = [[Volume alloc] init];
                            chapters = [[NSMutableArray alloc] init];
                            [bufferVolume setTitle:volume.title];
                            [chapters addObject:chapter];
                        }
                    }
                }
            }
        }
    }];
    //Add last volume
    if (bufferVolume) {
        //if buffer was allocated before, then add it
        if (chapters.count > 0) {
            //if there are volumes, add them
            [bufferVolume setChapters:[NSSet setWithArray:chapters]];
        }
        [volumes addObject:bufferVolume];
    }
    
//    DLog(@"%@",volumes);
    return volumes;
}

+ (NSArray*)parseChapterContentWithData:(NSData*)chapterContent {
    RXMLElement *chapterXMLRoot = [RXMLElement elementFromXMLData:chapterContent];
    
    NSMutableArray *chapterContents = [[NSMutableArray alloc] init];
    
    [chapterXMLRoot iterateWithRootXPath:@"//*[@id='mw-content-text']/*" usingBlock: ^(RXMLElement *element) {
//        NSLog(@"%@",element.text);
        [chapterContents addObject:element.text];
    }];
    return chapterContents;
}


//Strings that might interest us.
+ (BOOL)checkStringForDesiredContent:(NSString*)string {
//    NSLog(@"checking %@ for add",string);
    if ([string containsString:@"Chapter"]||
        [string containsString:@"Volume"]||
        [string containsString:@"Part"]|| //Chapter???
        [string containsString:@"Act"]|| //Volume???
        [string containsString:@"Illustrations"]) {
        return YES;
    }
    return NO;
}
//Stuff that we might nt want
+ (BOOL)checkStringForUndesiredContent:(NSString*)string {
//    NSLog(@"checking %@ for remv",string);
    if ([string containsString:@"&action="]||
        [string containsString:@"Registration_Page"]||
        [string containsString:@"Updates"]||
        [string containsString:@"oldid"]||
        [string containsString:@"&printable"]||
        [string containsString:@"Special:"]) {
        return YES;
    }
    return NO;
}

+ (NSArray*)getArrayOfPossibleNamesFor:(NSString*)name {
    NSArray *nameArray = [name componentsSeparatedByString:@" "];
//    NSLog(@"got %@ returned %@",name,nameArray);
    return nameArray;
}

+ (BOOL)checkForNames:(NSArray*)nameArray inString:(NSString*)string {
    int hits = 0; // ammount of strings that match
    
    for (NSString *name in nameArray) {
//        NSLog(@"checking if %@ is in %@",name, string);
        if ([string containsString:name]) {
            hits++;
//            NSLog(@"hit");
        }
    }
//    NSLog(@"total hits %i",hits);
    if (hits > 0) {
        return YES;
    }
    return NO;
}

+ (NSString*)simpleName:(NSString*)string {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
    NSString *simpleName = [[[string componentsSeparatedByCharactersInSet:charSet][0] stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"'" withString:@""];
//    NSLog(@"simplified %@ to %@",string,simpleName);
    return simpleName;
}

+ (NSString*)getName:(NSString*)string isVolume:(BOOL)isVolume {
    // Intermediate
    NSString *volumeString;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:&volumeString];
    
    NSString *numberString;
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    if (!numberString) {
        numberString = @"";
    }
    NSString *returnVString = [NSString stringWithFormat:@"%@%@",volumeString,numberString];
    
//    NSString *returnCString = [[string componentsSeparatedByString:numberString] lastObject];
    NSString *returnCString = [[string componentsSeparatedByString:returnVString] lastObject];
    
    //Add space between volume numbering if it doesnt exists.
    if ([returnVString componentsSeparatedByString:@" "].count == 1) {
        returnVString = [NSString stringWithFormat:@"%@ %@",volumeString,numberString];
    }
    
    // Result.
    if (isVolume) {
        return returnVString;
    }
    return returnCString;
}


+(NSDictionary*)getVolumeAndChapterWithURL:(NSString *)volumeRelativeURL {
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
    
    NSLog(@"%@ - %@",VolumeName,ChapterName);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:VolumeName,ChapterName, nil] forKeys:[NSArray arrayWithObjects:@"volume",@"chapter", nil]];
    return dict;
}

@end
