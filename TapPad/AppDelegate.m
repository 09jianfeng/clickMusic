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
#import "GDTSplashAd.h"

@interface AppDelegate() <GDTSplashAdDelegate>
@property(nonatomic, retain) GDTSplashAd *splash;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[TapPadViewController alloc]
                           initWithNibName:@"TapPadViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [XiaoZSinitialization sharedInstance];
    
    //开屏广告初始化---------
    _splash = [[GDTSplashAd alloc] initWithAppkey:@"1105125629" placementId:@"9030701809870589"];
    _splash.delegate = self;//设置代理
    //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        _splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h"]];
    } else {
        _splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
    }
    
    UIWindow *fK = [[[UIApplication sharedApplication] delegate] window];
    //设置开屏拉取时长限制，若超时则不再展示广告
    _splash.fetchDelay = 10;
    //拉取并展示
    [_splash loadAdAndShowInWindow:fK];

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

#pragma mark -
#pragma mark - 广点通开屏广告代理
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashAdWillPresentFullScreen");
}

-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashADDidDismissFullScreenModal");
}
@end
