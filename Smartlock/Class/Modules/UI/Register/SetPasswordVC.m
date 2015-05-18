//
//  SetPasswordVC.m
//  Smartlock
//
//  Created by RivenL on 15/4/1.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SetPasswordVC.h"
#import "MainVC.h"
#import "UIViewController+Expand.h"
#import "RLColor.h"
#import "RLTitleTextField.h"

#import "Register.h"

#pragma mark -
#import "XMPPManager.h" 

#define ButtonBackgroundColor (0xcccccc)

@interface SetPasswordVC ()
@property (nonatomic, strong) RLTitleTextField *password;
@property (nonatomic, strong) RLTitleTextField *pswCheck;

@property (nonatomic, strong) UIButton *commiteButton;
@end

@implementation SetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"设置密码", nil);
    [self setupForDismissKeyboard];
    
    CGRect frame = self.view.frame;
    CGFloat widthOffset = 20;
    CGFloat heightOffset = 20;
    self.password = [[RLTitleTextField alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 60)];
    self.password.textField.secureTextEntry = YES;
    [self.password setStyle:kRLTitleTextFieldVertical];
    self.password.title.text = NSLocalizedString(@"请输入密码", nil);
    self.password.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.password.textField.layer.borderWidth = 0.5f;
    [self.view addSubview:self.password];
    
    heightOffset += self.password.frame.size.height;
    self.pswCheck = [[RLTitleTextField alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 60)];
    self.pswCheck.textField.secureTextEntry = YES;
    [self.pswCheck setStyle:kRLTitleTextFieldVertical];
    self.pswCheck.title.text = NSLocalizedString(@"确认密码", nil);
    self.pswCheck.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pswCheck.textField.layer.borderWidth = 0.5f;
    [self.view addSubview:self.pswCheck];
    
    heightOffset += self.pswCheck.frame.size.height + 20;
    self.commiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commiteButton.frame = CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 30);
    self.commiteButton.backgroundColor = [RLColor colorWithHex:ButtonBackgroundColor];
    [self.commiteButton setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
    [self.commiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.commiteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commiteButton.layer.borderWidth = 0.5f;
    self.commiteButton.layer.cornerRadius = 6;
    [self.commiteButton addTarget:self action:@selector(clickedCommiteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commiteButton];
}

- (void)clickedCommiteButton {
    if(self.password.textField.text.length == 0 || self.pswCheck.textField.text.length == 0 || ![self.password.textField.text isEqualToString:self.pswCheck.textField.text]) {
        [RLHUD hudAlertWithBody:NSLocalizedString(@"密码输入有误！", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
        
        return;
    }
    
    [RLHUD hudProgressWithBody:nil onView:self.view timeout:20.0f];
    if(self.type == kRegister) {
        RegisterModel *aRegister = [[RegisterModel alloc] init];
        aRegister.password = self.password.textField.text;
        [Register register:aRegister withBlock:^(RegisterResponse *response, NSError *error) {
            [RLHUD hideProgress];
            if(error) {
                [RLHUD hudAlertWithBody:NSLocalizedString(@"请检查网络！", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
            }
            
            if(response.status) {
                [RLHUD hudAlertWithBody:NSLocalizedString(@"注册失败！", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
                DLog(@"注册失败");
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [User saveArchiver];
                    if(![[XMPPManager sharedXMPPManager] connect]) {
                        [RLHUD hudAlertWithBody:NSLocalizedString(@"登录失败", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
                        DLog(@"xmpp connect error");
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        return ;
                    }
                    MainVC *vc = [MainVC new];
                    
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
        }];
    }
    else {
        
        self.findPasswordModel.password = self.password.textField.text;
        __weak __typeof(self)weakSelf = self;
        [Register findPassword:self.findPasswordModel withBlock:^(RegisterResponse *response, NSError *error) {
            [RLHUD hideProgress];
            if(error) {
                [RLHUD hudAlertWithBody:NSLocalizedString(@"请检查网络！", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
            }
            
            if(response.status) {
                [RLHUD hudAlertWithBody:NSLocalizedString(@"找回密码失败！", nil) type:MBAlertViewHUDTypeDefault hidesAfter:2.0f show:YES];
                DLog(@"注册失败");
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
    }
}

@end
