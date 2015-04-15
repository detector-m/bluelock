//
//  KeyModel.h
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DeviceModel.h"

typedef NS_ENUM(NSInteger, KeyStatus) {
    kKeyUnlocked,
    kKeyLocked
};
@interface KeyModel : DeviceModel
@property (nonatomic, assign) NSUInteger lockID;
@property (nonatomic, assign) NSUInteger validCount;
@property (nonatomic, assign) KeyStatus keyStatus;
@end
