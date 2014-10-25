//
//  CoreDataController.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Novel, Volume, Chapter;

@interface CoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataController *)sharedInstance;
+ (NSManagedObjectContext *)context;
+ (void)saveContext;

+ (Novel *)newNovel;
+ (Volume *)newVolume;
+ (Chapter *)newChapter;

+ (NSArray *)allNovels;
+ (NSArray *)allVolumesForNovel:(Novel *)novel;
+ (NSArray *)allChaptersForVolume:(Volume *)volume;

@end
