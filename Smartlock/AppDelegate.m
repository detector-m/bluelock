//
//  AppDelegate.m
//  Smartlock
//
//  Created by RivenL on 15/3/11.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "AppDelegate.h"
#import "RLBaseNavigationController.h"

#import "LoginVC.h"
#import "MainVC.h"

#import "RLNotificationManager.h"
#import "AWVersionAgent.h"

#import "XMPPManager.h"

#import "RLHTTPAPIClient.h"

#import "RLBluetooth.h"

/************** Test *****************/
#import "ViewController.h"
#import "TestViewController.h"
#import "Register.h"
#import "MyCoreDataManager.h"

#import "BluetoothLockCommand.h"

#import "Message.h"
#import "RLJSON.h"
#import "RLDate.h"

#import "KeyEntity.h"
#import "LockEntity.h"
/*************************************/

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)test {
#if 0
//    CFUUIDBytes bytestt = {0xd0, 0x39, 0x72, 0xf8, 0xb1, 0xfa};
//    CFUUIDRef uuidObj = CFUUIDCreateFromUUIDBytes(nil, bytestt);//CFUUIDCreate(nil);
//        NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
//        CFRelease(uuidObj);
//        DLog(@"%@", uuidString);
    
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    DLog(@"%lf", time);
    
    //    long long temp = 1430987340350;
    //    Byte x[8];
    //    for(NSInteger i=0; i<sizeof(temp); i++) {
    //        x[i] = (temp & 0x00000000000000ff);
    //        temp >>= 8;
    //    }
    //    for(NSInteger i=sizeof(temp)-1; i>= 0; i--) {
    ////        DLog(@"%xc", x[i]);
    //        NSLog(@"%02x", x[i]);
    //    }
#endif

#if 0
//    NSString *str = @"{\"backCode\":107,\"data\":{\"addTime\":\"2015-05-21 09:52:41\",\"bleLock\":{\"addTime\":\"2015-05-15 10:25:48\",\"bleAddress\":\"aaaaaaa\",\"id\":14,\"lockPwd\":\"123456789\",\"memberGid\":\"46804818-5dae-e440-6a60-db709c5b82d7\",\"status\":0},\"bleLockId\":14,\"id\":77,\"keyType\":2,\"lockName\":\"Renquant\",\"member\":{\"easemobUserId\":\"26\",\"easemobUserPwd\":\"1c072216AECDFBD3B6C1B87C7370DFCEE5\",\"gid\":\"46804818-5dae-e440-6a60-db709c5b82d7\",\"guestChikyugo\":\"00000016\",\"headPortrait\":\"4e27e819-5c2a-4e50-aeb9-0481f0151f17.jpg\",\"joinTime\":\"2014-12-19 18:14:33\",\"lastLoginIp\":\"106.226.59.52\",\"lastLoginTime\":\"2015-05-16 14:16:33\",\"latitude\":\"27.826707\",\"longitude\":\"114.406331\",\"memberName\":\"可力\",\"memberType\":1,\"mobile\":\"18970508666\",\"passward\":\"125BAFAE91627BB05DA33FF021CB189D39\",\"registeredCity\":\"宜春市\",\"sex\":\"1\",\"signature\":\"\",\"status\":1},\"memberGid\":\"55574b1f-e578-1b81-f4ff-0b9b9c55a933\",\"status\":0,\"userType\":1,\"validTime\":\"1432742400000\"}}";
//    id ret = [RLJSON JSONObjectWithString:str];
//    DLog(@"%@", ret);
//    long long data = [[NSDate date] timeIntervalSince1970]*1000;
//    DLog(@"%lli", data);
#endif
    
#if 0
    NSString *string = @"2015-04-05";
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateformatter dateFromString:string];
    
    NSDateComponents *com = [RLDate dateComponentsWithDate:date];
#endif
    
#if 1
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:10000],@"pwd",
                          @"good", @"name",
                          @"1111111111", @"address",
                          [NSNumber numberWithInt:100], @"status",
                          nil];
    
//    KeyEntity *key = (KeyEntity *)[[MyCoreDataManager sharedManager] insertRecordForTable:NSStringFromClass([KeyEntity class])];
//    key.name = @"good";
//    key.keyID = @200;
//    
    LockEntity *lock = (LockEntity *)[[MyCoreDataManager sharedManager] insertRecordForTable:NSStringFromClass([LockEntity class])];
    lock.name = @"i-------------------i";
    lock.lockID = @100;
//    key.ownLock = lock;
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"hello",@"caption",
                          @"5-3",@"endDate",
                          @"good", @"name",
                          [NSNumber numberWithInt:100], @"status",
                          [NSNumber numberWithBool:YES], @"useCount",
                          lock, @"ownLock",
                          nil];
    
    [[MyCoreDataManager sharedManager] insertObjectInObjectTable:dict withTablename:NSStringFromClass([KeyEntity class])];
