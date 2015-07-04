#import "_Chapter.h"

@interface Chapter : _Chapter {}

- (Image *)imageForUrl:(NSString *)imageUrl;
- (void)deleteImages;
- (NSString *)progressDescription;

@end
