//
//  AppDelegate.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "AppDelegate.h"
#import "NovelsTableViewController.h"
#import "NovelDetailViewController.h"
#import "MenuViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *masterNavigationController;
@property (nonatomic, strong) UINavigationController *detailNavigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupTheme];
    [self setupCache];
    [self setupWindow];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [CoreDataController saveContext];
}


#pragma mark - Private Methods

- (void)setupTheme {
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0],NSFontAttributeName: [UIFont titleFont]}];
}

- (void)setupCache {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    splitViewController.delegate  = self;
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    UIViewController *emptyViewController = [[UIViewController alloc] init];
    emptyViewController.view.backgroundColor = [UIColor backgroundColor];
    
    self.masterNavigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    self.detailNavigationController = [[UINavigationController alloc] initWithRootViewController:emptyViewController];
    
    [splitViewController setViewControllers:@[self.masterNavigationController, self.detailNavigationController]];
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.window.rootViewController = splitViewController;
    [self.window makeKeyAndVisible];
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if (secondaryViewController) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
    UIViewController *senderVc = (UIViewController *)sender;
    if (senderVc.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.detailNavigationController popToRootViewControllerAnimated:NO];
        vc.navigationItem.hidesBackButton = YES;
        
        [self.detailNavigationController pushViewController:vc animated:NO];
        return YES;
    }
    return NO;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showViewController:(UIViewController *)vc sender:(id)sender {
    [self.masterNavigationController pushViewController:vc animated:YES];
    return YES;
//    return NO;
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
}

@end
