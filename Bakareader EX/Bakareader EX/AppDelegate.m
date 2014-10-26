//
//  AppDelegate.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "AppDelegate.h"
#import "NovelsTableViewController.h"
#import "MenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    NovelsTableViewController *novelsTableViewController = [[NovelsTableViewController alloc] init];
    
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:[[UINavigationController alloc] initWithRootViewController:novelsTableViewController]
                                                                                    leftViewController:[[UINavigationController alloc] initWithRootViewController:menuViewController]];
    
    self.window.rootViewController = revealController;
    [self.window makeKeyAndVisible];
    
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

@end
