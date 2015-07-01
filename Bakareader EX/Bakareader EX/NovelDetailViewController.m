//
//  NovelDetailViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/26/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "NovelDetailViewController.h"
#import "ChaptersTableViewController.h"
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
    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.coverView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.coverView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.synopsisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.synopsisLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.synopsisLabel.numberOfLines = 0;
    self.synopsisLabel.text = self.novel.synopsis;
    
    [self.headerView addSubview:self.coverView];
    [self.headerView addSubview:self.synopsisLabel];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self recalculateHeaderFrames];
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
    [self updateNovelCover];
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
    [[BakaReaderDownloader sharedInstance] downloadNovelDetails:weakSelf.novel withCompletion:^(BOOL success) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf updateNovelTableView];
            [weakSelf loadNovelInfoFromDatabase];
        }];
    }];
}

#pragma mark - Private Methods

- (void)updateNovelCover {
    if (self.novel.cover) {
        __weak typeof(self) weakSelf = self;
        [self.novel.cover fetchImageIfNeededWithCompletion:^(UIImage *image) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                weakSelf.coverView.image = image;
                [weakSelf updateHeaderSize];
            }];
        }];
    }
}

- (void)updateNovelTableView {
    if ([self.delegate respondsToSelector:@selector(novelDetailViewController:didFetchNovel:)]) {
        [self.delegate novelDetailViewController:self didFetchNovel:self.novel];
    }
}

- (void)updateHeaderSize {
    self.tableView.tableHeaderView = nil;
    [self recalculateHeaderFrames];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)recalculateHeaderFrames {
    if (self.coverView.image) {
        CGFloat dimensionRatio = self.view.bounds.size.width / self.coverView.image.size.width;
        
        self.coverView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.coverView.image.size.height * dimensionRatio);
    } else {
        self.coverView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    }
    
    self.synopsisLabel.frame = CGRectMake(20, self.coverView.bounds.size.height + 20, self.view.frame.size.width - 40, 0);
    [self.synopsisLabel calculateHeight];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Volume *volume = self.volumes[indexPath.row];
    
    ChaptersTableViewController *chaptersViewController = [[ChaptersTableViewController alloc] initWithVolume:volume];
    [self.navigationController pushViewController:chaptersViewController animated:YES];
}


@end
