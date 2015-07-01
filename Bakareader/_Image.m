// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.m instead.

#import "_Image.h"

const struct ImageAttributes ImageAttributes = {
	.fetched = @"fetched",
	.fileUrl = @"fileUrl",
	.url = @"url",
};

const struct ImageRelationships ImageRelationships = {
	.chapter = @"chapter",
	.novel = @"novel",
	.volume = @"volume",
};

@implementation ImageID
@end

@implementation _Image

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Image";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:moc_];
}

- (ImageID*)objectID {
	return (ImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"fetchedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fetched"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
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

@dynamic fileUrl;

@dynamic url;

@dynamic chapter;

@dynamic novel;

@dynamic volume;

@end

