//
//  RLDate.h
//  Smartlock
//
//  Created by RivenL on 15/5/16.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
extern long long timestampSince1970();
extern NSString *timeStringWithTimestamp(long long timestamp);

#pragma mark - 
@interface RLDate : NSObject

@end
