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
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    }
    
    return self;
}


#pragma mark - Public Methods

- (void)downloadImageFromUrl:(NSString *)imageUrl withCompletion:(void (^)(BOOL success, UIImage *image))completionBlock {
    if ([self imageExistsForUrl:imageUrl]) {
        if (completionBlock) {
            UIImage *savedImage = [self imageFromDiskForUrl:imageUrl];
            completionBlock(YES, savedImage);
        }
        return;
    }
    
    BakaReaderDownload *download = [BakaReaderDownload downloadForImageUrl:imageUrl];
    
    __weak BakaReaderDownloader *weakSelf = self;
    [download.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *imageFileUrl = [BakaTsukiParser imageSourceUrlFromData:(NSData *)responseObject];
        NSString *fullImageFileUrl = [NSString stringWithFormat:@"%@%@", kBakaTsukiBaseUrl, imageFileUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullImageFileUrl]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, UIImage *image) {
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                [self saveImageOnDiskWithData:imageData forUrl:imageUrl];
            }
            
            if (completionBlock) {
                completionBlock(YES, image);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error fetching image data: %@", error);
            if (completionBlock) {
                completionBlock(NO, nil);
            }
        }];
        
        [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if (weakSelf.progressView) {
                CGFloat progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
                weakSelf.progressView.progress = 0.5 + (progress * 0.5);
            }
        }];
        
        [requestOperation start];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching image link: %@", error);
        if (completionBlock) {
            completionBlock(NO, nil);
        }
    }];
    
    [download.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (weakSelf.progressView) {
            CGFloat progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
            weakSelf.progressView.progress = progress * 0.5;
        }
    }];
    
    [self addDownload:download];
}

- (void)downloadChapter:(Chapter *)chapter withCompletion:(void (^)(BOOL))completionBlock {
    BakaReaderDownload *download = [BakaReaderDownload downloadForChapter:chapter];
    
//    __weak typeof(self) weakSelf = self;
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
    }];
    
    [self addDownload:download];
}

- (void)downloadNovelDetails:(Novel *)novel withCompletion:(void (^)(BOOL))completionBlock {
    BakaReaderDownload *download = [BakaReaderDownload downloadForNovel:novel];
    
//    __weak typeof(self) weakSelf = self;
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
    }];
    [self addDownload:download];
}

- (void)downloadNovelListWithCompletion:(void (^)(BOOL))completionBlock {
    BakaReaderDownload *download = [BakaReaderDownload downloadForNovelList];
    
//    __weak typeof(self) weakSelf = self;
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


#pragma mark - Image Handling

- (NSString *)imageStoragePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *storage = [paths objectAtIndex:0];
    return storage;
}

- (NSString *)imageFileNameFromUrl:(NSString *)imageUrl {
    return [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
}

- (NSString *)imagePathForUrl:(NSString *)imageUrl {
    return [NSString stringWithFormat:@"%@/%@", [self imageStoragePath], [self imageFileNameFromUrl:imageUrl]];
}

- (void)saveImageOnDiskWithData:(NSData *)imageData forUrl:(NSString *)imageUrl {
    NSString *savingImagePath = [self imagePathForUrl:imageUrl];
    NSError *writeError = nil;
    if(![imageData writeToFile:savingImagePath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"%@: Error saving image: %@", [self class], [writeError localizedDescription]);
    }
}

- (BOOL)imageExistsForUrl:(NSString *)imageUrl {
    NSString *savingImagePath = [self imagePathForUrl:imageUrl];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:savingImagePath isDirectory:NO];
}

- (UIImage *)imageFromDiskForUrl:(NSString *)imageUrl {
    NSString *savingImagePath = [self imagePathForUrl:imageUrl];
    NSError *readError = nil;
    NSData *imageData = [NSData dataWithContentsOfFile:savingImagePath options:0 error:&readError];
    
    if (!readError) {
        return [UIImage imageWithData:imageData];
    } else {
        NSLog(@"%@: Error saving image: %@", [self class], [readError localizedDescription]);
        return nil;
    }
}

@end
