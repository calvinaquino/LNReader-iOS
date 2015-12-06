#import "Image.h"

@interface Image ()

// Private interface goes here.

@end

@implementation Image

- (void)fetchImageIfNeededWithCompletion:(void (^)(UIImage *))completionBlock {
    if ([self imageFileExists]) {
        NSLog(@"image %@ already exists", self.url);
        if (completionBlock) {
            completionBlock([self imageFromDisk]);
        }
    } else {
        NSLog(@"image %@ being fetched", self.url);
        [[BakaReaderDownloader sharedInstance] downloadImage:self withCompletion:^(BOOL success) {
            if (success && completionBlock) {
                NSLog(@"image %@ fetched", self.url);
                completionBlock([self imageFromDisk]);
            }
        }];
    }
}

- (void)deleteImageFile {
    if ([self imageFileExists]) {
        NSError *deleteError = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[self fileUrl] error:&deleteError];
        if (deleteError) {
            NSLog(@"Error deleting image at path %@", [self fileUrl]);
        }
    }
}

//- (UIImage *)imageFromDisk {
//    NSData *imageData = [NSData dataWithContentsOfFile:self.fileUrl];
//    return [UIImage imageWithData:imageData];
//}

+ (void)saveImageData:(NSData *)imageData forImage:(Image *)image {
    [image saveImageOnDiskWithData:imageData];
}

#pragma mark - Image File Handling

+ (NSString *)imageStoragePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *storage = [paths objectAtIndex:0];
    return storage;
}

- (NSString *)imageFileNameFromUrl {
    NSArray *decomposedUrl = [self.url componentsSeparatedByString:@":"];
    return [decomposedUrl lastObject];
}

- (NSString *)fileUrl {
    return [NSString stringWithFormat:@"%@/%@", [Image imageStoragePath], [self imageFileNameFromUrl]];
}

- (void)saveImageOnDiskWithData:(NSData *)imageData {
    NSString *savingImagePath = [self fileUrl];
    NSError *writeError = nil;
    if(![imageData writeToFile:savingImagePath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"%@: Error saving image: %@", [self class], [writeError localizedDescription]);
    }
}

- (BOOL)imageFileExists {
    NSString *savingImagePath = [self fileUrl];
    return [[NSFileManager defaultManager] fileExistsAtPath:savingImagePath isDirectory:NO];
}

- (UIImage *)imageFromDisk {
    NSString *savingImagePath = [self fileUrl];
    NSError *readError = nil;
    NSData *imageData = [NSData dataWithContentsOfFile:savingImagePath options:0 error:&readError];
    
    if (!readError) {
        return [UIImage imageWithData:imageData];
    } else {
        NSLog(@"Error saving image: %@", [readError localizedDescription]);
        return nil;
    }
}

@end
