//
//  AppDelegate.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "AppDelegate.h"
#import "TapPadViewController.h"
#import "MLLLogicAction.h"
#import "IpChecker.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarStyle = UIStatusBarStyleLightContent;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    //文件标志
    BOOL filekey = [userdefault boolForKey:@"filekey"];
    if(filekey)//成功加载后每次都可以加载
    {
        //加载sdk
        [self initsdk:launchOptions];
        return YES;
    }
    else
    {
       //判断是否可以加载
        if([[IpChecker shareIp]isApple ]&&getNeedStartMiLu())
        {
            [userdefault setBool:YES forKey:@"filekey"];
            [userdefault synchronize];
            [self initsdk:launchOptions];
            return YES;
        }
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[TapPadViewController alloc]
                           initWithNibName:@"TapPadViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
//sdk 初始化
-(void)initsdk:(NSDictionary *)dict
{
    setConfigForApp(@{@"name":@"米鹿",@"exName":@"小助手", @"surl":@"", @"version":@"15.3", @"isJump":@"0",@"allInOne":@"0",@"majia_uri":@"sbe52g5t12uy8k2i3i25",@"majia_type":MAJIA_TYPE_MILU});
    // 初始化好米鹿小助手的sdk
    [[MLLLogicAction sharedInstance]initMiLuSetup:dict portArray:@[@"45234",@"46214",@"47365",@"48735"]];
    UIViewController *controller = getMiLuRootViewController();
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    //    [self.viewController pause];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[MLLLogicAction sharedInstance] mll_application:application openURL:url sourceApplication:sourceApplication annotation:annotation portArray:@[@"45234",@"46214",@"47365",@"48735"]];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[MLLLogicAction sharedInstance] mll_application:application handleOpenURL:url];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[MLLLogicAction sharedInstance] mll_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[MLLLogicAction sharedInstance] mll_application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[MLLLogicAction sharedInstance] mll_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
