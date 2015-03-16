// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Novel.m instead.

#import "_Novel.h"

const struct NovelAttributes NovelAttributes = {
	.coverImageName = @"coverImageName",
	.favorite = @"favorite",
	.fetched = @"fetched",
	.lastUpdated = @"lastUpdated",
	.synopsis = @"synopsis",
	.title = @"title",
	.url = @"url",
};

const struct NovelRelationships NovelRelationships = {
	.volumes = @"volumes",
};

@implementation NovelID
@end

@implementation _Novel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Novel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Novel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Novel" inManagedObjectContext:moc_];
}

- (NovelID*)objectID {
	return (NovelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"fetchedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fetched"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic coverImageName;

@dynamic favorite;

- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}

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

@dynamic lastUpdated;

@dynamic synopsis;

@dynamic title;

@dynamic url;

@dynamic volumes;

- (NSMutableSet*)volumesSet {
	[self willAccessValueForKey:@"volumes"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"volumes"];

	[self didAccessValueForKey:@"volumes"];
	return result;
}

@end

