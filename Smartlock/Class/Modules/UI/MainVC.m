//
//  MainVC.m
//  Smartlock
//
//  Created by RivenL on 15/3/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MainVC.h"
#import "LockDevicesVC.h"
#import "ScanningQRCodeVC.h"

#import "RLColor.h"
#import "SoundManager.h"

@interface MainVC ()
//@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIButton *openLockBtn;

@property (nonatomic, strong) UIImageView *circleView;
@end

@implementation MainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"yongjiakeji", nil);
    
//    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
//    [SoundManager sharedManager].soundVolume = 10;
    
    /**************** right item ***************/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickRightItem:)];
    
    CGRect frame = self.view.frame;
    
    /**************** bg ***************/
    self.backgroundImage.image = [UIImage imageNamed:@"MainBackground.png"];
    
    /**************** central button ***************/
    self.openLockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openLockBtn.frame = CGRectMake(frame.size.width/2-80, 100, 160, 160);
    [self.openLockBtn setImage:[UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
    [self.openLockBtn setImage:[UIImage imageNamed:@"Unlock.png"] forState:UIControlStateSelected];
    [self.openLockBtn addTarget:self action:@selector(clickOpenLockBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openLockBtn];
    
    self.circleView = [[UIImageView alloc] initWithFrame:self.openLockBtn.frame];
    self.circleView.image = [UIImage imageNamed:@"Circle.png"];
    self.circleView.hidden = YES;
    [self.view addSubview:self.circleView];
}

- (void)clickRightItem:(UIBarButtonItem *)item {
    LockDevicesVC *vc = [LockDevicesVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickOpenLockBtn:(UIButton *)button {
    button.userInteractionEnabled = NO;
    [self performSelectorOnMainThread:@selector(rotateCircle:) withObject:button waitUntilDone:YES];
}

- (void)rotateCircle:(UIButton *)button {
    self.circleView.hidden = !self.circleView.hidden;

    [[SoundManager sharedManager] playSound:@"SoundOperator.mp3" looping:NO];
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(M_PI);
    [UIView animateWithDuration:1.5f delay:0.0f options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.circleView.transform = endAngle;
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            CGAffineTransform beginAngle = CGAffineTransformMakeRotation(0);
            
            self.circleView.transform = beginAngle;
            self.circleView.hidden = YES;
            button.selected = !button.selected;
            button.userInteractionEnabled = YES;
        }
    }];
}
@end
