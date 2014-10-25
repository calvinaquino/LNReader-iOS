// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.h instead.

#import <CoreData/CoreData.h>


extern const struct ChapterAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *title;
} ChapterAttributes;

extern const struct ChapterRelationships {
	__unsafe_unretained NSString *volume;
} ChapterRelationships;

extern const struct ChapterFetchedProperties {
} ChapterFetchedProperties;

@class Volume;





@interface ChapterID : NSManagedObjectID {}
@end

@interface _Chapter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChapterID*)objectID;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* order;



@property int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Volume *volume;

//- (BOOL)validateVolume:(id*)value_ error:(NSError**)error_;





@end

@interface _Chapter (CoreDataGeneratedAccessors)

@end

@interface _Chapter (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (Volume*)primitiveVolume;
- (void)setPrimitiveVolume:(Volume*)value;


@end
