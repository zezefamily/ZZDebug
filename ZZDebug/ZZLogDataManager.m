//
//  ZZLogDataManager.m
//  TestDemo
//
//  Created by 泽泽 on 2020/4/27.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZLogDataManager.h"
@interface ZZLogDataManager ()
{
    NSDateFormatter *formatter;
}
@property (nonatomic,strong) NSMutableArray *logsArray;
@end
@implementation ZZLogDataManager
- (instancetype)init
{
    if(self = [super init]){
        self.logsArray = [NSMutableArray array];
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    }
    return self;
}
- (void)addLogStr:(NSString *)logStr
{
    [self.logsArray addObject:[NSString stringWithFormat:@"%@\n%@",[self getCurrentTime],logStr]];
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
- (NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
@end
