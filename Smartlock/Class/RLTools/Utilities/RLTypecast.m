//
//  RLTypecast.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTypecast.h"

@implementation RLTypecast
+ (NSString *)integerToString:(NSInteger)aInt {
    return [NSString stringWithFormat:@"%li", (long)aInt];
}
+ (NSString *)floatToString:(CGFloat)aFloat {
    return [NSString stringWithFormat:@"%f", aFloat];
}
+ (NSString *)doubleToString:(double)aDouble {
    return [NSString stringWithFormat:@"%f", aDouble];
}
+ (NSInteger)stringToInteger:(NSString *)aStr {
    if(aStr == nil || aStr.length == 0)
        return 0;
    
    return [aStr integerValue];
}
+ (CGFloat)stringToFloat:(NSString *)aStr {
    if(aStr == nil || aStr.length == 0)
        return 0.0f;
    
    return [aStr floatValue];
}
+ (double)stringToDouble:(NSString *)aStr {
    if(aStr == nil || aStr.length == 0)
        return 0.0;
    
    return [aStr doubleValue];
}

+ (NSString *)numberToString:(NSNumber *)aNumber {
    if(aNumber == nil)
        return nil;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    return [numberFormatter stringFromNumber:aNumber];
}
+ (NSNumber *)stringToNumber:(NSString *)aStr {
    if(aStr == nil || aStr.length == 0)
        return nil;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    return [numberFormatter numberFromString:aStr];
}

//判断整形
- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断浮点型
- (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
