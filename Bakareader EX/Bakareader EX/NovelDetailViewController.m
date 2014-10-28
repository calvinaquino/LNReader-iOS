//
//  NovelDetailViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/26/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "NovelDetailViewController.h"
#import "BakaTsukiParser.h"

@interface NovelDetailViewController ()

@property (nonatomic, strong) Novel *novel;
@property (nonatomic, strong) NSArray *volumes;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel *synopsisLabel;

@end

@implementation NovelDetailViewController

- (instancetype)initWithNovel:(Novel *)novel {
    self = [super init];
    if (self) {
        self.novel = novel;
        self.title = novel.title;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
    [self setupTableView];
}

- (void)setupHeaderView {
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.coverView = [[UIImageView alloc] init];
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.synopsisLabel = [[UILabel alloc] init];
    self.synopsisLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.synopsisLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.synopsisLabel.numberOfLines = 0;
    self.synopsisLabel.text = self.novel.synopsis;
    
    [self.headerView addSubview:self.coverView];
    [self.headerView addSubview:self.synopsisLabel];
    
    NSDictionary *views = @{@"coverView": self.coverView, @"synopsisLabel": self.synopsisLabel};
    
    [self.headerView addConstraintsWithFormat:@"H:|[coverView]| && H:|[synopsisLabel]| && V:|[coverView][synopsisLabel]|" views:views];
}

- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(loadNovelInfoFromInternet) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNovelInfo];
}

#pragma mark - Load Data

- (void)loadNovelInfo {
    if (self.novel.fetchedValue) {
        [self loadNovelInfoFromDatabase];
    } else {
        [self loadNovelInfoFromInternet];
    }
}

- (void)loadNovelInfoFromDatabase {
    self.volumes = [[self.novel.volumes allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    self.synopsisLabel.text = self.novel.synopsis;
    [self updateHeaderSize];
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    [self.tableView reloadData];
}

- (void)loadNovelInfoFromInternet {
    __weak typeof(self) weakSelf = self;
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [BakaTsukiParser fetchNovelInfo:weakSelf.novel];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf loadNovelInfoFromDatabase];
        }];
    }];
}

#pragma mark - Private Methods

- (void)updateHeaderSize {
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.headerView;
    
    NSDictionary *views = @{@"headerView": self.headerView};
    NSDictionary *metrics = @{@"width": @(self.screenWidth)};
    
    [self.tableView addConstraintsWithFormat:@"H:|[headerView(width)]| && V:|[headerView]|" metrics:metrics views:views];
}

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.volumes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    Volume *volume = self.volumes[indexPath.row];
    cell.textLabel.text = volume.title;
    
    return cell;
}




@end
