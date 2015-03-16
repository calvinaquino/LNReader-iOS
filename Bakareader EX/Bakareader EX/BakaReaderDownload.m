//
//  BakaReaderDownload.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/15/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "BakaReaderDownload.h"

@implementation BakaReaderDownload

- (instancetype)init {
    self = [super init];
    if (self) {
        self.object = nil;
    }
    
    return self;
}

+ (BakaReaderDownload *)downloadForChapter:(Chapter *)chapter {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeChapterContent;
    download.url = [NSURL URLWithString:chapter.url];
    download.request = [NSURLRequest requestWithURL:download.url];
    download.operation = [[AFHTTPRequestOperation alloc] initWithRequest:download.request];
    download.operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    return download;
}

+ (BakaReaderDownload *)downloadForNovel:(Novel *)novel {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeNovelDetail;
    download.url = [NSURL URLWithString:novel.url];
    download.request = [NSURLRequest requestWithURL:download.url];
    download.operation = [[AFHTTPRequestOperation alloc] initWithRequest:download.request];
    download.operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    return download;
}

+ (BakaReaderDownload *)downloadForNovelList {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeNoveList;
    download.url = [NSURL URLWithString:kBakaTsukiMainUrlEnglish];
    download.request = [NSURLRequest requestWithURL:download.url];
    download.operation = [[AFHTTPRequestOperation alloc] initWithRequest:download.request];
    download.operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    return download;
}

@end
