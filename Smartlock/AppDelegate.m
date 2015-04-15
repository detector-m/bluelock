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

#import "RLLocalNotificationManager.h"

/************** Test *****************/
#import "ViewController.h"
#import "TestViewController.h"
/*************************************/

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//----------------------------------//
    [[RLLocationManager sharedLocationManager] startUpdatingLocation];
//----------------------------------//

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /************** Test *****************/
//    ViewController *vc = [ViewController new];
//    TestViewController *vc = [TestViewController new];
    /*************************************/
    //    MainVC *vc = [MainVC new];
//    LoginVC *vc = [LoginVC new];
    UIViewController *vc = nil;
    User *user = [User loadArchiver];
    if(user) {
        [[User sharedUser] setWithUser:user];
        vc = [MainVC new];
    }
    else {
        vc = [LoginVC new];
    }
    RLBaseNavigationController *nav = [RLBaseNavigationController new];
    [nav pushViewController:vc animated:NO];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
#pragma mark -
    [RLLocalNotificationManager setNotificationPermission];
//    [RLLocalNotificationManager messageNotification];
    
     [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
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
    DLog(@"yes");
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
}
@end
