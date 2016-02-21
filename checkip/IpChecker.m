//
//  IpChecker.m
//  CheckIp
//
//  Created by liuminguang on 15/7/29.
//  Copyright (c) 2015年 kkk. All rights reserved.
//

#import "IpChecker.h"
#import "CheckReach.h"
#import <AVOSCloud/AVOSCloud.h>

static IpChecker *checker;
static NSString *ip2 ;
static NSString *ip3;
static NSString *ip1;

#define YM_STRING_SAFELY(__VALUE) (((__VALUE) == nil) ? @"" : (__VALUE))

@implementation IpChecker

+(instancetype)shareIp
{
    if(checker==nil)
    {
        [AVOSCloud setApplicationId:@"j6bj3p81kz61b1kv06fpk2073e1p0bmtpapayos7ye76cz0c"
                          clientKey:@"07n5jy24ilbyyr192prcp0j4f1i1662xd5rujy27e2uctt69"];
        
        checker =[[IpChecker alloc]init];
        [IpChecker checkIp];
    }
    
    return checker;
}
#pragma  mark--收集ip
+(void)checkIp
{
    CheckReach *r =[CheckReach reachabilityForInternetConnection];
    if([r currentReachabilityStatus]== NotReachable)
        return ;
    
    //ip1 收集
    NSDictionary *ipDict = [IpChecker sendIpRequest:@"http://ip.taobao.com/service/getIpInfo2.php?ip=myip"];
    NSDictionary *ipDataDict =nil;
    NSMutableString *location = [[NSMutableString alloc]init];
    if(ipDict !=nil)
        ipDataDict = [ipDict valueForKey:@"data"];
    if(ipDataDict !=nil)
    {
        ip1 =  YM_STRING_SAFELY([ipDataDict objectForKey:@"ip"]);
        
        [location appendString:YM_STRING_SAFELY([ipDataDict objectForKey:@"country"])];
        [location appendString:YM_STRING_SAFELY([ipDataDict objectForKey:@"area"])];
        [location appendString:YM_STRING_SAFELY([ipDataDict objectForKey:@"region"])];
        [location appendString:YM_STRING_SAFELY([ipDataDict objectForKey:@"city"])];
        [location appendString:YM_STRING_SAFELY([ipDataDict objectForKey:@"isp"])];
        
    }
    AVObject *post = [AVObject objectWithClassName:@"SetIp"];
    
    // AVObject *post1 = [AVObject objectWithClassName:@"SetIp"];
    if(ipDataDict !=nil)
    {
        [post setObject:ip1 forKey:@"ip1"];
        [post setObject:location forKey:@"location"];
        //  [post save];
    }
    
    //IP2 ,ip3收集
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
        NSString *regexStr = @"\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b";
        
        ip2 = [IpChecker getIp:@"http://www.ip38.com/" withRegexString:regexStr];
        ip3 = [IpChecker getIp:@"http://ip.qq.com/" withRegexString:regexStr];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *ip2Str = [defaults objectForKey:@"ip2"];
        NSString *ip3Str = [defaults objectForKey:@"ip3"];
        if(ip2Str ==nil || ip2Str.length == 0)
            [defaults setObject:ip2 forKey:@"ip2"];
        if(ip3Str == nil || ip3Str.length == 0)
            [defaults setObject:ip3 forKey:@"ip3"];
        [post setObject:ip2 forKey:@"ip2"];
        [post setObject:ip3 forKey:@"ip3"];
        NSDictionary *dic  = [[NSBundle mainBundle] infoDictionary];//获取info－plist
        NSString *appName = [dic objectForKey:@"CFBundleIdentifier"];//获取Bundle identifier
        [post setObject:appName forKey:@"bundleId"];
        //考虑leanlcound 压力暂时不收集
//        if([MLLValueForKey(@"LLMusic_ip")isEqualToString:@"1"])
            //[post save];
    });
    
    
}

