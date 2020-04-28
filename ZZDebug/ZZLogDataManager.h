//
//  ZZLogDataManager.h
//  TestDemo
//
//  Created by 泽泽 on 2020/4/27.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZZLogDataManagerDelegate <NSObject>

- (void)needToRefreshisAdd:(BOOL)add;

@end


@interface ZZLogDataManager : NSObject

@property (nonatomic,weak) id<ZZLogDataManagerDelegate> delegate;

- (void)addLogStr:(NSString *)logStr;

- (void)clearAllLogs;

- (NSMutableArray *)getLogsArray;

@end

NS_ASSUME_NONNULL_END
