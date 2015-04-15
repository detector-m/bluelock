//
//  KeyModel.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "KeyModel.h"

@implementation KeyModel
- (NSDictionary *)toDictionary {
    NSMutableDictionary *parameters = nil;
    parameters = [NSMutableDictionary dictionary];
    
//    [parameters setObject:self.name forKey:@"lockName"]
    [parameters setObject:[RLTypecast integerToString:self.lockID] forKey:@"bleLockId"];
    [parameters setObject:self.ower forKey:@"memberGid"];
    [parameters setObject:[RLTypecast integerToString:self.type] forKey:@"keyType"];
    [parameters setObject:[RLTypecast integerToString:self.validCount] forKey:@"validTime"];
    [parameters setObject:self.token forKey:@"accessToken"];
    
    return parameters;
}
@end
