## 介绍
iOS APP内监测NSLog输出可视化工具
## 安装

### CocoaPods

```ruby
target 'YourTargetName' do
    pod 'ZezeDebug', :configurations => ['Debug']
end
```

> WARNING: Don't submit `.ipa` to AppStore which has been linked with the `ZZDebug.framework`. This  outline a way to use build configurations to isolate linking the framework to `Debug` builds only.

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

    
