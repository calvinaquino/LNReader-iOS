#import "Novel.h"


@interface Novel ()

// Private interface goes here.

@end


@implementation Novel

- (void)deleteVolumes {
    for (Volume *volume in self.volumes.allObjects) {
        [volume deleteChapters];
        [[CoreDataController context] deleteObject:volume];
    }
    
    [CoreDataController saveContext];
}

@end
