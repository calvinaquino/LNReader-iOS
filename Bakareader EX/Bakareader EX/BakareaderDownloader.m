//
//  BakareaderDownloader.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/15/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "BakaReaderDownloader.h"
#import "BakaReaderDownload.h"
#import "BakaTsukiParser.h"
#import "AFNetworking.h"

@interface BakaReaderDownloader ()

@property (nonatomic, strong) NSMutableArray *downloadQueue;
@property (nonatomic, strong) BakaReaderDownload *currentDownload;

@end

@implementation BakaReaderDownloader

+ (BakaReaderDownloader *)sharedInstance {
    static dispatch_once_t onceToken;
    static BakaReaderDownloader *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        if (!_sharedInstance) {
            _sharedInstance = [[BakaReaderDownloader alloc] init];
        }
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.downloadQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - Public Methods

- (void)downloadChapter:(Chapter *)chapter withCompletion:(void (^)(BOOL))completionBlock {
    BakaReaderDownload *download = [BakaReaderDownload downloadForChapter:chapter];
    
    [download.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [BakaTsukiParser parseChapterContent:chapter fromData:(NSData *)responseObject];
        if (completionBlock) {
            completionBlock(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completionBlock) {
            completionBlock(NO);
        }
    }];
    
    [download.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%li/%li", (long)totalBytesRead, (long)totalBytesExpectedToRead);
    }];
    
    
    [self addDownload:download];
}

- (void)downloadNovelDetails:(Novel *)novel withCompletion:(void (^)(BOOL))completionBlock {
    BakaReaderDownload *download = [BakaReaderDownload downloadForNovel:novel];
    
    [download.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [BakaTsukiParser parseNovelInfo:novel fromData:(NSData *)responseObject];
        if (completionBlock) {
            completionBlock(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completionBlock) {
            completionBlock(NO);
        }
    }];
    
    [download.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%li/%li", (long)totalBytesRead, (long)totalBytesExpectedToRead);
    }];
    
    [self addDownload:download];
}

- (void)downloadNovelListWithCompletion:(void (^)(BOOL))completionBlock {
    BakaReaderDownload *download = [BakaReaderDownload downloadForNovelList];
    
    [download.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [BakaTsukiParser parseNovelListFromData:(NSData *)responseObject];
        if (completionBlock) {
            completionBlock(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completionBlock) {
            completionBlock(NO);
        }
    }];
    
    [download.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%li/%li", (long)totalBytesRead, (long)totalBytesExpectedToRead);
    }];
    
    [self addDownload:download];
}


#pragma mark - Private Methods

- (void)addDownload:(BakaReaderDownload *)download {
    [self.downloadQueue addObject:download];
    [self startNextDownload];
}

- (void)startNextDownload {
    if (self.downloadQueue.count) {
        self.currentDownload = [self.downloadQueue firstObject];
        [self.downloadQueue removeObject:self.currentDownload];

        //put on background queue
        [[NSOperationQueue currentQueue] addOperation:self.currentDownload.operation];
//        [self.currentDownload.operation resume];
        
    }
}

- (NSURLConnection *)connectionForURLString:(NSString *)urlString {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



@end
