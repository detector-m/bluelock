//
//  RLUtilitiesMethods.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/29.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLUtilitiesMethods : NSObject

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

extern NSString *resourcePathWithResourceName(NSString *name);

extern NSString* RLEncode(NSString * value);
extern NSString* RLEncodeURL(NSURL * value);
extern NSString* RLFlattenHTML(NSString * value, BOOL preserveLineBreaks);
extern NSString* RLLocalizedStringFormat(NSString* key);
extern NSString* RLLocalizedString(NSString* key, ...);