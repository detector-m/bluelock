//
//  RLHTTPAPIClient.h
//  Smartlock
//
//  Created by RivenL on 15/4/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "AFHTTPSessionManager.h"
extern NSString * const kRLHTTPAPIBaseURLString;
@interface RLHTTPAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
