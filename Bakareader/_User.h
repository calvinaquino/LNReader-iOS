// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>

extern const struct UserRelationships {
	__unsafe_unretained NSString *lastChapterRead;
} UserRelationships;

@class Chapter;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID* objectID;

@property (nonatomic, strong) Chapter *lastChapterRead;

//- (BOOL)validateLastChapterRead:(id*)value_ error:(NSError**)error_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (Chapter*)primitiveLastChapterRead;
- (void)setPrimitiveLastChapterRead:(Chapter*)value;

@end
