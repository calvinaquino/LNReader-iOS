//
//  MenuViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/26/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "MenuViewController.h"
#import "NovelsTableViewController.h"
#import "SettingsViewController.h"
#import "BRTableViewCell.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation MenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"BakaReader EX";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BRTableViewCell class] forCellReuseIdentifier:[BRTableViewCell identifier]];
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupOptions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setupOptions {
    self.options = @[@"Light Novels", @"Watch List", @"Resume Novel", @"Bookmarks", @"Updates", @"Download List", @"Settings"];
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
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BRTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] init];
        [self.navigationController pushViewController:novelsTableViewController animated:YES];
//        [self.splitViewController showViewController:novelsTableViewController sender:self];
    } else if (indexPath.row == 1) {
        NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] initWithFavorites];
//        [self.navigationController pushViewController:novelsTableViewController animated:YES];
        [self.splitViewController showViewController:novelsTableViewController sender:self];
    } else if (indexPath.row == 2) {
        if ([CoreDataController user].lastChapterRead != nil) {
            NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] initResuminngChapter];
//            [self.navigationController pushViewController:novelsTableViewController animated:YES];
            [self.splitViewController showViewController:novelsTableViewController sender:self];
        }
    } else if (indexPath.row == 6) { //change to something more readable
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
        [self.navigationController showViewController:settingsViewController sender:self];
    } else {
        NSString *selectedOption = self.options[indexPath.row];
        NSString *alertMessage = [NSString stringWithFormat:@"The option %@ is not yet implemented :(", selectedOption];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:dismissAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRTableViewCell *cell = (BRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[BRTableViewCell identifier] forIndexPath:indexPath];
    
    cell.title = self.options[indexPath.row];
    if (indexPath.row == 2) {
        cell.subtitle = [self subtitleForResumeCell];
    }
    
    return cell;
}


@end
