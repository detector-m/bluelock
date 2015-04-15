//
//  RLTool.m
//  Smartlock
//
//  Created by RivenL on 15/4/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTool.h"

@implementation RLTool
+ (instancetype)sharedTool {
    static RLTool *_sharedTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTool = [[self alloc] init];
    });
    
    return _sharedTool;
}

+ (void)setup {
//    [[RLLocationManager sharedLocationManager] startUpdatingLocation];
}
+ (void)unset {

}
@end
