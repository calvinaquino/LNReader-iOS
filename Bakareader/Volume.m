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

- (NSString *)progressAndSizeDescription {
    CGFloat totalProgress = 0.0;
    
    for (Chapter *chapter in self.chapters.allObjects) {
        totalProgress += chapter.readingProgressionValue;
    }
    
    totalProgress = 100 * totalProgress / (CGFloat)self.chapters.allObjects.count;
    
    if (totalProgress < 1) {
        return [NSString stringWithFormat:@"Chapters: %i", self.chapters.allObjects.count];
    } else {
        return [NSString stringWithFormat:@"Chapters: %i - Reading progress: %.0f%%", self.chapters.allObjects.count, totalProgress];
    }
}

@end
