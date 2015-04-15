//
//  RLUtilitiesMethods.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/29.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLUtilitiesMethods.h"

@implementation RLUtilitiesMethods

@end

NSString *resourcePathWithResourceName(NSString *name) {
    return [[NSBundle mainBundle] pathForResource:name ofType:nil];
}

NSString* RLEncode(NSString * value) {
    if (value == nil)
        return @"";
    
    NSString *string = value;
    
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    string = [string stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
    string = [string stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
    
    return string;
}

NSString* RLEncodeURL(NSURL * value) {
    if (value == nil)
        return @"";
    
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value.absoluteString, NULL,                                          CFSTR("!*'();:@&=+$,/?%#[]"),                                    kCFStringEncodingUTF8);
    return result;
}

NSString* RLFlattenHTML(NSString * value, BOOL preserveLineBreaks) {
    // Modified from http://rudis.net/content/2009/01/21/flatten-html-content-ie-strip-tags-cocoaobjective-c
    NSScanner *scanner;
    NSString *text = nil;
    
    scanner = [NSScanner scannerWithString:value];
    
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    
    if (preserveLineBreaks == NO) {
        value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

NSString* RLLocalizedStringFormat(NSString* key) {
#if 0
    static NSBundle* bundle = nil;
    if (nil == bundle) {
        
        NSString *path = [RL shareKitLibraryBundlePath];
        bundle = [NSBundle bundleWithPath:path];
        NSCAssert(bundle != nil,@"ShareKit has been refactored to be used as Xcode subproject. Please follow the updated installation wiki and re-add it to the project. Please do not forget to clean project and clean build folder afterwards. In case you use CocoaPods override - (NSNumber *)isUsingCocoaPods; method in your configurator subclass and return [NSNumber numberWithBool:YES]");
    }
    NSString *result = [bundle localizedStringForKey:key value:nil table:nil];
    return result;
#endif
    
    return NSLocalizedString(key, nil);
}

NSString* RLLocalizedString(NSString* key, ...) {
    // Localize the format
    NSString *localizedStringFormat = RLLocalizedStringFormat(key);
    
    va_list args;
    va_start(args, key);
    NSString *string = [[NSString alloc] initWithFormat:localizedStringFormat arguments:args];
    va_end(args);
    
    return string;
}
