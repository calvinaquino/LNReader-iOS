//
//  BakaReaderDownload.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/15/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef enum : NSUInteger {
    DownloadTypeImage,
    DownloadTypeChapterContent,
    DownloadTypeNovelDetail,
    DownloadTypeNoveList
} DownloadType;

@interface BakaReaderDownload : NSObject

@property (nonatomic, strong) NSManagedObject *object;
@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) DownloadType downloadType;
@property (nonatomic, copy) void (^progressUpdate)(CGFloat progress);

+ (BakaReaderDownload *)downloadForImageUrl:(NSString *)imageUrl;
+ (BakaReaderDownload *)downloadForChapter:(Chapter *)chapter;
+ (BakaReaderDownload *)downloadForNovel:(Novel *)novel;
+ (BakaReaderDownload *)downloadForNovelList;

@end
