//
//  DeviceRequest.h
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLRequest.h"
#import "DeviceModel.h"
#import "LockModel.h"
#import "KeyModel.h"
#import "DeviceResponse.h"

@interface DeviceRequest : RLRequest
/**
 *  智能锁配对
 *
 *  @param lock  锁对象
 *  @param block 回调block
 */
+ (void)addBluLock:(LockModel *)lock withBlock:(void (^)(DeviceResponse *response, NSError *error))block;

#pragma mark -
/**
 *  发送钥匙
 *
 *  @param key   钥匙对象
 *  @param block 回调block
 */
+ (void)sendKey:(KeyModel *)key withBlock:(void (^)(DeviceResponse *response, NSError *error))block;

/**
 *  用户锁列表
 *
 *  @param accessToken  accessToken
 *  @param block        回调block
 */
+ (void)lockList:(NSString *)accessToken withBlock:(void (^)(DeviceResponse *response, NSError *error))block;

/**
 *  管理员用户对应锁的钥匙列表
 *
 *  @param lockID 锁的ID
 *  @param token  token
 *  @param block  回调block
 */
+ (void)keyListOfAdmin:(NSUInteger)lockID token:(NSString *)token withBlock:(void (^)(DeviceResponse *response, NSError *error))block;

/**
 *  冻结和解冻用户锁
 *
 *  @param lockID    当前锁Id
 *  @param keyID     需要控制的钥匙Id
 *  @param operation 操作动作:0解冻，1冻结
 *  @param token     令牌
 *  @param block     回调
 */
+ (void)lockOrUnlockKey:(NSUInteger)lockID keyID:(NSUInteger)keyID operation:(NSUInteger)operation token:(NSString *)token withBlock:(void (^)(DeviceResponse *response, NSError *error))block;

/**
 *  开锁并添加记录
 *
 *  @param lockID 当前锁Id
 *  @param keyID  当前使用钥匙Id
 *  @param token  token
 *  @param block  回调block
 */
+ (void)openLock:(NSUInteger)lockID keyID:(NSUInteger)keyID token:(NSString *)token withBlock:(void (^)(DeviceResponse *response, NSError *error))block;
@end
