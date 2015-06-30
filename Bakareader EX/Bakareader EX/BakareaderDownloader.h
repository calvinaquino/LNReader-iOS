//
//  BakareaderDownloader.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/15/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BakaReaderDownloader : NSObject

@property (nonatomic, strong) UIProgressView *progressView;

+ (BakaReaderDownloader *)sharedInstance;

- (void)downloadImageFromUrl:(NSString *)imageUrl withCompletion:(void (^)(BOOL, UIImage *image))completionBlock;
- (void)downloadChapter:(Chapter *)chapter withCompletion:(void (^)(BOOL))completionBlock;
- (void)downloadNovelDetails:(Novel *)novel withCompletion:(void (^)(BOOL))completionBlock;
- (void)downloadNovelListWithCompletion:(void (^)(BOOL))completionBlock;

@end
