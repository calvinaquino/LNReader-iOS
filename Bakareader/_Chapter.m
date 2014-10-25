// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.m instead.

#import "_Chapter.h"

const struct ChapterAttributes ChapterAttributes = {
	.content = @"content",
	.order = @"order",
	.title = @"title",
	.url = @"url",
};

const struct ChapterRelationships ChapterRelationships = {
	.volume = @"volume",
};

const struct ChapterFetchedProperties ChapterFetchedProperties = {
};

@implementation ChapterID
@end

@implementation _Chapter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Chapter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Chapter" inManagedObjectContext:moc_];
}

- (ChapterID*)objectID {
	return (ChapterID*)[super objectID];
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




@dynamic content;






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






@dynamic volume;

	






@end
