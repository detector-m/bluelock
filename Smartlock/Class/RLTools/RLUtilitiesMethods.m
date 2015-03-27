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
