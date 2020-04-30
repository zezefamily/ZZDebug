//
//  ZZDebug.h
//  TestDemo
//
//  Created by 泽泽 on 2020/4/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZLogDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZZDebug : NSObject

+ (ZZDebug *)shareInstance;

- (void)enable;

@property (nonatomic,strong) ZZLogDataManager *logDataManager;

@end

NS_ASSUME_NONNULL_END
