//
//  DeviceResponse.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DeviceResponse.h"

@implementation DeviceResponse
- (instancetype)initWithResponseObject:(id)responseObject {
    if(self = [super init]) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resDic = responseObject;
            self.resDescription = [resDic objectForKey:@"message"];
            self.status = [[resDic objectForKey:@"status"] integerValue];
//            DLog(@"%@", resDic);
            [self parserLockList:[resDic objectForKey:@"bleKeys"]];
        }
        else if([responseObject isKindOfClass:[NSArray class]] ) {
            
        }
        else if([responseObject isKindOfClass:[NSNumber class]]) {
            
        }
        else if ([responseObject isKindOfClass:[NSString class]]) {
            self.resDescription = responseObject;
            if([responseObject integerValue] != 0) {
                self.status = 1;
            }
        }
    }
    
    return self;
}

- (void)parserLockList:(NSArray *)list {
    if(!list) {
        return;
    }
    self.list = [NSMutableArray new];
    LockModel *lock = nil;
    
    for(NSDictionary *dicLock in list) {
        NSDictionary *tempLock = [dicLock objectForKey:@"bleLock"];
        lock = [[LockModel alloc] init];
        lock.name = [tempLock objectForKey:@"lockName"];
        lock.pwd =  [RLTypecast stringToLongLongInteger:[tempLock objectForKey:@"lockPwd"]] ;
        [self.list addObject:lock];
    }
}
@end
