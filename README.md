## 介绍
iOS APP内监测NSLog输出可视化工具
## 安装

### CocoaPods

```ruby
target 'YourTargetName' do
    pod 'ZezeDebug', :configurations => ['Debug']
end
```

## 使用

### Objective-C

	//AppDelegate.m
	 
    #ifdef DEBUG
        #import "ZZDebug.h"
    #endif

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    	[self.window makeKeyAndVisible];

		#ifdef DEBUG
        [[ZZDebug shareInstance]enable];
    	#endif
	}

## 问题反馈
有问题请及时反馈到zezefamily@163.com

    
