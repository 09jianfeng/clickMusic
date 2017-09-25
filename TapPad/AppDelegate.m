//
//  AppDelegate.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "AppDelegate.h"
#import "TapPadViewController.h"
#include <time.h>
#include <sys/time.h>

@interface AppDelegate()
@end

@implementation AppDelegate

static uint32_t getTickCount() {
    struct timeval now;
    gettimeofday(&now, NULL);
    return (uint32_t)now.tv_sec;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 1490323106 3月24
//    uint32_t nowTime = getTickCount();
    //50天后
//    if (nowTime > (1490323106 + 24*3600*110)) {
//        GridQualCon *detail = [GridQualCon new];
//        self.window.rootViewController = detail;
//    }else{
        self.viewController = [[TapPadViewController alloc]
                               initWithNibName:@"TapPadViewController" bundle:nil];
        self.window.rootViewController = self.viewController;
//    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //    [self.viewController pause];
}

@end
