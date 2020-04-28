//
//  ZZNSLogHook.m
//  TestDemo
//
//  Created by 泽泽 on 2020/4/27.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <dlfcn.h>
#import "_fishhook.h"
#import "ZZDebug.h"

@interface ZZNSLogHook : NSObject

@end

@implementation ZZNSLogHook

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //rebinding {"需要hook的方法名",替换后的方法指针,原来的指针}
        struct rebinding nslog_rebinding = {"NSLog", my_nslog, (void*)&orig_nslog};
        rebind_symbols((struct rebinding[1]){nslog_rebinding}, 1);
    });
}

static void (*orig_nslog)(NSString *format, ...);
void my_nslog(NSString *format, ...) {
    /*方法一*/
//    va_list vl;
//    va_start(vl, format);
//    NSString *str = [[NSString alloc] initWithFormat:format arguments:vl];
//    va_end(vl);
//    orig_nslog(str);
    /*方法二*/
    va_list va;
    va_start(va, format);
    NSLogv(format, va);
    NSString *str = [[NSString alloc]initWithFormat:format arguments:va];
    [ZZDebug.shareInstance.logDataManager addLogStr:str];
    va_end(va);
}

@end
