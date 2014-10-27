// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Novel.h instead.

#import <CoreData/CoreData.h>


extern const struct NovelAttributes {
	__unsafe_unretained NSString *coverImageName;
	__unsafe_unretained NSString *favorite;
	__unsafe_unretained NSString *fetched;
	__unsafe_unretained NSString *lastUpdated;
	__unsafe_unretained NSString *synopsis;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} NovelAttributes;

extern const struct NovelRelationships {
	__unsafe_unretained NSString *volumes;
} NovelRelationships;

extern const struct NovelFetchedProperties {
} NovelFetchedProperties;

@class Volume;









@interface NovelID : NSManagedObjectID {}
@end

@interface _Novel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NovelID*)objectID;





@property (nonatomic, strong) NSString* coverImageName;



//- (BOOL)validateCoverImageName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* favorite;



@property BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;

//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fetched;



@property BOOL fetchedValue;
- (BOOL)fetchedValue;
- (void)setFetchedValue:(BOOL)value_;

//- (BOOL)validateFetched:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastUpdated;



//- (BOOL)validateLastUpdated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* synopsis;



//- (BOOL)validateSynopsis:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *volumes;

- (NSMutableSet*)volumesSet;





@end

@interface _Novel (CoreDataGeneratedAccessors)

- (void)addVolumes:(NSSet*)value_;
- (void)removeVolumes:(NSSet*)value_;
- (void)addVolumesObject:(Volume*)value_;
- (void)removeVolumesObject:(Volume*)value_;

@end

@interface _Novel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCoverImageName;
- (void)setPrimitiveCoverImageName:(NSString*)value;




- (NSNumber*)primitiveFavorite;
- (void)setPrimitiveFavorite:(NSNumber*)value;

- (BOOL)primitiveFavoriteValue;
- (void)setPrimitiveFavoriteValue:(BOOL)value_;




- (NSNumber*)primitiveFetched;
- (void)setPrimitiveFetched:(NSNumber*)value;

- (BOOL)primitiveFetchedValue;
- (void)setPrimitiveFetchedValue:(BOOL)value_;




- (NSDate*)primitiveLastUpdated;
- (void)setPrimitiveLastUpdated:(NSDate*)value;




- (NSString*)primitiveSynopsis;
- (void)setPrimitiveSynopsis:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveVolumes;
- (void)setPrimitiveVolumes:(NSMutableSet*)value;


@end
