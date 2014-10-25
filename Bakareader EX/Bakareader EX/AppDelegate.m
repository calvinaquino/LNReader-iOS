//
//  AppDelegate.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController *leftViewController = [[ViewController alloc] init];
    ViewController *frontViewController = [[ViewController alloc] init];
    ViewController *rightViewController = [[ViewController alloc] init];
    
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:[[UINavigationController alloc] initWithRootViewController:frontViewController]
                                                                                    leftViewController:[[UINavigationController alloc] initWithRootViewController:leftViewController]
                                                                                   rightViewController:[[UINavigationController alloc] initWithRootViewController:rightViewController]];
    
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
    [[CoreDataController sharedInstance] saveContext];
}

@end
