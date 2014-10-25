// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Novel.m instead.

#import "_Novel.h"

const struct NovelAttributes NovelAttributes = {
	.btUrlTitle = @"btUrlTitle",
	.coverImageName = @"coverImageName",
	.favorite = @"favorite",
	.lastUpdated = @"lastUpdated",
	.synopsis = @"synopsis",
	.title = @"title",
};

const struct NovelRelationships NovelRelationships = {
	.volumes = @"volumes",
};

const struct NovelFetchedProperties NovelFetchedProperties = {
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

	return keyPaths;
}




@dynamic btUrlTitle;






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





@dynamic lastUpdated;






@dynamic synopsis;






@dynamic title;






@dynamic volumes;

	






@end
