//
//  ChaptersTableViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/11/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChaptersTableViewController.h"
#import "ChapterContentViewController.h"
#import "BakaTsukiParser.h"

@interface ChaptersTableViewController () <ChapterDelegate>

@property (nonatomic, strong) Volume *volume;
@property (nonatomic, strong) NSArray *chapters;
@property (nonatomic, assign) BOOL resumingChapter;

@end

@implementation ChaptersTableViewController

- (instancetype)initResumingChapter {
    self = [self initWithVolume:[CoreDataController user].lastChapterRead.volume];
    if (self) {
        self.resumingChapter = YES;
    }
    
    return self;
}

- (instancetype)initWithVolume:(Volume *)volume {
    self = [super init];
    if (self) {
        self.volume = volume;
        self.resumingChapter = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.resumingChapter) {
        Chapter *chapter = [CoreDataController user].lastChapterRead;
        ChapterContentViewController *chapterContentViewController = [[ChapterContentViewController alloc] initWithChapter:chapter];
        chapterContentViewController.delegate = self;
        [self.navigationController pushViewController:chapterContentViewController animated:YES];
        self.resumingChapter = NO;
    }
}


#pragma mark - Overridden Methods

- (void)setVolume:(Volume *)volume {
    _volume = volume;
    self.chapters = [volume.chapters sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    self.title = volume.title;
}


#pragma mark - Private Methods


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    Chapter *chapter = self.chapters[indexPath.row];
    cell.textLabel.text = chapter.title;
    cell.accessoryType = chapter.fetchedValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Chapter *chapter = self.chapters[indexPath.row];
    
    ChapterContentViewController *chapterContentViewController = [[ChapterContentViewController alloc] initWithChapter:chapter];
    chapterContentViewController.delegate = self;
    [self.navigationController pushViewController:chapterContentViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Chapter *chapter = self.chapters[indexPath.row];
    BOOL downloaded = chapter.fetchedValue;
    
    UITableViewRowAction *downloadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Download" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Chapter *chapter = weakSelf.chapters[indexPath.row];
        
        [[BakaReaderDownloader sharedInstance] downloadChapter:chapter withCompletion:^(BOOL success) {
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf.tableView setEditing:NO animated:YES];
        Chapter *chapter = weakSelf.chapters[indexPath.row];
        
        chapter.content = nil;
        chapter.fetchedValue = NO;
        [chapter deleteImages];
        [CoreDataController saveContext];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    return downloaded ? @[deleteAction] : @[downloadAction];
}

#pragma mark - Chapter Delegate

- (void)chapterViewController:(UIViewController *)viewController didFetchChapter:(Chapter *)chapter {
    NSInteger chapterIndex = [self.chapters indexOfObject:chapter];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:chapterIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (Chapter *)chapterViewController:(UIViewController *)viewController didAskForNextChapterForCurrentChapter:(Chapter *)currentChapter {
    NSInteger chapterIndex = [self.chapters indexOfObject:currentChapter];
    BOOL isLastChapter = chapterIndex == self.chapters.count;
    
    if (!isLastChapter) {
        Chapter *nextChapter = self.chapters[chapterIndex + 1];
        return nextChapter;
    } else {
        //ask for next volume?
        return nil;
    }
}

- (Chapter *)chapterViewController:(UIViewController *)viewController didAskForPreviousChapterForCurrentChapter:(Chapter *)currentChapter {
    NSInteger chapterIndex = [self.chapters indexOfObject:currentChapter];
    BOOL isFirstChapter = chapterIndex == 0;
    
    if (!isFirstChapter) {
        Chapter *previousChapter = self.chapters[chapterIndex - 1];
        return previousChapter;
    } else {
        //ask for previous volume?
        return nil;
    }
}

@end
