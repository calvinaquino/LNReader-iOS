//
//  BakareaderDownloader.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/15/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BakaReaderDownloaderDelegate;

@interface BakaReaderDownloader : NSObject

@property (nonatomic, weak) id<BakaReaderDownloaderDelegate> delegate;

+ (BakaReaderDownloader *)sharedInstance;

- (void)downloadChapter:(Chapter *)chapter withCompletion:(void (^)(BOOL))completionBlock;
- (void)downloadNovelDetails:(Novel *)novel withCompletion:(void (^)(BOOL))completionBlock;
- (void)downloadNovelListWithCompletion:(void (^)(BOOL))completionBlock;

@end

@protocol BakaReaderDownloaderDelegate <NSObject>

@optional
- (void)bakaReaderDownloader:(BakaReaderDownloader *)bakaReaderDownloader didUpdateDownloadProgressTo:(CGFloat)progress fromChapter:(Chapter *)chapter;
- (void)bakaReaderDownloader:(BakaReaderDownloader *)bakaReaderDownloader didFinishDownloadingChapter:(Chapter *)chapter;

- (void)bakaReaderDownloader:(BakaReaderDownloader *)bakaReaderDownloader didUpdateDownloadProgressTo:(CGFloat)progress fromNovel:(Novel *)novel;
- (void)bakaReaderDownloader:(BakaReaderDownloader *)bakaReaderDownloader didFinishDownliadingNovel:(Novel *)novel;

- (void)bakaReaderDownloader:(BakaReaderDownloader *)bakaReaderDownloader didUpdateNovelListDownloadProgressTo:(CGFloat)progress;
- (void)bakaReaderDownloaderDidFinishDownloadingNovelList:(BakaReaderDownloader *)bakaReaderDownloader;

@end