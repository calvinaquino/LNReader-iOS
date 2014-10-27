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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
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
    self.volumes = [self.novel.volumes allObjects];
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
