//
//  ChaptersTableViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/11/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChaptersTableViewController.h"
#import "ChapterContentViewController.h"
#import "ExternalContentViewController.h"
#import "BakaTsukiParser.h"

@interface ChaptersTableViewController () <ChapterDelegate>

@property (nonatomic, strong) Volume *volume;
@property (nonatomic, strong) NSArray *chapters;

@end

@implementation ChaptersTableViewController

- (instancetype)initWithVolume:(Volume *)volume {
    self = [super init];
    if (self) {
        self.volume = volume;
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
    
    if (chapter.isExternalValue) {
        ExternalContentViewController *externalContentViewController = [[ExternalContentViewController alloc] initWithChapter:chapter];
        externalContentViewController.delegate = self;
        [self.navigationController pushViewController:externalContentViewController animated:YES];
    } else {
        ChapterContentViewController *chapterContentViewController = [[ChapterContentViewController alloc] initWithChapter:chapter];
        chapterContentViewController.delegate = self;
        [self.navigationController pushViewController:chapterContentViewController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Chapter *chapter = self.chapters[indexPath.row];
    return  !chapter.fetchedValue;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Chapter *chapter = self.chapters[indexPath.row];
    BOOL canDownload = !chapter.fetchedValue;
    
    UITableViewRowAction *downloadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Download" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Chapter *chapter = weakSelf.chapters[indexPath.row];
        
        [[BakaReaderDownloader sharedInstance] downloadChapter:chapter withCompletion:^(BOOL success) {
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    
    return canDownload ? @[downloadAction] : nil;
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
