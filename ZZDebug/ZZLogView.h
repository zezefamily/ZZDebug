//
//  ZZLogView.h
//  TestDemo
//
//  Created by 泽泽 on 2020/4/27.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZLogView : UIView

+ (instancetype)zz_logViewWithFrame:(CGRect)frame;

- (void)reloadDataWithArray:(NSMutableArray *)logArray isAdd:(BOOL)isAdd;

@end

NS_ASSUME_NONNULL_END
