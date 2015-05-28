//
//  Login.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "Login.h"

#import "XMPPManager.h"

@implementation Login
+ (void)login:(id)login withBlock:(void (^)(LoginResponse *response, NSError *error))block {
    
    void (^loginBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        LoginResponse *response = [[LoginResponse alloc] initWithResponseObject:responseObject];
        [[User sharedUser] setWithParameters:(NSDictionary *)responseObject];
//        [User sharedUser].sessionToken = [responseObject objectForKey:@"accessToken"];
        
        if(block) {
            block(response, nil);
        }
    };
    
    [LoginRequest login:login withBlock:loginBlock];
}

+ (void)logout:(NSString *)token withBlock:(void (^)(LoginResponse *response, NSError *error))block {
    void (^logoutBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        LoginResponse *response = [[LoginResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    
    [LoginRequest logout:token withBlock:logoutBlock];
}

+ (void)forcedLogout {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[XMPPManager sharedXMPPManager] disconnect];
        [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController popToRootViewControllerAnimated:YES];
        [User removeArchiver];
        
//        [RLHUD hudAlertWithBody:@"用户异地登陆"];
    });
}

+ (void)hudAlertLogout {
    [RLHUD hudAlertNoticeWithBody:NSLocalizedString(@"用户异地登陆", nil) dimissBlock:^{
        [Login forcedLogout];
    }];
}
@end
