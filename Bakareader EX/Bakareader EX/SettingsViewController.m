//
//  SettingsViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 8/23/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"Settings";
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;//test
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;//test
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Title";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    cell.textLabel.text = @"Setting";
    cell.textLabel.textColor = [UIColor textColor];
    cell.backgroundColor = [UIColor backgroundColor];
    
    return cell;
}


@end
