//
//  RLDate.m
//  Smartlock
//
//  Created by RivenL on 15/5/16.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLDate.h"

#pragma mark -

long long secondTimestampSince1970() {
    return (long long)[[NSDate date] timeIntervalSince1970];
}

long long timestampSince1970() {
    long long timestamp = 0ll;
    
    timestamp = secondTimestampSince1970();
    return timestamp;
}

NSString *timeStringWithTimestamp(long long timestamp) {
    long long sub = secondTimestampSince1970() - timestamp;
    
    NSInteger hour = 60 * 60;
    NSInteger day = hour * 24;
    
    if(sub < 0)
        return @"";
    if(sub < 60) {
        if(sub == 0)
            sub = 1;
        return [NSString stringWithFormat:@"%llds前", sub];
    }
    if(sub >= 60 && sub < hour) {
        return [NSString stringWithFormat:@"%lld分钟前", (long long)(sub/60)];
    }
    
    if(sub >= hour && sub < day) {
        return [NSString stringWithFormat:@"%i小时前", (NSInteger)(sub/hour)];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-sub];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSInteger month = day * 31;

    if(sub >= day && sub < month) {
        NSString *string = [formatter stringFromDate:date];
        return [string substringFromIndex:5];
    }
    
    if(sub >= month) {
        return [formatter stringFromDate:date];
    }
    

    
#if 0
    NSInteger month = day * 31;
    NSInteger year = month * 12;

    if(sub >= day && sub < month) {
        return [NSString stringWithFormat:@"%i", (NSInteger)(sub/day)];
    }
    
    if(sub >= month && sub < year) {
        return [NSString stringWithFormat:@"%i", (NSInteger)(sub/month)];
    }
    
    if(sub >= year) {
        return [NSString stringWithFormat:@"%i", (NSInteger)(sub/year)];
    }
#endif
    
    return @"";
}

#pragma mark -
@implementation RLDate

@end
