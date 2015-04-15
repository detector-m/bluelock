//
//  RLHUD.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLHUD.h"

@implementation RLHUD
+ (MBHUDView *)hudAlertWithBody:(NSString *)body type:(MBAlertViewHUDType)type hidesAfter:(float)delay show:(BOOL)show {
    return [MBHUDView hudWithBody:body type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
}

#pragma mark - 
static MBProgressHUD *hudProgress = nil;
+ (void)hudProgressWithBody:(NSString *)body onView:(UIView *)view timeout:(NSTimeInterval)timeout {
    if(hudProgress) {
        [hudProgress setHidden:YES];
        [hudProgress removeFromSuperview];
        hudProgress = nil;
    }
    if(!hudProgress) {
        hudProgress = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hudProgress];
        hudProgress.labelText = body;
    }

    __weak typeof(self)weakSelf = self;
    [hudProgress showAnimated:YES whileExecutingBlock:^{
        [weakSelf timeout:timeout];
    } completionBlock:^{
        if(hudProgress) {
            [hudProgress removeFromSuperview];
            hudProgress = nil;
        }
    }];

}

+ (void)timeout:(NSTimeInterval)timeout {
    // Do something usefull in here instead of sleeping ...
    sleep(timeout);
}

+ (void)hideProgress {
    if(hudProgress) {
//        [hudProgress setHidden:YES];
//        [hudProgress removeFromSuperview];
        [hudProgress hide:YES afterDelay:1.0f];
//        hudProgress = nil;
    }
}
@end