//    [[MyCoreDataManager sharedManager] save];
    
    NSArray *keys = [[MyCoreDataManager sharedManager] objectsSortByAttribute:nil withTablename:NSStringFromClass([KeyEntity class])];
    for(KeyEntity *key in keys) {
        LockEntity *lock = (LockEntity *)key.ownLock;
        DLog(@"%@", lock.name);
    }
#endif
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#pragma mark - Test
//    [self test];
    
#pragma mark - Location

#pragma mark - SoundManager
    [[SoundManager sharedManager] prepareToPlay];
    
#pragma mark - Network
    static BOOL isCanShowAlert = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isCanShowAlert) {
                    isCanShowAlert = NO;
                    [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"网络不可用", nil) dimissBlock:^{
                        isCanShowAlert = YES;
                    }];
                }
            });
        }
    }];
    
#pragma mark -
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#if 0
    /************** Test *****************/
//    ViewController *vc = [ViewController new];
    TestViewController *vc = [TestViewController new];
//    [Register verifyPhone:@"111" withBlock:^(id response, NSError *error) {
//
//    }];
    
    RLBaseNavigationController *nav = [RLBaseNavigationController new];
    [nav pushViewController:vc animated:NO];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
//    static int i = 0;
//    i++;
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          @"hello",@"title",
//                          @"abc",@"content",
//                          @"150123123",@"from",
//                          @"777777777",@"to",
//                          @"5-3", @"time",
//                          @"test", @"extension",
//                          @284837487492, @"timestamp",
//                          [NSNumber numberWithInt:i], @"id",
//                          [NSNumber numberWithBool:NO], @"isRead",
//                          nil];
//    
//    [[MyCoreDataManager sharedManager] insertObjectInObjectTable:dict withTablename:NSStringFromClass([Message class])];
    
    NSArray *messages = [[MyCoreDataManager sharedManager] objectsSortByAttribute:nil withTablename:NSStringFromClass([Message class])];
    DLog(@"%@", messages);
    for(Message *message in messages) {
        DLog(@"%@", message.title);
        DLog(@"%@", message.content);
    }
#else
//    MainVC *vc = [MainVC new];
//    LoginVC *vc = [LoginVC new];
    User *user = [User loadArchiver];
    
    [[self class] setLoginVCToRootVCAnimate:NO];
    if(user) {
        [[User sharedUser] setWithUser:user];
        if([[XMPPManager sharedXMPPManager] connect]) {
            [[self class] setMainVCToRootVCAnimate:NO];
        }
        else {
            [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"登录失败", nil)];
        }
    }
    
    [self.window makeKeyAndVisible];
    
#pragma mark -
    [RLNotificationManager openNotificationPermission];
    [RLNotificationManager openRemoteNotification];
//    [RLNotificationManager messageNotification];
    
#pragma mark - Version agent
//    [[AWVersionAgent sharedAgent] setDebug:YES];
//    [AWVersionAgent sharedAgent].actionText = @"test";
//    [[AWVersionAgent sharedAgent] checkNewVersionForApp:@"453718989"];
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        [self application:application didReceiveLocalNotification:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    }
    
    if(launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[RLLocationManager sharedLocationManager] stopUpdatingLocation];
    [[RLBluetooth sharedBluetooth] disconnectAllPeripherals];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication*
    app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    [[RLLocationManager sharedLocationManager] startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [RLBluetooth sharedRelease];
}

#pragma mark -
/*****************************************************
 1.创建消息上面要添加的动作(按钮的形式显示出来)
 2.创建动作(按钮)的类别集合
 3.创建UIUserNotificationSettings，并设置消息的显示类类型
 4.注册推送
 5.发起本地推送消息
 6.在AppDelegate.m里面对结果进行处理
 *****************************************************/
//本地推送通知
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //成功注册registerUserNotificationSettings:后，回调的方法
//    DLog(@"%@",notificationSettings);
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //收到本地推送消息后调用的方法
    DLog(@"%@",notification);
    [[AWVersionAgent sharedAgent] upgradeAppWithNotification:notification];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    DLog(@"%@----%@",identifier,notification);
    completionHandler();//处理完消息，最后一定要调用这个代码块
}

#pragma mark -
//远程推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //向APNS注册成功，收到返回的deviceToken
    
    DLog(@"APNS OK device token = %@", deviceToken);
    [User sharedUser].deviceToken = deviceToken;
    self.deviceToken = deviceToken;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //向APNS注册失败，返回错误信息error
    DLog(@"APNS error = %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //收到远程推送通知消息
    DLog(@"%@", userInfo);
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮

}

#pragma mark -
+ (void)setLoginVCToRootVCAnimate:(BOOL)animate {
    UIViewController *loginVC = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController;
    
    if([loginVC isKindOfClass:[RLBaseNavigationController class]]) {
        if([[loginVC.childViewControllers firstObject] isKindOfClass:[LoginVC class]]) {
            return;
        }
    }
    
    loginVC = [LoginVC new];
    
    RLBaseNavigationController *nav = [[RLBaseNavigationController alloc] initWithRootViewController:loginVC];
    if(animate) {
        [[self class] changeRootViewController:nav];
    }
    else {
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController = nav;
    }
}

