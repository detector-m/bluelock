//
//  LockModel.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "LockModel.h"

@implementation LockModel

- (NSDictionary *)toDictionary {
    NSMutableDictionary *parameters = nil;
    parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.name forKey:@"lockName"];
    [parameters setObject:self.address forKey:@"bleAddress"];
    [parameters setObject:self.token forKey:@"accessToken"];
    
    return parameters;
}
@end
