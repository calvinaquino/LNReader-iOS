// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Volume.m instead.

#import "_Volume.h"

const struct VolumeAttributes VolumeAttributes = {
	.order = @"order",
	.title = @"title",
	.url = @"url",
};

const struct VolumeRelationships VolumeRelationships = {
	.chapters = @"chapters",
	.novel = @"novel",
};

const struct VolumeFetchedProperties VolumeFetchedProperties = {
};

@implementation VolumeID
@end

@implementation _Volume

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Volume" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Volume";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Volume" inManagedObjectContext:moc_];
}

- (VolumeID*)objectID {
	return (VolumeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic order;



- (int16_t)orderValue {
	NSNumber *result = [self order];
	return [result shortValue];
}

- (void)setOrderValue:(int16_t)value_ {
	[self setOrder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result shortValue];
}

- (void)setPrimitiveOrderValue:(int16_t)value_ {
	[self setPrimitiveOrder:[NSNumber numberWithShort:value_]];
}





@dynamic title;






@dynamic url;






@dynamic chapters;

	
- (NSMutableSet*)chaptersSet {
	[self willAccessValueForKey:@"chapters"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"chapters"];
  
	[self didAccessValueForKey:@"chapters"];
	return result;
}
	

@dynamic novel;

	






@end
