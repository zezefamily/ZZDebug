//
//  ZZDebug.m
//  TestDemo
//
//  Created by 泽泽 on 2020/4/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "ZZDebug.h"
#import <UIKit/UIKit.h>
#import "ZZLogDataManager.h"
#import "ZZLogView.h"
@interface ZZDebug ()<ZZLogDataManagerDelegate>
{
    UIButton *_showlogBtn;
}
@property (nonatomic,strong) ZZLogView *logView;
@end

@implementation ZZDebug

+ (ZZDebug *)shareInstance
{
    static ZZDebug *debugTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        debugTool = [[ZZDebug alloc]init];
    });
    return debugTool;
}
- (instancetype)init
{
    if(self == [super init]){
        self.logDataManager = [[ZZLogDataManager alloc]init];
        self.logDataManager.delegate = self;
    }
    return self;
}
- (void)enable
{
    [self loadUI];
}
- (void)loadUI
{
    NSLog(@"[UIApplication sharedApplication].windows == %@",[UIApplication sharedApplication].windows);
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    window.hidden = NO;
    window.userInteractionEnabled = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(SCREEN_WIDTH-100, 20, 100, 20);
    [btn setTitle:@"ShowLogs" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showlog:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:btn];
    _showlogBtn = btn;
    NSLog(@"[UIApplication sharedApplication].keyWindow == %@",[UIApplication sharedApplication].keyWindow);
    self.logView = [ZZLogView zz_logViewWithFrame:CGRectMake(SCREEN_WIDTH, 20, SCREEN_WIDTH/2, SCREEN_HEIGHT-20)];
    [window addSubview:self.logView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearLogs) name:@"k_Notification_ClearAllLogs" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:@"k_Notification_CloseLogView" object:nil];
}
- (void)showlog:(UIButton *)sender
{
    NSLog(@"dddddd");
    sender.selected = !sender.selected;
    if(sender.selected){
        [self show];
    }else{
        [self hidden];
    }
}
- (void)show
{
    [UIView animateWithDuration:.3 animations:^{
        self.logView.frame = CGRectMake(SCREEN_WIDTH/2,20, SCREEN_WIDTH/2, SCREEN_HEIGHT-20);
    }];
}
- (void)hidden
{
    [UIView animateWithDuration:.3 animations:^{
        self.logView.frame = CGRectMake(SCREEN_WIDTH, 20, SCREEN_WIDTH/2, SCREEN_HEIGHT-20);
    }completion:^(BOOL finished) {
        self->_showlogBtn.selected = NO;
    }];
}
- (void)needToRefreshisAdd:(BOOL)add
{
    //刷新UI
    [self.logView reloadDataWithArray:self.logDataManager.getLogsArray isAdd:add];
}
- (void)clearLogs
{
    [self.logDataManager clearAllLogs];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"k_Notification_ClearAllLogs" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"k_Notification_CloseLogView" object:nil];
}
- (CGRect)getStatusBarFrame
{
    return [UIApplication sharedApplication].statusBarFrame;
}
@end
