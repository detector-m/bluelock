//
//  RLHUD.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLHUD.h"

@implementation RLHUD
//+ (MBHUDView *)hudAlertWithBody:(NSString *)body type:(MBAlertViewHUDType)type hidesAfter:(float)delay show:(BOOL)show {
//    return [MBHUDView hudWithBody:body type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
//}

NSString *kSuccessTitle = @"Congratulations 😊";
NSString *kErrorTitle = @"Error 😭";
NSString *kNoticeTitle = @"Notice";
NSString *kWarningTitle = @"Warning ⚠️";
NSString *kInfoTitle = @"Info";
NSString *kWaitingTitle = @"Waiting... ⌛️";

+ (SCLAlertView *)alertViewOnScreenHide {
    for(UIViewController *vc in [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers) {
        if([vc isKindOfClass:[SCLAlertView class]]) {
            [(SCLAlertView *)vc hideView];
            return (SCLAlertView *)vc;
        }
    }
    
    return nil;
}

#pragma mark -
+ (void)hudAlertSuccessWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showSuccess:[UIApplication sharedApplication].keyWindow.rootViewController title:kSuccessTitle
                subTitle:body
        closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });
}
+ (void)hudAlertErrorWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showError:[UIApplication sharedApplication].keyWindow.rootViewController title:kErrorTitle
                  subTitle:body
          closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });
}
+ (void)hudAlertNoticeWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showNotice:[UIApplication sharedApplication].keyWindow.rootViewController title:kNoticeTitle
                subTitle:body
        closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });

}
+ (void)hudAlertWarningWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showWarning:[UIApplication sharedApplication].keyWindow.rootViewController title:kWarningTitle
                 subTitle:body
         closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });
}
+ (void)hudAlertInfoWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showInfo:[UIApplication sharedApplication].keyWindow.rootViewController title:kInfoTitle
                 subTitle:body
         closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });
}
+ (void)hudAlertEditWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showEdit:[UIApplication sharedApplication].keyWindow.rootViewController title:body
                 subTitle:nil
         closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });
}
+ (void)hudAlertCustomWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
}
+ (void)hudAlertWaitingWithBody:(NSString *)body dimissBlock:(DismissBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertViewOnScreenHide];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(block) {
            [alert alertIsDismissed:block];
        }
        [alert showWaiting:[UIApplication sharedApplication].keyWindow.rootViewController title:kWaitingTitle
                 subTitle:body
         closeButtonTitle:NSLocalizedString(@"确定", nil) duration:5.0f];
    });
}

+ (void)hudAlertSuccessWithBody:(NSString *)body {
    [self hudAlertSuccessWithBody:body dimissBlock:nil];
}
+ (void)hudAlertErrorWithBody:(NSString *)body {
    [self hudAlertErrorWithBody:body dimissBlock:nil];
}
+ (void)hudAlertNoticeWithBody:(NSString *)body {
    [self hudAlertNoticeWithBody:body dimissBlock:nil];
}
+ (void)hudAlertWarningWithBody:(NSString *)body {
    [self hudAlertWarningWithBody:body dimissBlock:nil];
}
+ (void)hudAlertInfoWithBody:(NSString *)body {
    [self hudAlertInfoWithBody:body dimissBlock:nil];
}
+ (void)hudAlertEditWithBody:(NSString *)body {
    [self hudAlertErrorWithBody:body dimissBlock:nil];
}
+ (void)hudAlertCustomWithBody:(NSString *)body {

}
+ (void)hudAlertWaitingWithBody:(NSString *)body {
    [self hudAlertWarningWithBody:body dimissBlock:nil];
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

#pragma mark -
+ (void)hudStatusBarProgress {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
+ (void)hideStatusBarProgress {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
