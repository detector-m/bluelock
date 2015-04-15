//
//  DeviceModel.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel
- (NSDictionary *)toDictionary {
    return nil;
}

#pragma mark -
+ (NSDictionary *)lockListParameters:(NSString *)accessToken {
    return @{@"accessToken":accessToken};
}
+ (NSDictionary *)keyListOfAdminParameters:(NSString *)token lockID:(NSUInteger)lockID {
    return @{@"accessToken":token, @"bleLockId":[RLTypecast integerToString:lockID]};
}

+ (NSDictionary *)lockOrUnlockKeyParameters:(NSUInteger)lockID keyID:(NSUInteger)keyID operation:(NSUInteger)operation token:(NSString *)token {
    return @{@"bleLockId":[RLTypecast integerToString:lockID], @"bleKey":[RLTypecast integerToString:keyID], @"flag":[RLTypecast integerToString:operation], @"accessToken":token};
}

+ (NSDictionary *)openLockParameters:(NSUInteger)lockID keyID:(NSUInteger)keyID token:(NSString *)token {
    return @{@"bleLockId":[RLTypecast integerToString:lockID], @"bleKey":[RLTypecast integerToString:keyID], @"accessToken":token};
}

@end
