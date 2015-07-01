//
//  CoreDataController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "CoreDataController.h"

@implementation CoreDataController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataController *)sharedInstance {
    static dispatch_once_t onceToken;
    static CoreDataController *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        if (!_sharedInstance) {
            _sharedInstance = [[CoreDataController alloc] init];
        }
    });
    return _sharedInstance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.erakk.Bakareader_EX" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bakareader_EX" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bakareader_EX.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

+ (NSManagedObjectContext *)context {
    return [CoreDataController sharedInstance].managedObjectContext;
}

#pragma mark - Database Manipulation

+ (Chapter *)newChapter {
    return [Chapter insertInManagedObjectContext:[CoreDataController context]];
}

+ (Novel *)newNovel {
    return [Novel insertInManagedObjectContext:[CoreDataController context]];
}

+ (Volume *)newVolume {
    return [Volume insertInManagedObjectContext:[CoreDataController context]];
}

+ (Image *)newImage {
    return [Image insertInManagedObjectContext:[CoreDataController context]];
}

+ (NSArray *)allNovels {
    return [CoreDataController findRecordsEntityNamed:[Novel entityName] usingPredicate:nil];
}

+ (NSArray *)favoriteNovels {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == YES"];
    return [CoreDataController findRecordsEntityNamed:[Novel entityName] usingPredicate:predicate];
}

+ (NSArray *)allChaptersForVolume:(Volume *)volume {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"volume == %@",volume];
    return [CoreDataController findRecordsEntityNamed:[Volume entityName] usingPredicate:predicate];
}

+ (NSArray *)allVolumesForNovel:(Novel *)novel {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"novel == %@",novel];
    return [CoreDataController findRecordsEntityNamed:[Novel entityName] usingPredicate:predicate];
}

+ (Novel *)novelWithTitle:(NSString *)title {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",title];
    return [[CoreDataController findRecordsEntityNamed:[Novel entityName] usingPredicate:predicate] firstObject];
}

+ (Novel *)novelWithUrl:(NSString *)url {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@",url];
    return [[CoreDataController findRecordsEntityNamed:[Novel entityName] usingPredicate:predicate] firstObject];
}

+ (BOOL)novelAlreadyExistsForUrl:(NSString *)url {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@",url];
    return [CoreDataController countRecordsOfClass:[Novel class] usingPredicate:predicate];
}

+ (NSUInteger)countAllNovels {
    return [CoreDataController countRecordsOfClass:[Novel class] usingPredicate:nil];
}

#pragma mark - Generic Methods

+ (NSArray *)findRecordsEntityNamed:(NSString *)entityName usingPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [CoreDataController context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    [request setResultType:NSManagedObjectResultType];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Unresolved fetch error %@, %@", error, [error userInfo]);
    }
    return fetchedObjects;
}

+ (NSUInteger)countRecordsOfClass:(Class)class usingPredicate:(NSPredicate *)predicate {
    NSString *className = NSStringFromClass(class);
    NSManagedObjectContext *context = [CoreDataController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    [request setEntity:entity];
    [request setResultType:NSManagedObjectResultType];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSUInteger objectCount = [context countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Unresolved fetch error %@, %@", [error userInfo], error);
    }
    return objectCount;
}

#pragma mark - Core Data Saving support

+ (void)saveContext {
    [[CoreDataController sharedInstance] saveContext];
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
