//
//  DeviceModel.h
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *deviceDescription;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *ower;
@property (nonatomic, copy) NSString *date;

#pragma mark -
@property (nonatomic, weak) NSString *token;

- (NSDictionary *)toDictionary;

#pragma mark -
+ (NSDictionary *)lockListParameters:(NSString *)accessToken;
+ (NSDictionary *)keyListOfAdminParameters:(NSString *)token lockID:(NSUInteger)lockID;
+ (NSDictionary *)lockOrUnlockKeyParameters:(NSUInteger)lockID keyID:(NSUInteger)keyID operation:(NSUInteger)operation token:(NSString *)token;
+ (NSDictionary *)openLockParameters:(NSUInteger)lockID keyID:(NSUInteger)keyID token:(NSString *)token;
@end