#pragma mark--判断是否可以加载sdk
-(BOOL)isApple
{
    CheckReach *r =[CheckReach reachabilityForInternetConnection];
    if([r currentReachabilityStatus]== NotReachable)
        return NO;
    
    NSString *regexStr1 =@"(17.)\\b(?:\\d{1,3}\\.){2}\\d{1,3}\\b";//17开头 ip 段
    if ( [IpChecker isMatch:regexStr1]==NO) {
        return NO;
    }
    
    AVCloudQueryResult *result  =  [AVQuery doCloudQueryWithCQL:@"select * from AppleIp"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ip2Str = [defaults objectForKey:@"ip2"];
    NSString *ip3Str = [defaults objectForKey:@"ip3"];
    
    for (int i= 0; i<result.results.count; i++) {
        AVObject *obj = result.results[i];
        
        NSString *leanIp1 = [obj objectForKey:@"ip1"];
        if([[self getRangeNowStr:leanIp1] isEqualToString:[self getRangeNowStr:ip1]])
            return NO;
        NSString *leanIp2 = [obj objectForKey:@"ip2"];
        if([[self getRangeNowStr:leanIp2] isEqualToString:[self getRangeNowStr:ip2Str]])
            return NO;
        NSString *leanIp3 = [obj objectForKey:@"ip3"];
        
        
        if([[self getRangeNowStr:leanIp3] isEqualToString:[self getRangeNowStr:ip3Str]])
            return NO;
    }

    return YES;
}
#pragma mark--获取前三段ip
-(NSString *)getRangeNowStr:(NSString *)nowStr
{
    if(nowStr==nil||nowStr.length==0)
        return @"";
    NSString *regex = @"\\b(?:\\d{1,3}\\.){3}";
    NSRange range1  =  [nowStr rangeOfString:regex options:NSRegularExpressionSearch];
    return YM_STRING_SAFELY([nowStr substringWithRange:range1]);
    
}
+(NSDictionary *)sendIpRequest:(NSString *)urlStr
{
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:newUrlStr];
    if (url == nil) {
        return nil;
    }
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // NSString *responseStr = [[NSString alloc] initWithData:data encoding:0x80000632];
    if(data==nil)
        return nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return  dict;
}
+(NSString *)getIp :(NSString *)urlStr withRegexString :(NSString *)regexStr
{
    // 如果网址中存在中文,进行URLEncode
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:newUrlStr];
    if (url == nil) {
        return @"";
    }
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(data==nil)
        return @"";
    NSString *responseStr = YM_STRING_SAFELY([[NSString alloc] initWithData:data encoding:0x80000632]);

    // NSString * regex1 = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";

    //  NSString *regexStr = @"\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b";
    //NSString *regexStr1 =@"(17.)\\b(?:\\d{1,3}\\.){2}\\d{1,3}\\b";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    NSString *result = @"";
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:responseStr options:0 range:NSMakeRange(0, [responseStr length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
        
            //从urlString当中截取数据
            result=YM_STRING_SAFELY([responseStr substringWithRange:resultRange]);
            //输出结果
        }
    }

    return result;
}

+(BOOL)isMatch :(NSString *)string
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ip2Str = [defaults objectForKey:@"ip2"];
    if(ip2Str==nil)
        ip2Str = @"";
    NSString *ip3Str = [defaults objectForKey:@"ip3"];
    if(ip3Str==nil)
        ip3Str = @"";
    NSError *error = nil;
    if(ip1==nil)
        return NO;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:string
                                                                           options:0 error:&error];
    if(regex!=nil)
    {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ip1 options:0 range:NSMakeRange(0, [ip1 length])];
        
        if (firstMatch)
            return  NO;
        NSTextCheckingResult *firstMatch1=[regex firstMatchInString:ip2Str options:0 range:NSMakeRange(0, [ip2Str length])];
        if (firstMatch1)
            return  NO;
        NSTextCheckingResult *firstMatch2=[regex firstMatchInString:ip3Str options:0 range:NSMakeRange(0, [ip3Str length])];
        if (firstMatch2)
            return  NO;
    }
    
    return YES;
}

@end
