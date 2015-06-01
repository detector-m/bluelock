//
//  LoginVC.m
//  Smartlock
//
//  Created by RivenL on 15/3/31.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "LoginVC.h"
#import "RLColor.h"
#import "UIViewController+Expand.h"
#import "RLImageTextField.h"

#import "MainVC.h"
#import "AuthCodeVC.h"

#import "RLHTTPAPIClient.h"

#pragma mark -
#import "XMPPManager.h"

#define LoginBackgroundColor (0x0F6797)
#define ButtonBackgroundColor (0x399ACA)

@interface LoginVC ()
@property (nonatomic, strong) UIImageView *loginIcon;

@property (nonatomic, strong) RLImageTextField *account;
@property (nonatomic, strong) RLImageTextField *password;

@property (nonatomic, strong) UIButton *forgetPWButton;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UILabel *registerLabel;
@property (nonatomic, strong) UIButton *registerButton;
@end

@implementation LoginVC
- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"永家科技", nil);
    [self.backgroundImage removeFromSuperview];
    [self setupForDismissKeyboard];
    
    self.view.backgroundColor = [RLColor colorWithHex:LoginBackgroundColor];
    
    CGRect frame = self.view.frame;
    self.loginIcon = [UIImageView new];
    self.loginIcon.frame = CGRectMake(frame.size.width/2-75, 5, 130, 130);
    self.loginIcon.image = [UIImage imageNamed:@"LoginIcon.png"];
    [self.view addSubview:self.loginIcon];
    
    CGFloat heightOffset = self.loginIcon.frame.size.height + self.loginIcon.frame.origin.y + 5;
    CGFloat widthOffset = 20;
    self.account = [[RLImageTextField alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 35)];
    self.account.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.account.icon.image = [UIImage imageNamed:@"Account"];
    self.account.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.account.layer.borderWidth = 0.5f;
    [self.view addSubview:self.account];
    
    heightOffset += self.account.frame.size.height;
    self.password = [[RLImageTextField alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 35)];
    self.password.textField.secureTextEntry = YES;
    self.password.icon.image = [UIImage imageNamed:@"Password"];
    self.password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.password.layer.borderWidth = 0.5f;
    [self.view addSubview:self.password];
    
    heightOffset += self.password.frame.size.height + 5;
    widthOffset = (frame.size.width-100-widthOffset);
    self.forgetPWButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPWButton.frame = CGRectMake(widthOffset, heightOffset, 100, 30);
    [self.forgetPWButton setTitle:NSLocalizedString(@"Forget PW?", nil) forState:UIControlStateNormal];
    [self.forgetPWButton addTarget:self action:@selector(clickedForgetPWButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPWButton];
    
    heightOffset += self.forgetPWButton.frame.size.height+3;
    widthOffset = 40;
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(widthOffset, heightOffset, frame.size.width-widthOffset*2, 35);
    [self.loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(clickedLoginButton) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [RLColor colorWithHex:ButtonBackgroundColor];
    self.loginButton.layer.cornerRadius = 6;
    [self.view addSubview:self.loginButton];
    
    heightOffset += self.loginButton.frame.size.height + 50;
    self.registerLabel = [UILabel new];
    self.registerLabel.frame = CGRectMake(frame.size.width/2-100, heightOffset, 200, 30);
    self.registerLabel.textAlignment = NSTextAlignmentCenter;
    self.registerLabel.textColor = [UIColor whiteColor];
    self.registerLabel.text = NSLocalizedString(@"当前没有账号？", nil);
    [self.view addSubview:self.registerLabel];
    
    heightOffset += self.registerLabel.frame.size.height + 1;
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.frame = CGRectMake(frame.size.width/2-65, heightOffset, 130, 35);
    [self.registerButton setTitle:NSLocalizedString(@"注    册", nil) forState:UIControlStateNormal];
    self.registerButton.backgroundColor = [RLColor colorWithHex:ButtonBackgroundColor];
    self.registerButton.layer.cornerRadius = 6;
    [self.registerButton addTarget:self action:@selector(clickedRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}

- (void)clickedForgetPWButton {
    AuthCodeVC *vc = [AuthCodeVC new];
    vc.type = kForgetPSW;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedLoginButton {
    [self.view endEditing:YES];
    self.navigationItem.backBarButtonItem = nil;
    if(![self.account.textField.text isMobile]) {
        [RLHUD hudAlertWarningWithBody:NSLocalizedString(@"账号输入有误！", nil)];
        return;
    }
    
    if(self.password.textField.text.length == 0) {
        [RLHUD hudAlertWarningWithBody:NSLocalizedString(@"密码为空！", nil)];
        return;
    }
    
    LoginModel *login = [[LoginModel alloc] init];
    login.account = self.account.textField.text;
    login.password = self.password.textField.text;
    login.location = [RLLocationManager sharedLocationManager].curLoction;
    login.deviceToken = [User sharedUser].deviceToken;
    if(!login.deviceToken) {
        [RLHUD hudAlertWarningWithBody:NSLocalizedString(@"请查看网络！", nil)];
        return;
    }
    if(!login.location.city || login.location.city.length == 0) {
        [RLHUD hudAlertNoticeWithBody:NSLocalizedString(@"请过5－10s后再试！", nil)];

        return;
    }

    [Login login:login withBlock:^(LoginResponse *response, NSError *error) {
        [RLHUD hideProgress];
        if(response.success) {
            [User sharedUser].password = login.password;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![[XMPPManager sharedXMPPManager] connect]) {
                    [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"登录失败", nil)];
                    return ;
                }
                
                [Login login];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"用户名或密码错误！", nil)];

            });
        }
    }];
    [RLHUD hudProgressWithBody:NSLocalizedString(@"加载中。。。", nil) onView:self.view timeout:100.0f];
}

- (void)clickedRegisterButton {
    AuthCodeVC *vc = [AuthCodeVC new];
    vc.type = kRegister;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
