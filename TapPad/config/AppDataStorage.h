//
//  AppDataStorage.h
//  storyBoardBook
//
//  Created by 陈建峰 on 16/7/22.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDataStorage : UITableView

+ (instancetype)shareInstance;

- (BOOL)hhlast;
- (NSString *)getURL;

- (void)analyseWebData;
@end
