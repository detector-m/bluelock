//
//  ModifierVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/12.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModifierVC.h"

@interface ModifierVC ()
@property (nonatomic, strong) RLTitleTextField *textField;
@end
@implementation ModifierVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    CGFloat widthOffset = 20;
    CGFloat heightOffset = 20;
    
    self.textField = [[RLTitleTextField alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 40)];
//    self.textField.textField.secureTextEntry = YES;
    [self.textField setStyle:kRLTitleTextFieldHorizontal];
    self.textField.title.text = self.title;//NSLocalizedString(@"", nil);
    self.textField.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.textField.textField.layer.borderWidth = 0.5f;
    [self.view addSubview:self.textField];
    
    [self setupRightItem];
    
    NSString *titleString = NSLocalizedString(@"修改", nil);
    self.title = [titleString stringByAppendingString:self.title];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightItem)];
}

- (void)clickRightItem {
    
}
@end
