//
//  Login.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "Login.h"

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
        [User sharedUser].sessionToken = [responseObject objectForKey:@"accessToken"];
        
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
@end
