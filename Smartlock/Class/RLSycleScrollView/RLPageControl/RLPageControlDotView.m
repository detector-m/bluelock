//
//  RLPageControlDotView.m
//  Smartlock
//
//  Created by RivenL on 15/4/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLPageControlDotView.h"

@implementation RLPageControlDotView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initialization];
    }
    
    return self;
}

- (void)initialization {
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.layer.borderWidth  = 2;
}

- (void)changeActivityState:(BOOL)active {
    if (active) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
