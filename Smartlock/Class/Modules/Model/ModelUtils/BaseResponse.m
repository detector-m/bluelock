//
//  BaseResponse.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "BaseResponse.h"

@implementation BaseResponse
- (instancetype)initWithResponseObject:(id)responseObject {
    if(self = [super init]) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resDic = responseObject;
            self.resDescription = [resDic objectForKey:@"message"];
            self.status = [[resDic objectForKey:@"status"] integerValue];
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
@end
