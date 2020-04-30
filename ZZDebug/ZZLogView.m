//
//  ZZLogView.m
//  TestDemo
//
//  Created by 泽泽 on 2020/4/27.
//  Copyright © 2020 泽泽. All rights reserved.
//

#define HEAD_HEIGHT 40

#import "ZZLogView.h"
@interface ZZLogView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UITableView *logsView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
@implementation ZZLogView
static NSString *cellIdentifier = @"cell";
+ (instancetype)zz_logViewWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self loadUI];
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadUI
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
    [self addSubview:self.toolView];
    [self addSubview:self.logsView];
}
- (UIView *)toolView
{
    if(_toolView == nil){
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, HEAD_HEIGHT)];
        for(int i = 0;i<4;i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(15+45*i, 5, 40, 30);
            [btn setTitle:@[@"顶部",@"底部",@"清空",@"关闭"][i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 400 + i;
            [_toolView addSubview:btn];
        }
    }
    return _toolView;
}

- (UITableView *)logsView
{
    if(_logsView == nil){
        _logsView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEAD_HEIGHT, self.frame.size.width, self.frame.size.height-HEAD_HEIGHT) style:UITableViewStylePlain];
        _logsView.delegate = self;
        _logsView.dataSource = self;
        _logsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _logsView.tableFooterView = [UIView new];
        _logsView.backgroundColor = [UIColor clearColor];
        _logsView.estimatedRowHeight = UITableViewAutomaticDimension;
    }
    return _logsView;
}

- (void)reloadFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    _toolView.frame = CGRectMake(0, 0, self.frame.size.width, HEAD_HEIGHT);
    _logsView.frame = CGRectMake(0, HEAD_HEIGHT, self.frame.size.width, self.frame.size.height-HEAD_HEIGHT);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor greenColor];
        cell.textLabel.numberOfLines = 0;
    }
    NSString *logStr = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = logStr?:@"";
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
////    CGRect frame = cell.textLabel.bounds;
//    return 50;
//}

- (void)btnClick:(UIButton *)sender
{
    if(sender.tag == 400){
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.logsView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else if (sender.tag == 401){
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [self.logsView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else if (sender.tag == 402){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"k_Notification_ClearAllLogs" object:self];
    }else if (sender.tag == 403){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"k_Notification_CloseLogView" object:self];
    }
}

- (void)reloadDataWithArray:(NSMutableArray *)logArray isAdd:(BOOL)isAdd
{
    self.dataArray = logArray;
    [self.logsView reloadData];
    if(isAdd){
        //如果在底部
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [self.logsView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

@end
