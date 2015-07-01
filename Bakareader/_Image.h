// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#import <CoreData/CoreData.h>

extern const struct ImageAttributes {
	__unsafe_unretained NSString *fetched;
	__unsafe_unretained NSString *fileUrl;
	__unsafe_unretained NSString *url;
} ImageAttributes;

extern const struct ImageRelationships {
	__unsafe_unretained NSString *chapter;
	__unsafe_unretained NSString *novel;
	__unsafe_unretained NSString *volume;
} ImageRelationships;

@class Chapter;
@class Novel;
@class Volume;

@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ImageID* objectID;

@property (nonatomic, strong) NSNumber* fetched;

@property (atomic) BOOL fetchedValue;
- (BOOL)fetchedValue;
- (void)setFetchedValue:(BOOL)value_;

//- (BOOL)validateFetched:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fileUrl;

//- (BOOL)validateFileUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Chapter *chapter;

//- (BOOL)validateChapter:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Novel *novel;

//- (BOOL)validateNovel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Volume *volume;

//- (BOOL)validateVolume:(id*)value_ error:(NSError**)error_;

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFetched;
- (void)setPrimitiveFetched:(NSNumber*)value;

- (BOOL)primitiveFetchedValue;
- (void)setPrimitiveFetchedValue:(BOOL)value_;

- (NSString*)primitiveFileUrl;
- (void)setPrimitiveFileUrl:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (Chapter*)primitiveChapter;
- (void)setPrimitiveChapter:(Chapter*)value;

- (Novel*)primitiveNovel;
- (void)setPrimitiveNovel:(Novel*)value;

- (Volume*)primitiveVolume;
- (void)setPrimitiveVolume:(Volume*)value;

@end
