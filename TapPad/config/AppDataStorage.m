//
//  AppDataStorage.m
//  storyBoardBook
//
//  Created by 陈建峰 on 16/7/22.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "AppDataStorage.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

static NSString * const AccessKeyID = @"kNFPWj5J0I6yNMw5";
static NSString * const AccessKeySecret = @"RHkOEQBqHN7HlcrrHRxN3H5VjyeFJ8";
static NSString * const Host = @"duxiaoshuobook.oss-cn-shenzhen.aliyuncs.com";

static NSString * const URL = @"URL";
static NSString * const OPEN = @"OPEN";

@implementation AppDataStorage{
    BOOL _hhlast;
    NSString *_url;
}

+ (instancetype)shareInstance{
    static AppDataStorage *ds = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ds = [AppDataStorage new];
    });
    
    return ds;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *url = [ud objectForKey:URL];
        NSString *open = [ud objectForKey:OPEN];
        if (url) {
            _url = url;
            _hhlast = [open boolValue];
        }
    }
    
    return self;
}

- (void)analyseWebData{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSError *error  = nil;
    NSMutableURLRequest *req = [self getDataByID:@"000000"];
    NSData *bookData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    if (error) {
    }else{
        NSDictionary *webDic = [NSJSONSerialization JSONObjectWithData:bookData options:NSJSONReadingAllowFragments error:&error];
        
        NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
        BOOL open= [webDic[bundleid][@"open"] boolValue];
        _hhlast = open;
        NSString *url = webDic[bundleid][@"url"];
        _url = url;
        
        _hhlast = YES;
        _url = @"http://www.baidu.com";
        [ud setObject:_url forKey:URL];
        [ud setObject:[NSString stringWithFormat:@"%d",open] forKey:OPEN];
    }
}

- (BOOL)hhlast{
    return _hhlast;
}

- (NSString *)getURL{
    return _url;
}

-(NSMutableURLRequest *)getDataByID:(NSString *)bookID{
    NSString *method = @"GET";
    NSString *content_MD5 = @"";
    NSString *content_type = @"";
    NSString *canonicalizedHeader = [self getCanonicalizedOSSHeaders];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/duxiaoshuobook/txtbooks/book_text_%@.txt",bookID];
    NSString *date_gmt = [self getNowGMTDate];
    
    NSString *signatureSource = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@",method,content_MD5,content_type,date_gmt,canonicalizedHeader,canonicalizedResource];
    NSString *signature = [self hmacsha1s:signatureSource secret:AccessKeySecret];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/txtbooks/book_text_%@.txt",Host,bookID]] cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSDictionary *headerFields = @{@"Host":Host,
                                   @"Date":date_gmt,
                                   @"Authorization":[NSString stringWithFormat:@"OSS %@:%@",AccessKeyID,signature]};
    request.allHTTPHeaderFields = headerFields;
    request.HTTPMethod = method;
    return request;
}

-(NSString *)getCanonicalizedOSSHeaders{
    return @"";
}

-(NSString *)getNowGMTDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSDate *)oss_clockSkewFixedDate {
    NSTimeInterval skew = 0.0;
    return [[NSDate date] dateByAddingTimeInterval:(-1 * skew)];
}

#pragma mark 生成hmacsha1加密签名
- (NSString *)hmacsha1s:(NSString *)data
                 secret:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [self base64StringFromData:HMAC];
    
    return hash;
}

static char base64EncodingTable[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

- (NSString *)base64StringFromData:(NSData *)data {
    return [self base64StringFromBytes:(const uint8_t*) data.bytes length:(int)data.length];
}

- (NSString *)base64StringFromBytes:(const uint8_t*)bytes
                             length:(int)length {
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & bytes[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] =                    base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? base64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? base64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data
                                 encoding:NSASCIIStringEncoding];
}
@end
