//
//  RLResponse.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLResponse.h"

@implementation RLResponse
- (instancetype)initWithResponseObject:(id)responseObject {
    if(self = [super init]) {
        if([responseObject isKindOfClass:[NSString class]]) {
            self.resDescription = responseObject;
            
            [self dealStatus];
        }
    }
    
    return self;
}

//- (instancetype)initWithResponseObject:(id)responseObject {
//    if(self = [super initWithResponseObject:responseObject]) {
//        [self dealStatus];
//    }
//    
//    return self;
//}

- (void)dealStatus {
    if(self.status == 0) {
        self->_success = YES;
        return;
    }
    
    DLog(@"status=%lu message = %@", (unsigned long)self.status, self.resDescription);
}

@end
