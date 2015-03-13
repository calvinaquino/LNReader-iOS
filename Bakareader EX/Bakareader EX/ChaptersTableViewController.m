//
//  ChaptersTableViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/11/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChaptersTableViewController.h"
#import "ChapterContentViewController.h"
#import "BakaTsukiParser.h"

@interface ChaptersTableViewController ()

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Chapter *chapter = self.chapters[indexPath.row];
    
    ChapterContentViewController *chapterContentViewController = [[ChapterContentViewController alloc] initWithChapter:chapter];
    [self.navigationController pushViewController:chapterContentViewController animated:YES];
}

@end
