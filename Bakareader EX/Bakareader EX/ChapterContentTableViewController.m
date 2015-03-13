//
//  ChapterContentTableViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/13/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ChapterContentTableViewController.h"
#import "BakaTsukiParser.h"

@interface ChapterContentTableViewController ()

@property (nonatomic, strong) Chapter *chapter;
@property (nonatomic, strong) NSArray *paragraphs;

@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) CGFloat minimumHeight;

@end

@implementation ChapterContentTableViewController

//- (instancetype)initWithChapter:(Chapter *)chapter {
//    self = [super init];
//    if (self) {
//        self.chapter = chapter;
//    }
//    
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self loadContentFromInternet];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//
//#pragma mark - Property Accessors
//
//- (UIFont *)font {
//    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
//}
//
//- (CGFloat)minimumHeight {
//    return 30;
//}
//
//#pragma mark - Data Loading
//
//- (void)loadContentFromInternet {
//    __weak typeof(self) weakSelf = self;
//    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
//        weakSelf.paragraphs = [BakaTsukiParser fetchChapterContent:self.chapter];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [weakSelf.tableView reloadData];
//        }];
//    }];
//}
//
//
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.paragraphs.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *paragraph = self.paragraphs[indexPath.row];
//    
//    CGFloat height = [UILabel heightForText:paragraph containedInWidth:(self.tableView.frame.size.width - 40) withFont:self.font];
//    return height >= self.minimumHeight ? height : self.minimumHeight;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
//    
//    // Configure the cell...
//    NSString *paragraph = self.paragraphs[indexPath.row];
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.font = self.font;
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.textLabel.text = paragraph;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", self.paragraphs[indexPath.row]);
//}


@end
