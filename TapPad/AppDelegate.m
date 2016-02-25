//
//  AppDelegate.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "AppDelegate.h"
#import "TapPadViewController.h"
#import "IpChecker.h"
#import "XiaoZSinitialization.h"

@interface AppDelegate()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (getNeedStartMiLu()) {
        [XiaoZSinitialization sharedInstance];
    }else{
        self.viewController = [[TapPadViewController alloc]
                               initWithNibName:@"TapPadViewController" bundle:nil];
        self.window.rootViewController = self.viewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //    [self.viewController pause];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[XiaoZSinitialization sharedInstance] mll_application:application openURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[XiaoZSinitialization sharedInstance] mll_application:application handleOpenURL:url];
}
@end
