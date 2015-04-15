//
//  RLHUD.h
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBHUDView.h"
#import "MBProgressHUD.h"

@interface RLHUD : NSObject
+ (MBHUDView*)hudAlertWithBody:(NSString*)body type:(MBAlertViewHUDType)type hidesAfter:(float)delay show:(BOOL)show;


#pragma mark - ProgressHUD
+ (void)hudProgressWithBody:(NSString *)body onView:(UIView *)view timeout:(NSTimeInterval)timeout;
+ (void)hideProgress;
@end
