//
//  KeyModel.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "KeyModel.h"
#import "KeyEntity.h"

@implementation KeyModel

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if(self = [super initWithParameters:parameters]) {
        self.keyStatus = self.status;
        self.type = [parameters[@"keyType"] integerValue];//[RLTypecast stringToInteger:[parameters objectForKey:@"keyType"]];
        self.userType = [parameters[@"userType"] integerValue]; //[RLTypecast stringToInteger:[parameters objectForKey:@"userType"]];
        self.name = [parameters objectForKey:@"lockName"];
        self.invalidDate = [parameters objectForKey:@"validTime"];
        
        self.lockID = [parameters[@"bleLockId"] integerValue];//[RLTypecast stringToInteger:[parameters objectForKey:@"bleLockId"]];

        _keyOwner = [[LockModel alloc] initWithParameters:parameters[@"bleLock"]];
    }
    
    return self;
}

- (instancetype)initWithKeyEntity:(KeyEntity *)keyEntity {
    if(self = [super init]) {
        self.ID = [keyEntity.keyID integerValue];
        self.lockID = [keyEntity.lockID integerValue];
        self.type = [keyEntity.type integerValue];
        self.status = [keyEntity.status integerValue];
        self.invalidDate = [keyEntity endDate];
        self.caption = keyEntity.caption;
        self.name = keyEntity.name;
        self.ower = keyEntity.ownUser;
        self.userType = [keyEntity.userType integerValue];
        self.validCount = [keyEntity.useCount integerValue];
        self.keyOwner = [[LockModel alloc] initWithLockEntity:keyEntity.ownLock];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *parameters = nil;
    parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.name forKey:@"lockName"];
    [parameters setObject:[RLTypecast integerToString:self.lockID] forKey:@"bleLockId"];
    [parameters setObject:self.ower forKey:@"memberGid"];
    [parameters setObject:[RLTypecast integerToString:self.type] forKey:@"keyType"];
    [parameters setObject:[RLTypecast integerToString:self.validCount] forKey:@"validTime"];
    [parameters setObject:self.token forKey:@"accessToken"];
    
    return parameters;
}

#pragma mark -
- (BOOL)isValid {
    if(self.type == kKeyTypeTimes) {
        return self.validCount > 0;
    }
    return self.status != kKeyExpire && self.status != kKeyFreeze;
}
@end
