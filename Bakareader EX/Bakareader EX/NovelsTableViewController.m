//
//  ViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "NovelsTableViewController.h"
#import "NovelDetailViewController.h"
#import "BRTableViewCell.h"

#import "BakaTsukiParser.h"

@interface NovelsTableViewController () <NovelDetailDelegate>

@property (nonatomic, assign) BOOL onlyFavorites;
@property (nonatomic, strong) NSArray *novels;
@property (nonatomic, assign) BOOL resumingChapter;

@end

@implementation NovelsTableViewController

- (instancetype)initWithFavorites {
    self = [super init];
    if (self) {
        self.title = @"Watch List";
        self.onlyFavorites = YES;
        self.resumingChapter = NO;
    }
    
    return self;
}

- (instancetype)initResuminngChapter {
    self = [self init];
    if (self) {
        self.resumingChapter = YES;
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Light Novels";
        self.onlyFavorites = NO;
        self.resumingChapter = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BRTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BRTableViewCell class])];
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(loadListFromInternet) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self loadList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.resumingChapter) {
        
        NovelDetailViewController *novelDetailViewController = [[NovelDetailViewController alloc] initResumingChapter];
        novelDetailViewController.delegate = self;
        [self.splitViewController showDetailViewController:novelDetailViewController sender:self];
        
        self.resumingChapter = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Load Data

- (void)loadList {
    if ([CoreDataController countAllNovels]) {
        [self loadListFromDatabase];
    } else {
        [self loadListFromInternet];
    }
}

- (void)loadListFromDatabase {
    self.novels = self.onlyFavorites? [CoreDataController favoriteNovels] : [CoreDataController allNovels];
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    [self.tableView reloadData];
}

- (void)loadListFromInternet {
    [[BakaReaderDownloader sharedInstance] downloadNovelListWithCompletion:^(BOOL success) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self loadListFromDatabase];
        }];
    }];
}

- (void)showActionSheetForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Novel *novel = weakSelf.novels[indexPath.row];
    BOOL isDownloaded = novel.fetchedValue;
    NSString *favoriteTitle = novel.favoriteValue ? @"Unfavorite" : @"Favorite";
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:novel.title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *resumeAction = [UIAlertAction actionWithTitle:@"Resume" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        Novel *novel = weakSelf.novels[indexPath.row];;
        BOOL resume = novel.lastChapterRead != nil;
        NovelDetailViewController *novelDetailViewController = [[NovelDetailViewController alloc] initWithNovel:novel resume:resume];
        novelDetailViewController.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:novelDetailViewController animated:YES];
        
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    
    UIAlertAction *favoriteAction = [UIAlertAction actionWithTitle:favoriteTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        Novel *novel = weakSelf.novels[indexPath.row];
        novel.favoriteValue = !novel.favoriteValue;
        [CoreDataController saveContext];
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    
    
    UIAlertAction *downloadAction = nil;
    if (isDownloaded) {
        downloadAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            Novel *novel = weakSelf.novels[indexPath.row];
            
            novel.fetchedValue = NO;
            [novel.cover deleteImageFile];
            [[CoreDataController context] deleteObject:novel.cover];
            novel.synopsis = nil;
            [novel deleteVolumes];
            
            [CoreDataController saveContext];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
    } else {
        downloadAction = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            Novel *novel = weakSelf.novels[indexPath.row];
            [[BakaReaderDownloader sharedInstance] downloadNovelDetails:novel withCompletion:^(BOOL success) {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    if (novel.lastChapterRead) {
        [actionSheet addAction:resumeAction];
    }
    [actionSheet addAction:favoriteAction];
    [actionSheet addAction:downloadAction];
    [actionSheet addAction:cancelAction];
    
    BRTableViewCell *cell =  (BRTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    actionSheet.popoverPresentationController.sourceView = cell.viewForOverflowButton;
    actionSheet.popoverPresentationController.sourceRect = cell.viewForOverflowButton.frame;
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.novels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BRTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Novel *novel = self.novels[indexPath.row];
    
    NovelDetailViewController *novelDetailViewController = [[NovelDetailViewController alloc] initWithNovel:novel];
    novelDetailViewController.delegate = self;
    [self.splitViewController showDetailViewController:novelDetailViewController sender:self];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRTableViewCell *cell = (BRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BRTableViewCell class]) forIndexPath:indexPath];
    
    Novel *novel = self.novels[indexPath.row];
    cell.title = novel.title;
    cell.subtitle = novel.fetchedValue ? @"Downloaded" : nil;
    cell.overflowEnabled = YES;
    
    __weak typeof(self) weakSelf = self;
    [cell setOverflowActionBlock:^(BRTableViewCell *brCell) {
        NSIndexPath *overflowIndexPath = [weakSelf.tableView indexPathForCell:brCell];
        [weakSelf showActionSheetForIndexPath:overflowIndexPath];
    }];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//    UITableViewRowAction *moreActions = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Options" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [weakSelf showActionSheetForIndexPath:indexPath];
//    }];
//    return @[moreActions];
//}


#pragma mark - NovelDetailDelegate

- (void)novelDetailViewController:(NovelDetailViewController *)novelDetailViewController didFetchNovel:(Novel *)novel {
    NSInteger novelIndex = [self.novels indexOfObject:novel];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:novelIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


@end
