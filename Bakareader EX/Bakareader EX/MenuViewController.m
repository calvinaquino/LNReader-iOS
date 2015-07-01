//
//  MenuViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/26/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "MenuViewController.h"
#import "NovelsTableViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *cellTitles;

@end

@implementation MenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Menu";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self setupMenuCellTitles];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setupMenuCellTitles {
    self.cellTitles = @[@"Light Novels", @"Favorites", @"Resume"];
}

- (NSString *)subtitleForResumeCell {
    NSString *subtitle = nil;
    Chapter *lastReadChapter = [CoreDataController user].lastChapterRead;
    if (lastReadChapter) {
        Volume *lastReadVolume = lastReadChapter.volume;
        Novel *lastReadNovel = lastReadVolume.novel;
        
        subtitle = [NSString stringWithFormat:@"%@ %@ %@", lastReadNovel.title, lastReadVolume.title, lastReadChapter.title];
    }
    
    return subtitle;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] init];
        [self.navigationController pushViewController:novelsTableViewController animated:YES];
    } else if (indexPath.row == 1) {
        NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] initWithFavorites];
        [self.navigationController pushViewController:novelsTableViewController animated:YES];
    } else if (indexPath.row == 2) {
        NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] initResuminngChapter];
        [self.navigationController pushViewController:novelsTableViewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = self.cellTitles[indexPath.row];
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = [self subtitleForResumeCell];
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}


@end
