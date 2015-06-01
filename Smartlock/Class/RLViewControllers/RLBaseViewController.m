//
//  RLBaseViewController.m
//  Smartlock
//
//  Created by RivenL on 15/3/11.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"
#import "UIViewController+Expand.h"

@interface RLBaseViewController ()

@end

@implementation RLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupForDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
