//
//  RLNotificationManager.m
//  Smartlock
//
//  Created by RivenL on 15/4/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLNotificationManager.h"

@implementation RLNotificationManager
+ (void)openNotificationPermission {
    // message category
    if([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        
        return;
    }
    UIMutableUserNotificationCategory *messageCategory = [UIMutableUserNotificationCategory new];
    messageCategory.identifier = @"Message";
    [messageCategory setActions:nil forContext:UIUserNotificationActionContextDefault];
    [messageCategory setActions:nil forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:messageCategory, nil];
    UIUserNotificationType notificationType = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAll;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}
+ (void)openRemoteNotification {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark -
//----------------------------------------//
+ (void)messageNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = @"Email Based Notification";
    localNotification.category = @"Email";  // This should match categories identifier which we have defined in App delegate
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
//----------------------------------------//

@end
