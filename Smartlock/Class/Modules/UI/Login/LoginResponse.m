//
//  LoginResponse.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "LoginResponse.h"

@interface LoginResponse ()
@property (nonatomic, readwrite, assign) BOOL success;
@end

@implementation LoginResponse
@synthesize success;

- (instancetype)initWithResponseObject:(id)responseObject {
    if(self = [super initWithResponseObject:responseObject]) {
        [self dealStatus];
    }
    
    return self;
}

- (void)dealStatus {
    if(self.status == 0) {
        self.success = YES;
        return;
    }
    
    DLog(@"status=%d message = %@", self.status, self.resDescription);
}
@end
