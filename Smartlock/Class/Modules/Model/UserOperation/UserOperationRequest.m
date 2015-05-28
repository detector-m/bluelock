//
//  UserOperationRequest.m
//  Smartlock
//
//  Created by RivenL on 15/5/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "UserOperationRequest.h"

@implementation UserOperationRequest
+ (void)modifyInfo:(NSDictionary *)infoDictionary withBlock:(void (^)(UserOperationResponse *response, NSError *error))block {
    
    void (^modifyInfoBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        UserOperationResponse *response = [[UserOperationResponse alloc] initWithResponseObject:responseObject];
//        [User sharedUser].sessionToken = [responseObject objectForKey:@"accessToken"];
        
        if(block) {
            block(response, nil);
        }
    };

    [self requestWithUrl:@"member/updateUserInfo.jhtml" withParameters:infoDictionary andBlock:modifyInfoBlock];
}

#pragma mark -
+ (NSDictionary *)paramaterForModifyNickname:(NSString *)nickname andToken:(NSString *)token {
    return @{@"memberName" : nickname, @"accessToken" : token};
}
@end
