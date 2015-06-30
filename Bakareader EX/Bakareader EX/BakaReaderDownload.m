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

+ (BakaReaderDownload *)downloadForImageUrl:(NSString *)imageUrl {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeImage;
    return [self configureDownload:download withUrlString:imageUrl];
}

+ (BakaReaderDownload *)downloadForChapter:(Chapter *)chapter {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeChapterContent;
    return [self configureDownload:download withUrlString:[self urlWithRenderAction:chapter.url]];
}

+ (BakaReaderDownload *)downloadForNovel:(Novel *)novel {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeNovelDetail;
    return [self configureDownload:download withUrlString:[self urlWithRenderAction:novel.url]];
}

+ (BakaReaderDownload *)downloadForNovelList {
    BakaReaderDownload *download = [[BakaReaderDownload alloc] init];
    download.downloadType = DownloadTypeNoveList;
    return [self configureDownload:download withUrlString:kBakaTsukiMainUrlEnglish];//should use render here?
}

+ (BakaReaderDownload *)configureDownload:(BakaReaderDownload *)download withUrlString:(NSString *)urlString {
    download.url = [NSURL URLWithString:urlString];
    download.request = [NSURLRequest requestWithURL:download.url];
    download.operation = [[AFHTTPRequestOperation alloc] initWithRequest:download.request];
    download.operation.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    download.operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak BakaReaderDownload *weakSelf = download;
    [download.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (weakSelf.progressUpdate) {
            CGFloat progress = 0.0;
            if (totalBytesExpectedToRead == -1) {
                progress = 0.2;
            } else {
                progress = totalBytesRead / totalBytesExpectedToRead;
            }
            weakSelf.progressUpdate(progress);
        }
    }];
    return download;
}


#pragma mark - Convenience

+ (NSString *)urlWithRenderAction:(NSString *)url {
    NSString *renderAction = @"?action=render&";
    return [url stringByReplacingOccurrencesOfString:@"?" withString:renderAction];
}


@end
