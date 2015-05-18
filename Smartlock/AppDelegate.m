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

/************** Test *****************/
#import "ViewController.h"
#import "TestViewController.h"
#import "Register.h"
#import "MyCoreDataManager.h"

#import "BluetoothLockCommand.h"

#import "Message.h"
/*************************************/

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)test {
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

    long long data = [[NSDate date] timeIntervalSince1970]*1000;
    DLog(@"%lli", data);
#if 0
    Byte data[] = {0x3c, 0xbd, 0xec, 0x37, 0xd6, 0xa2, 0x40, 0x4f, 0x96, 0xa0, 0x83, 0xa3, 0xaa, 0x5d, 0x73, 0x82, 0x3c, 0xbd, 0xec, 0x37, 0xd6, 0xa2, 0x40, 0x4f, 0x96, 0xa0, 0x83, 0xa3, 0xaa, 0x5d, 0x73, 0x82};
    
    struct BL_cmd cmd = {0};
    cmd.ST = 0x55;
    cmd.CRC += cmd.ST;
    cmd.cmd_code = 0x01;
    cmd.CRC += cmd.cmd_code;
    cmd.union_mode.connection = 0x01;
    cmd.CRC += cmd.union_mode.connection;
    cmd.result.keep = 0x00;
    cmd.CRC += cmd.union_mode.keep;
    cmd.END = 0x66;
    
    cmd.data = data;
    cmd.data_len = sizeof(data);
    cmd.CRC += CMDDatasCRCCheck(cmd.data, cmd.data_len);

    cmd.fixation_len = 7;
    NSInteger len = cmd.data_len + cmd.fixation_len;// + sizeof(cmd) - sizeof(Byte *);
    Byte *bytes = calloc(len, sizeof(UInt8));
    
//    NSLog(@"%02x, %02x, %02x, %02x, %02x", cmd.union_mode.common, cmd.union_mode.connection, cmd.union_mode.user_type, cmd.union_mode.keep, cmd.union_mode.broadcast_name_len);
    wrappCMDToBytes(&cmd, bytes);
    
    //    Byte temp = 0;
    //    int i;
    //    NSMutableString *str = [NSMutableString stringWithString:@""];
    //    for( i=0; i<sizeof(bytes)-2; i++) {
    //        temp += bytes[i];
    //    }
    //    bytes[i] = temp;
    
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSInteger length = len;//sizeof(bytes);
    NSLog(@"%@", [NSData dataWithBytes:bytes length:len]);
    int i;
    for(i=0; i<length; i++) {
        [str appendString:[NSString stringWithFormat:@"%02x", bytes[i]]];
    }
    
#endif
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#pragma mark - Test
//    [self test];
    
#pragma mark -
//----------------------------------//
    [[RLLocationManager sharedLocationManager] startUpdatingLocation];
//----------------------------------//
    
#pragma mark -
//    [[XMPPManager sharedXMPPManager] setupStream];
    
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

//        [[MyDatabaseManager sharedManager] insertUpdateRecordInRecordTable:dict];
    /*************************************/
#else
    //    MainVC *vc = [MainVC new];
//    LoginVC *vc = [LoginVC new];
    UIViewController *vc = nil;
    User *user = [User loadArchiver];
    vc = [LoginVC new];

    RLBaseNavigationController *nav = [RLBaseNavigationController new];
    [nav pushViewController:vc animated:NO];
    if(user) {
        [[User sharedUser] setWithUser:user];
        if([[XMPPManager sharedXMPPManager] connect]) {
            [RLHUD hudAlertWithBody:NSLocalizedString(@"登录失败", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
            DLog(@"xmpp connect error");
            vc = [MainVC new];
            [nav pushViewController:vc animated:NO];
        }
    }

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
#pragma mark -
//    [RLLocalNotificationManager setNotificationPermission];
//    [RLLocalNotificationManager messageNotification];
    [RLNotificationManager openNotificationPermission];
    [RLNotificationManager openRemoteNotification];
    [RLNotificationManager messageNotification];
#pragma mark - Version agent
    [[AWVersionAgent sharedAgent] setDebug:YES];
    [AWVersionAgent sharedAgent].actionText = @"test";
    [[AWVersionAgent sharedAgent] checkNewVersionForApp:@"453718989"];
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        [self application:application didReceiveLocalNotification:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    }
    
    if(launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
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
    DLog(@"%@",notificationSettings);
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
}
@end
