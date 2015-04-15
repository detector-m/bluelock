//
//  DeviceRequest.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DeviceRequest.h"

@implementation DeviceRequest
+ (void)addBluLock:(LockModel *)lock withBlock:(void (^)(DeviceResponse *, NSError *))block {
    NSDictionary *parameters = lock.toDictionary;
    
    [self requestWithUrl:@"bleLock/addBleLock.jhtml"  withParameters:parameters andBlock:block];
}

+ (void)sendKey:(KeyModel *)key withBlock:(void (^)(DeviceResponse *, NSError *))block {
    NSDictionary *parameters = key.toDictionary;
    
    [self requestWithUrl:@"bleLock/sendBleLock.jhtml"  withParameters:parameters andBlock:block];
}

+ (void)lockList:(NSString *)accessToken withBlock:(void (^)(DeviceResponse *, NSError *))block {
    NSDictionary *parameters = [DeviceModel lockListParameters:accessToken];
    
    [self requestWithUrl:@"bleLock/getBleKeyList.jhtml" withParameters:parameters andBlock:block];
}

+ (void)keyListOfAdmin:(NSUInteger)lockID token:(NSString *)token withBlock:(void (^)(DeviceResponse *, NSError *))block {
    NSDictionary *parameters = [DeviceModel keyListOfAdminParameters:token lockID:lockID];
    
    [self requestWithUrl:@"bleLock/getBleKeyListByLockId.jhtml" withParameters:parameters andBlock:block];
}

+ (void)lockOrUnlockKey:(NSUInteger)lockID keyID:(NSUInteger)keyID operation:(NSUInteger)operation token:(NSString *)token withBlock:(void (^)(DeviceResponse *, NSError *))block {

}

+ (void)openLock:(NSUInteger)lockID keyID:(NSUInteger)keyID token:(NSString *)token withBlock:(void (^)(DeviceResponse *, NSError *))block {

}
@end
