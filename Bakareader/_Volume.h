// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Volume.h instead.

#import <CoreData/CoreData.h>


extern const struct VolumeAttributes {
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} VolumeAttributes;

extern const struct VolumeRelationships {
	__unsafe_unretained NSString *chapters;
	__unsafe_unretained NSString *novel;
} VolumeRelationships;

extern const struct VolumeFetchedProperties {
} VolumeFetchedProperties;

@class Chapter;
@class Novel;





@interface VolumeID : NSManagedObjectID {}
@end

@interface _Volume : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VolumeID*)objectID;





@property (nonatomic, strong) NSNumber* order;



@property int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *chapters;

- (NSMutableSet*)chaptersSet;




@property (nonatomic, strong) Novel *novel;

//- (BOOL)validateNovel:(id*)value_ error:(NSError**)error_;





@end

@interface _Volume (CoreDataGeneratedAccessors)

- (void)addChapters:(NSSet*)value_;
- (void)removeChapters:(NSSet*)value_;
- (void)addChaptersObject:(Chapter*)value_;
- (void)removeChaptersObject:(Chapter*)value_;

@end

@interface _Volume (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveChapters;
- (void)setPrimitiveChapters:(NSMutableSet*)value;



- (Novel*)primitiveNovel;
- (void)setPrimitiveNovel:(Novel*)value;


@end
