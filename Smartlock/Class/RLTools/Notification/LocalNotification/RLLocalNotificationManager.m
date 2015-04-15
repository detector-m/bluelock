//
//  LocalNotificationManager.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLLocalNotificationManager.h"

@implementation RLLocalNotificationManager
#if 0
+ (void)setNotificationPermission {
    // Accept Action
    
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"Accept";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    // Reject Action
    
    UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
    rejectAction.identifier = @"Reject";
    rejectAction.title = @"Reject";
    rejectAction.activationMode = UIUserNotificationActivationModeBackground;
    rejectAction.destructive = YES;
    rejectAction.authenticationRequired = YES;
    
    // Reply Action
    
    UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc] init];
    replyAction.identifier = @"Reply";
    replyAction.title = @"Reply";
    replyAction.activationMode = UIUserNotificationActivationModeForeground;
    replyAction.destructive = NO;
    replyAction.authenticationRequired = YES;
    
    // Email Category
    
    UIMutableUserNotificationCategory *emailCategory = [[UIMutableUserNotificationCategory alloc] init];
    emailCategory.identifier = @"Email";
    [emailCategory setActions:@[acceptAction,rejectAction,replyAction] forContext:UIUserNotificationActionContextDefault];
    [emailCategory setActions:@[acceptAction,rejectAction] forContext:UIUserNotificationActionContextMinimal];
    
    // Download Action
    
    UIMutableUserNotificationAction *downloadAction = [[UIMutableUserNotificationAction alloc] init];
    downloadAction.identifier = @"Download";
    downloadAction.title = @"Download";
    downloadAction.activationMode = UIUserNotificationActivationModeForeground;
    downloadAction.destructive = NO;
    downloadAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *cancelAction = [[UIMutableUserNotificationAction alloc] init];
    cancelAction.identifier = @"Cancel";
    cancelAction.title = @"Cancel";
    cancelAction.activationMode = UIUserNotificationActivationModeForeground;
    cancelAction.destructive = YES;
    cancelAction.authenticationRequired = YES;
    
    
    // Image Category
    
    UIMutableUserNotificationCategory *imageCategory = [[UIMutableUserNotificationCategory alloc] init];
    imageCategory.identifier = @"Image";
    [imageCategory setActions:@[downloadAction,cancelAction] forContext:UIUserNotificationActionContextDefault];
    [imageCategory setActions:@[downloadAction,cancelAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    NSSet *categories = [NSSet setWithObjects:emailCategory,imageCategory, nil];
    UIUserNotificationType notificarionType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    // Register notification types and categories
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificarionType categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    // This line of code is required for remote push notification
    //[[UIApplication sharedApplication] registerForRemoteNotifications];
}
#endif
+ (void)setNotificationPermission {
    // message category
    if([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
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

+ (void)messageNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = @"Email Based Notification";
    localNotification.category = @"Email";  // This should match categories identifier which we have defined in App delegate
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
@end
