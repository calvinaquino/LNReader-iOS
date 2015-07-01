// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.m instead.

#import "_Chapter.h"

const struct ChapterAttributes ChapterAttributes = {
	.content = @"content",
	.fetched = @"fetched",
	.isExternal = @"isExternal",
	.order = @"order",
	.readingProgression = @"readingProgression",
	.title = @"title",
	.url = @"url",
};

const struct ChapterRelationships ChapterRelationships = {
	.images = @"images",
	.volume = @"volume",
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

	if ([key isEqualToString:@"fetchedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fetched"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isExternalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isExternal"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"readingProgressionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"readingProgression"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic content;

@dynamic fetched;

- (BOOL)fetchedValue {
	NSNumber *result = [self fetched];
	return [result boolValue];
}

- (void)setFetchedValue:(BOOL)value_ {
	[self setFetched:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFetchedValue {
	NSNumber *result = [self primitiveFetched];
	return [result boolValue];
}

- (void)setPrimitiveFetchedValue:(BOOL)value_ {
	[self setPrimitiveFetched:[NSNumber numberWithBool:value_]];
}

@dynamic isExternal;

- (BOOL)isExternalValue {
	NSNumber *result = [self isExternal];
	return [result boolValue];
}

- (void)setIsExternalValue:(BOOL)value_ {
	[self setIsExternal:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsExternalValue {
	NSNumber *result = [self primitiveIsExternal];
	return [result boolValue];
}

- (void)setPrimitiveIsExternalValue:(BOOL)value_ {
	[self setPrimitiveIsExternal:[NSNumber numberWithBool:value_]];
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

@dynamic readingProgression;

- (float)readingProgressionValue {
	NSNumber *result = [self readingProgression];
	return [result floatValue];
}

- (void)setReadingProgressionValue:(float)value_ {
	[self setReadingProgression:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveReadingProgressionValue {
	NSNumber *result = [self primitiveReadingProgression];
	return [result floatValue];
}

- (void)setPrimitiveReadingProgressionValue:(float)value_ {
	[self setPrimitiveReadingProgression:[NSNumber numberWithFloat:value_]];
}

@dynamic title;

@dynamic url;

@dynamic images;

- (NSMutableSet*)imagesSet {
	[self willAccessValueForKey:@"images"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"images"];

	[self didAccessValueForKey:@"images"];
	return result;
}

@dynamic volume;

@end

