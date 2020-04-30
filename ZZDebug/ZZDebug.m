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
#import "ZZLogDataManager.h"
#import "ZZLogView.h"
@interface ZZDebug ()<ZZLogDataManagerDelegate>
{
    UIButton *_showlogBtn;
    CGFloat _statusHeight;
    UIInterfaceOrientation _orientation;
    CGRect _buttonFrame;
    CGRect _logShowFrame;
    CGRect _originalLogViewFrame;
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
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
//    NSLog(@"getStatusBarFrame == %@",NSStringFromCGRect([self getStatusBarFrame]));
//    NSLog(@"[UIApplication sharedApplication].windows == %@",[UIApplication sharedApplication].windows);
    _statusHeight = [self statusBarHeight];
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *window;
    if(windows.count != 1){
        for (UIWindow *win in windows) {
            if(win.hidden == NO){
                window = win;
                break;
            }
        }
    }else{
       window = [[UIApplication sharedApplication].windows firstObject];
    }
    window.hidden = NO;
    window.userInteractionEnabled = YES;
    _buttonFrame = CGRectMake(SCREEN_WIDTH-120, _statusHeight, 120, 20);
    if (_orientation == UIInterfaceOrientationPortrait || _orientation == UIInterfaceOrientationPortraitUpsideDown) {
//        NSLog(@"竖屏");
        _originalLogViewFrame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _logShowFrame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    }else {
//        NSLog(@"横屏");
        _originalLogViewFrame = CGRectMake(SCREEN_WIDTH, _statusHeight, SCREEN_WIDTH/2, SCREEN_HEIGHT-_statusHeight);
        _logShowFrame = CGRectMake(SCREEN_WIDTH/2, _statusHeight, SCREEN_WIDTH/2, SCREEN_HEIGHT);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = _buttonFrame;
    [btn setTitle:@"ZZDebug" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showlog:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:btn];
    _showlogBtn = btn;
//    NSLog(@"[UIApplication sharedApplication].keyWindow == %@",[UIApplication sharedApplication].keyWindow);
    self.logView = [ZZLogView zz_logViewWithFrame:_originalLogViewFrame];
    [window addSubview:self.logView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearLogs) name:@"k_Notification_ClearAllLogs" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:@"k_Notification_CloseLogView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)showlog:(UIButton *)sender
{
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
        self.logView.frame = self->_logShowFrame;
    }];
}
- (void)hidden
{
    [UIView animateWithDuration:.3 animations:^{
        self.logView.frame = self->_originalLogViewFrame;
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
- (void)didChangeRotate:(NSNotification *)notification
{
    [self hidden];
    _buttonFrame = CGRectMake(SCREEN_WIDTH-100, _statusHeight, 100, 20);
    _showlogBtn.frame = _buttonFrame;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
            || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown){
        //竖屏
        _originalLogViewFrame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _logShowFrame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    } else {
        //横屏
        _originalLogViewFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT-_statusHeight);
        _logShowFrame = CGRectMake(SCREEN_WIDTH/2, _statusHeight, SCREEN_WIDTH/2, SCREEN_HEIGHT);
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"k_Notification_ClearAllLogs" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"k_Notification_CloseLogView" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (CGFloat)statusBarHeight
{
    return [self getStatusBarFrame].size.height;
}
- (CGRect)getStatusBarFrame
{
    return [UIApplication sharedApplication].statusBarFrame;
}
@end
