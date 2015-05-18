//
//  SendKeyVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/5.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SendKeyVC.h"

#import "RLHTTPAPIClient.h"

@implementation SendKeyVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSString *requestUrl = [NSString stringWithFormat:@"/bleLock/initSendKey.jhtml?accessToken=%@", [User sharedUser].sessionToken];
        self.url = [kRLHTTPAPIBaseURLString stringByAppendingString:requestUrl];
    }
    
    return self;
}

@end
