//
//  ExternalContentViewController.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 3/13/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "ExternalContentViewController.h"

@interface ExternalContentViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ExternalContentViewController
@synthesize chapter = _chapter;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.chapter.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.frame;
}

@end
