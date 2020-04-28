//
//  ZZLogDataManager.m
//  TestDemo
//
//  Created by 泽泽 on 2020/4/27.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZLogDataManager.h"
@interface ZZLogDataManager ()
@property (nonatomic,strong) NSMutableArray *logsArray;
@end
@implementation ZZLogDataManager

- (instancetype)init
{
    if(self = [super init]){
        self.logsArray = [NSMutableArray array];
    }
    return self;
}

- (void)addLogStr:(NSString *)logStr
{
    [self.logsArray addObject:logStr];
    if([self.delegate respondsToSelector:@selector(needToRefreshisAdd:)]){
        [self.delegate needToRefreshisAdd:YES];
    }
}

- (void)clearAllLogs
{
    [self.logsArray removeAllObjects];
    if([self.delegate respondsToSelector:@selector(needToRefreshisAdd:)]){
        [self.delegate needToRefreshisAdd:NO];
    }
}

- (NSMutableArray *)getLogsArray
{
    return self.logsArray;
}

@end
