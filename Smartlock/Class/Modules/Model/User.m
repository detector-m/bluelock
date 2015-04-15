//
//  User.m
//  Smartlock
//
//  Created by RivenL on 15/4/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "User.h"

@interface User ()
@property (nonatomic, readwrite, assign) NSUInteger ID;
@property (nonatomic, readwrite, copy) NSString *name;
@end

@implementation User
@synthesize ID;
@synthesize name;

@end
