//
//  ViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "NovelsTableViewController.h"
#import "NovelDetailViewController.h"

#import "BakaTsukiParser.h"

@interface NovelsTableViewController () <NovelDetailDelegate>

@property (nonatomic, strong) NSArray *novels;

@end

@implementation NovelsTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Light Novels";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(loadListFromInternet) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self loadList];
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
    self.novels = [CoreDataController allNovels];
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


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.novels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Novel *novel = self.novels[indexPath.row];
    
    NovelDetailViewController *novelDetailViewController = [[NovelDetailViewController alloc] initWithNovel:novel];
    novelDetailViewController.delegate = self;
    [self.navigationController pushViewController:novelDetailViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    Novel *novel = self.novels[indexPath.row];
    cell.textLabel.text = novel.title;
    cell.detailTextLabel.text = novel.url;
    cell.accessoryType = novel.fetchedValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - NovelDetailDelegate

- (void)novelDetailViewController:(NovelDetailViewController *)novelDetailViewController didFetchNovel:(Novel *)novel {
    NSInteger novelIndex = [self.novels indexOfObject:novel];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:novelIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


@end
