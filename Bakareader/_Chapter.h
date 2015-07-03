// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.h instead.

#import <CoreData/CoreData.h>

extern const struct ChapterAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *fetched;
	__unsafe_unretained NSString *isExternal;
	__unsafe_unretained NSString *lastRead;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *readingProgression;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} ChapterAttributes;

extern const struct ChapterRelationships {
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *isLastRead;
	__unsafe_unretained NSString *user;
	__unsafe_unretained NSString *volume;
} ChapterRelationships;

@class Image;
@class Novel;
@class User;
@class Volume;

@interface ChapterID : NSManagedObjectID {}
@end

@interface _Chapter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ChapterID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* fetched;

@property (atomic) BOOL fetchedValue;
- (BOOL)fetchedValue;
- (void)setFetchedValue:(BOOL)value_;

//- (BOOL)validateFetched:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isExternal;

@property (atomic) BOOL isExternalValue;
- (BOOL)isExternalValue;
- (void)setIsExternalValue:(BOOL)value_;

//- (BOOL)validateIsExternal:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastRead;

//- (BOOL)validateLastRead:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* order;

@property (atomic) int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* readingProgression;

@property (atomic) float readingProgressionValue;
- (float)readingProgressionValue;
- (void)setReadingProgressionValue:(float)value_;

//- (BOOL)validateReadingProgression:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *images;

- (NSMutableSet*)imagesSet;

@property (nonatomic, strong) Novel *isLastRead;

//- (BOOL)validateIsLastRead:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Volume *volume;

//- (BOOL)validateVolume:(id*)value_ error:(NSError**)error_;

@end

@interface _Chapter (ImagesCoreDataGeneratedAccessors)
- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(Image*)value_;
- (void)removeImagesObject:(Image*)value_;

@end

@interface _Chapter (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSNumber*)primitiveFetched;
- (void)setPrimitiveFetched:(NSNumber*)value;

- (BOOL)primitiveFetchedValue;
- (void)setPrimitiveFetchedValue:(BOOL)value_;

- (NSNumber*)primitiveIsExternal;
- (void)setPrimitiveIsExternal:(NSNumber*)value;

- (BOOL)primitiveIsExternalValue;
- (void)setPrimitiveIsExternalValue:(BOOL)value_;

- (NSDate*)primitiveLastRead;
- (void)setPrimitiveLastRead:(NSDate*)value;

- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;

- (NSNumber*)primitiveReadingProgression;
- (void)setPrimitiveReadingProgression:(NSNumber*)value;

- (float)primitiveReadingProgressionValue;
- (void)setPrimitiveReadingProgressionValue:(float)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;

- (Novel*)primitiveIsLastRead;
- (void)setPrimitiveIsLastRead:(Novel*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

- (Volume*)primitiveVolume;
- (void)setPrimitiveVolume:(Volume*)value;

@end