+ (void)setMainVCToRootVCAnimate:(BOOL)animate {
    
    UIViewController *vc = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController;
    
    if([vc isKindOfClass:[RLBaseNavigationController class]]) {
        if([[vc.childViewControllers firstObject] isKindOfClass:[MainVC class]]) {
            return;
        }
    }
    
    vc = [MainVC new];
    RLBaseNavigationController *mainNav = [[RLBaseNavigationController alloc] initWithRootViewController:vc];
    if(animate) {
        [[self class] changeRootViewController:mainNav];
    }
    else {
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController = mainNav;
    }
}

#pragma mark - public methods
+ (void)changeRootViewController:(UIViewController *)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *windown = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
        if(vc == nil || windown.rootViewController == vc)
            return;
        
        CGPoint currentCenter;
        UIViewController *currentVC = windown.rootViewController;
        currentCenter = currentVC.view.center;
        [vc.view addSubview:currentVC.view];
        
        vc.view.center = CGPointMake(currentCenter.x, -currentCenter.y);
        [windown setRootViewController:vc];
        [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            currentVC.view.center = CGPointMake(currentCenter.x, currentCenter.y+vc.view.frame.size.height);
            vc.view.center = currentCenter;
        } completion:^(BOOL finished) {
            for(UIViewController *tempVC in currentVC.childViewControllers) {
                [tempVC.view removeFromSuperview];
                [tempVC removeFromParentViewController];
            }
            
            [currentVC.view removeFromSuperview];
        }];
    });
}

@end

#if 0
/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{    [self gcdDemo4];}
 #pragma mark - 串行队列
 - (void)gcdDemo1{
 // 1. 串行队列
 // 在使用GCD的时候，先敲dispatch
 // 在C语言中，定义对象通常是以 _t 或者 Ref 结尾的    dispatch_queue_t q = dispatch_queue_create("myQueueName", DISPATCH_QUEUE_SERIAL); //DISPATCH_QUEUE_SERIAL 的值为 NULL        NSLog(@"%@", [NSThread currentThread]);
 // 2. 同步任务 sync(实际开发中没用)
 for (int i = 0; i < 10; i++) {        dispatch_sync(q, ^{            NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }
 // 2. 异步任务 async，能够开线程
 // 串行队列中，异步任务最多只能开一条线程，所有任务顺序执行！
 // 串行队列，异步任务，在多线程中，是斯坦福大学最推荐的一种多线程方式！
 // 优点：将任务放在其他线程中工作，每个任务顺序执行，便于调试
 // 缺点：并发能力不强，最多只能使用一条线程！
 for (int i = 0; i < 10; i++) {        dispatch_async(q, ^{            NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }}
 #pragma mark - 并行队列
 - (void)gcdDemo2{
 // 1. 并行队列    dispatch_queue_t q = dispatch_queue_create("myQueueName", DISPATCH_QUEUE_CONCURRENT);
 // 非ARC中，需要自己释放队列
 //    dispatch_release(q);
 // 2. 同步任务，不会开启新的线程
 // 在实际开发中，同步任务可以保证执行完成之后，才让后续的异步任务开始执行，用于控制任务之间的先后顺序，如在后台线程中，处理“用户登录”等
 for (int i = 0; i < 10; i++) {        dispatch_sync(q, ^{            NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }
 // 3. 异步任务，会在多条线程上工作，具体开多少条线程，由系统决定
 // 仍然是按照任务添加到队列中的顺序被调度，只是执行先后可能会有差异！
 // *** 能够将耗时的操作，放到子线程中工作
 // *** 与串行队列异步任务相比，并发性能更好！但是执行的先后顺序，不固定
 for (int i = 0; i < 10; i++) {        dispatch_async(q, ^{            NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }}
 #pragma mark - 全局并行(并发)队列（使用更为普遍一些）
 - (void)gcdDemo3{
 // 1. 获取全局队列（与自定义并行队列的区别就是名字显示，其他都一样）    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 // 使用全局队列，不需要考虑共享的问题
 // 2. 同步任务
 for (int i = 0; i < 10; i++) {
 dispatch_sync(q, ^{
 NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }
 // 3. 异步任务
 for (int i = 0; i < 10; i++) {        dispatch_async(q, ^{            NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }}
 #pragma mark - 主队列（专门调度在主线程上工作的队列，不能开线程）
 - (void)gcdDemo4{
 // 1. 获取主队列    dispatch_queue_t q = dispatch_get_main_queue();
 // 2. 不要同步任务(死锁！！！)
 //    dispatch_sync(q, ^{
 //        NSLog(@"不会输出的!!!");
 //    });
 // 3. 异步任务，在主线程上依次顺序执行
 for (int i = 0; i < 10; i++) {        dispatch_async(q, ^{            NSLog(@"%@ - %d", [NSThread currentThread], i);        });    }
 }
 */

#endif
