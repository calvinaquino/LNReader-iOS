//
//  ChaptersTableViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/11/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChaptersTableViewController.h"
#import "ChapterContentViewController.h"
#import "BRTableViewCell.h"
#import "BakaTsukiParser.h"

@interface ChaptersTableViewController () <ChapterDelegate>

@property (nonatomic, strong) Volume *volume;
@property (nonatomic, strong) NSArray *chapters;

@property (nonatomic, assign) ChapterResumeSource resumeSource;

@end

@implementation ChaptersTableViewController

- (instancetype)initResumingChapter {
    self = [self initWithVolume:[CoreDataController user].lastChapterRead.volume];
    if (self) {
        self.resumeSource = ChapterResumeLastRead;
    }
    
    return self;
}

- (instancetype)initWithVolume:(Volume *)volume {
    return [self initWithVolume:volume resume:NO];
}

- (instancetype)initWithVolume:(Volume *)volume resume:(BOOL)resume {
    self = [super init];
    if (self) {
        self.volume = volume;
        self.resumeSource = resume ? ChapterResumeNovel : ChapterResumeNone;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BRTableViewCell class] forCellReuseIdentifier:[BRTableViewCell identifier]];
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.resumeSource != ChapterResumeNone) {
        Chapter *chapter = nil;
        if (self.resumeSource == ChapterResumeLastRead) {
            chapter = [CoreDataController user].lastChapterRead;
        } else {
            chapter = self.volume.novel.lastChapterRead;
        }
        ChapterContentViewController *chapterContentViewController = [[ChapterContentViewController alloc] initWithChapter:chapter];
        chapterContentViewController.delegate = self;
        [self.navigationController pushViewController:chapterContentViewController animated:YES];
        self.resumeSource = ChapterResumeNone;
    }
}


#pragma mark - Overridden Methods

- (void)setVolume:(Volume *)volume {
    _volume = volume;
    self.chapters = [volume.chapters sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    self.title = volume.title;
}


#pragma mark - Private Methods

- (void)showActionSheetForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Chapter *chapter = self.chapters[indexPath.row];
    BOOL isDownloaded = chapter.fetchedValue;
    BOOL isRead = chapter.readingProgressionValue > 0.95;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:chapter.title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *markReadAction = nil;
    if (isRead) {
        markReadAction = [UIAlertAction actionWithTitle:@"Mark as unread" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            Chapter *chapter = weakSelf.chapters[indexPath.row];
            chapter.readingProgressionValue = 0.0;
            [CoreDataController saveContext];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
    } else {
        markReadAction = [UIAlertAction actionWithTitle:@"Mark as read" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            Chapter *chapter = weakSelf.chapters[indexPath.row];
            chapter.readingProgressionValue = 1.0;
            [CoreDataController saveContext];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
    }
    
    UIAlertAction *downloadAction = nil;
    if (isDownloaded) {
        downloadAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf.tableView setEditing:NO animated:YES];
            Chapter *chapter = weakSelf.chapters[indexPath.row];
            
            chapter.content = nil;
            chapter.fetchedValue = NO;
            [chapter deleteImages];
            [CoreDataController saveContext];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else {
        downloadAction = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            Chapter *chapter = weakSelf.chapters[indexPath.row];
            
            [[BakaReaderDownloader sharedInstance] downloadChapter:chapter withCompletion:^(BOOL success) {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    [actionSheet addAction:markReadAction];
    [actionSheet addAction:downloadAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BRTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRTableViewCell *cell = (BRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[BRTableViewCell identifier] forIndexPath:indexPath];
    
    Chapter *chapter = self.chapters[indexPath.row];
    cell.title = chapter.title;
    cell.subtitle = chapter.fetchedValue ? @"Downloaded" : nil;
    cell.overflowEnabled = YES;
    cell.markedAsRead = chapter.readingProgressionValue > 0.95;
    
    __weak typeof(self) weakSelf = self;
    [cell setOverflowActionBlock:^(BRTableViewCell *brCell) {
        NSIndexPath *overflowIndexPath = [weakSelf.tableView indexPathForCell:brCell];
        [weakSelf showActionSheetForIndexPath:overflowIndexPath];
    }];
    
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

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//    Chapter *chapter = self.chapters[indexPath.row];
//    BOOL downloaded = chapter.fetchedValue;
//    
//    UITableViewRowAction *downloadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Download" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        Chapter *chapter = weakSelf.chapters[indexPath.row];
//        
//        [[BakaReaderDownloader sharedInstance] downloadChapter:chapter withCompletion:^(BOOL success) {
//            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }];
//        [weakSelf.tableView setEditing:NO animated:YES];
//    }];
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [weakSelf.tableView setEditing:NO animated:YES];
//        Chapter *chapter = weakSelf.chapters[indexPath.row];
//        
//        chapter.content = nil;
//        chapter.fetchedValue = NO;
//        [chapter deleteImages];
//        [CoreDataController saveContext];
//        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
//    
//    return downloaded ? @[deleteAction] : @[downloadAction];
//}

#pragma mark - Chapter Delegate

- (void)chapterViewController:(UIViewController *)viewController didFetchChapter:(Chapter *)chapter {
    NSInteger chapterIndex = [self.chapters indexOfObject:chapter];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:chapterIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (Chapter *)chapterViewController:(UIViewController *)viewController didAskForNextChapterForCurrentChapter:(Chapter *)currentChapter {
    NSInteger chapterIndex = [self.chapters indexOfObject:currentChapter];
    BOOL isLastChapter = currentChapter == [self.chapters lastObject];
    Chapter *nextChapter = nil;
    if (!isLastChapter) {
        nextChapter = self.chapters[chapterIndex + 1];
    } else {
        if ([self.delegate respondsToSelector:@selector(volumeViewController:didAskForNextVolumeForCurrentVolume:)]) {
            Volume *nextVolume = [self.delegate volumeViewController:self didAskForNextVolumeForCurrentVolume:self.volume];
            if (nextVolume) {
                self.volume = nextVolume;
                [self.tableView reloadData];
                nextChapter = [self.chapters firstObject];
            }
        }
    }
    
    return nextChapter;
}

- (Chapter *)chapterViewController:(UIViewController *)viewController didAskForPreviousChapterForCurrentChapter:(Chapter *)currentChapter {
    NSInteger chapterIndex = [self.chapters indexOfObject:currentChapter];
    BOOL isFirstChapter = currentChapter == [self.chapters firstObject];
    Chapter *previousChapter = nil;
    if (!isFirstChapter) {
        previousChapter = self.chapters[chapterIndex - 1];
    } else {
        if ([self.delegate respondsToSelector:@selector(volumeViewController:didAskForPreviousVolumeForCurrentVolume:)]) {
            Volume *previousVolume = [self.delegate volumeViewController:self didAskForPreviousVolumeForCurrentVolume:self.volume];
            if (previousVolume) {
                self.volume = previousVolume;
                [self.tableView reloadData];
                previousChapter = [self.chapters lastObject];
            }
        }
    }
    
    return previousChapter;
}

@end
