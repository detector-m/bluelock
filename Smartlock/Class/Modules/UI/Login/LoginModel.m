//
//  LoginModel.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "LoginModel.h"
#import "RLTypecast.h"

@implementation LoginModel
- (NSDictionary *)toDictionary {
    NSMutableDictionary *parameters = nil;
    parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.account forKey:@"userName"];
    [parameters setObject:self.password forKey:@"passward"];
    
    [parameters setObject:self.deviceToken forKey:@"deviceToken"];
    [parameters setObject:[RLTypecast doubleToString:self.location.latitude] forKey:@"latitude"];
    [parameters setObject:[RLTypecast doubleToString:self.location.longitude] forKey:@"longitude"];
    [parameters setObject:self.location.city forKey:@"registeredCity"];
    return parameters;
}

+ (NSDictionary *)logoutWithToken:(NSString *)token {
    NSDictionary *parameters = @{@"accessToken":token};
    
    return parameters;
}
@end
