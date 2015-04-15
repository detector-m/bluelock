//
//  RLRequest.m
//  Smartlock
//
//  Created by RivenL on 15/4/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLRequest.h"

@implementation RLRequest

+ (NSURLSessionDataTask *)requestWithUrl:(NSString *)url withParameters:(NSDictionary *)parameters andBlock:(void (^)(id responseObject, NSError * error)) block {
    return [[RLHTTPAPIClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if(block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(block) {
            block(@"Error", error);
        }
    }];
}
@end
