//
//  RLTool.h
//  Smartlock
//
//  Created by RivenL on 15/4/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLLocationManager.h"

@interface RLTool : NSObject
+ (instancetype)sharedTool;

+ (void)setup;
+ (void)unset;
@end
