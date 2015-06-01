//
//  DeviceModel.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel
- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if(self = [super init]) {
        self.ID = [parameters[@"id"] integerValue];
        self.status = [parameters[@"status"] integerValue];
        self.time = [parameters objectForKey:@"addTime"];
        self.ower = [parameters objectForKey:@"memberGid"];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    return @{};
}

#pragma mark -
+ (NSDictionary *)lockListParameters:(NSString *)accessToken {
    return @{@"accessToken":accessToken};
}
+ (NSDictionary *)modifyKeyNameParameters:(NSInteger)keyId gid:(NSString *)gid token:(NSString *)token keyName:(NSString *)keyName {
    return @{@"id":[RLTypecast integerToString:keyId], @"memberGid":gid, @"lockName":keyName, @"accessToken":token};
}

+ (NSDictionary *)keyListOfAdminParameters:(NSString *)token lockID:(NSUInteger)lockID {
    return @{@"accessToken":token, @"bleLockId":[RLTypecast integerToString:lockID]};
}

+ (NSDictionary *)lockOrUnlockKeyParameters:(NSUInteger)keyID operation:(NSUInteger)operation token:(NSString *)token {
    return @{@"bleKeyId":[RLTypecast integerToString:keyID], @"flag":[RLTypecast integerToString:operation], @"accessToken":token};
}

+ (NSDictionary *)deleteKeyParameters:(NSUInteger)keyID token:(NSString *)token {
    return @{@"bleKeyId":[RLTypecast integerToString:keyID], @"accessToken":token};
}

+ (NSDictionary *)openLockParameters:(NSString *)recordList token:(NSString *)token {
    return @{@"dataList":recordList, @"accessToken":token};
}

@end
