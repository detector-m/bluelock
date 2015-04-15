//
//  LocalNotificationManager.h
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIUserNotificationSettings+Extension.h"

@interface RLLocalNotificationManager : NSObject
+ (void)setNotificationPermission;
+ (void)messageNotification;
@end
