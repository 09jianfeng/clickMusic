//
//  MLLLogicAction.h
//  FeedBack
//
//  Created by youmi on 14/11/27.
//  Copyright (c) 2014年 yuxuhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define MAJIA_TYPE_QIANDEER     @"qiandeer"
#define MAJIA_TYPE_MILU         @"milu"
#define MAJIA_TYPE_CYLY         @"cyly"
#define MAJIA_TYPE_ZHENGJIA     @"zhengjia"


@class AGViewDelegate;
@class MLLWebviewController;

typedef void (^FinishBlock)(NSString *code,NSString *errorMsg);
typedef void (^DataBlock)(NSData *data);

@interface MLLLogicAction : NSObject

// 控制小助手显示什么页面
@property (strong, nonatomic) NSString *showHost;
@property (strong, nonatomic) NSString *showPath;

//如果是给米鹿用，这里要注释掉，如果是钱鹿用，这里要打开。
#if 0
@property (strong, nonatomic) AGViewDelegate *viewDelegate;
@property (strong, nonatomic) MLLWebviewController *webController;
#endif

//一体包可以接收这个通知：webViewDidFinishLoad，从而知道网页加载成功。

+ (MLLLogicAction *)sharedInstance ;

- (void)initMiLuSetup:(NSDictionary *)launchOptions portArray:(NSArray *)portArray;

- (NSString *)getVersion;

NSString *MLLValueForKey(NSString *key);
NSString *MLLYouMengValueForKey(NSString *key);//友盟在线参数
NSString *MLLeanCloundValueForKey(NSString *key,NSDictionary *launchOptions); //leanclound 在线参数
bool getNeedStartMiLu();
bool getIsJumpLink();
bool getIsAllInOne();
NSString *getNameForApp();
NSString *getExNameForApp();
NSString *getSurlForApp();
NSString *getVarsionForApp();
void setConfigForApp(NSDictionary *params);

BOOL applicationOpenWithUrl(UIApplication *application, NSURL *url, NSString *sourceApplication, id annotation, MLLLogicAction *logicAction, NSArray *portArray, FinishBlock finishBlock);

void doHttpServerRequestAction(NSURL *url, MLLLogicAction *logicAction, DataBlock finish);

UIViewController *getMiLuRootViewController();

- (void)playBackgroundMusic:(SEL)selector_ target:(id)target times:(int)times;

//appDelegate method
- (BOOL)mll_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation portArray:(NSArray *)portArray;
- (BOOL)mll_application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (void)mll_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)mll_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)mll_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end
