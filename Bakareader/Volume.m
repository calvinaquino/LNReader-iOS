#import "Volume.h"


@interface Volume ()

// Private interface goes here.

@end


@implementation Volume

- (void)deleteChapters {
    for (Chapter *chapter in self.chapters.allObjects) {
        [chapter deleteImages];
        [[CoreDataController context] deleteObject:chapter];
    }
    
    [CoreDataController saveContext];
}

@end
