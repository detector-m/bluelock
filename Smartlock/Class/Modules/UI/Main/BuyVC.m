//
//  BuyVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "BuyVC.h"
#import "RLHTTPAPIClient.h"

@implementation BuyVC
//http://www.dqcc.com.cn:7080/mobile/shopLock.jsp

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSString *requestUrl = @"http://www.dqcc.com.cn:7080/mobile/shopLock.jsp";
//        self.url = [kRLHTTPAPIBaseURLString stringByAppendingString:requestUrl];
        self.url = requestUrl;
    }
    
    return self;
}
@end
