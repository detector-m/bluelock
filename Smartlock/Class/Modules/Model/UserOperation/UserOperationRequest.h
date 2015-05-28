//
//  UserOperationRequest.h
//  Smartlock
//
//  Created by RivenL on 15/5/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLRequest.h"
#import "UserOperationResponse.h"

@interface UserOperationRequest : RLRequest
#pragma mark -
+ (void)modifyInfo:(NSDictionary *)infoDictionary withBlock:(void (^)(UserOperationResponse *response, NSError *error))block;

#pragma mark -
+ (NSDictionary *)paramaterForModifyNickname:(NSString *)nickname andToken:(NSString *)token;
@end
