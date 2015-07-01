#import "Chapter.h"


@interface Chapter ()

// Private interface goes here.

@end


@implementation Chapter

// Custom logic goes here.
- (Image *)imageForUrl:(NSString *)imageUrl {
    for (Image *image in self.images.allObjects) {
        if ([image.url isEqualToString:imageUrl]) {
            return image;
        }
    }
    
    Image *newImage = [CoreDataController newImage];
    newImage.chapter = self;
    newImage.url = imageUrl;
    
    [CoreDataController saveContext];
    return newImage;
}

- (void)deleteImages {
    for (Image *image in self.images.allObjects) {
        [image deleteImageFile];
        [[CoreDataController context] deleteObject:image];
    }
    
    [CoreDataController saveContext];
}

@end
