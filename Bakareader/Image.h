#import "_Image.h"

@interface Image : _Image {}

- (void)fetchImageIfNeededWithCompletion:(void (^)(UIImage *))completionBlock;
- (void)deleteImageFile;

+ (void)saveImageData:(NSData *)imageData forImage:(Image *)image;

@end
