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

#import "RLCycleScrollView.h"
#import "RLScrollItem.h"

#import "RLColor.h"
#import "SoundManager.h"

#import "DeviceManager.h"

@interface MainVC () <RLCycleScrollViewDelegate>
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
    
    CGFloat heightOffset = 0;
    [self setupBanners];
    
    heightOffset += 120+30;
    /**************** central button ***************/
    self.openLockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openLockBtn.frame = CGRectMake(frame.size.width/2-80, heightOffset, 160, 160);
    [self.openLockBtn setImage:[UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
    [self.openLockBtn setImage:[UIImage imageNamed:@"Unlock.png"] forState:UIControlStateSelected];
    [self.openLockBtn addTarget:self action:@selector(clickOpenLockBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openLockBtn];
    
    self.circleView = [[UIImageView alloc] initWithFrame:self.openLockBtn.frame];
    self.circleView.image = [UIImage imageNamed:@"Circle.png"];
    self.circleView.hidden = YES;
    [self.view addSubview:self.circleView];
}

- (void)setupBanners {
    NSMutableArray *images = [NSMutableArray array];
    RLScrollItem *item = [RLScrollItem new];
    item.image = [UIImage imageNamed:@"h1.jpg"];
    [images addObject:item];
    
    item = [RLScrollItem new];
    item.image = [UIImage imageNamed:@"h2.jpg"];
    [images addObject:item];
    
    item = [RLScrollItem new];
    item.image = [UIImage imageNamed:@"h3.jpg"];
    [images addObject:item];
    
    item = [RLScrollItem new];
    item.imageURL = @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg";
    [images addObject:item];
    //    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
    //                        [UIImage imageNamed:@"h2.jpg"],
    //                        [UIImage imageNamed:@"h3.jpg"],
    //                        [UIImage imageNamed:@"h4.jpg"]
    //                        ];
    CGFloat w = self.view.bounds.size.width;
    RLCycleScrollView *cycleScrollView = [[RLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, w, 120)];
    cycleScrollView.items = images;
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
}


- (void)clickRightItem:(UIBarButtonItem *)item {
//    LockDevicesVC *vc = [LockDevicesVC new];
//    [self.navigationController pushViewController:vc animated:YES];
//    LockModel *lock = [[LockModel alloc] init];
//    lock.name = @"1111111";
//    lock.address = @"2222222";
//    lock.token = [User sharedUser].sessionToken;
//    [DeviceManager addBluLock:lock withBlock:^(DeviceResponse *response, NSError *error) {
//        if(error) {
//            DLog(@"%@", error);
//            return ;
//        }
//        if(response.status) {
//        
//        }
//        else {
//            
//        }
//    }];
    
//    KeyModel *key = [KeyModel new];
//    key.lockID = 1;
//    key.ower = @"abc";
//    key.type = 1;
//    key.validCount = 3;
//    key.token = [User sharedUser].sessionToken;
//    [DeviceManager sendKey:key withBlock:^(DeviceResponse *response, NSError *error) {
//        
//    }];
    
//    [DeviceManager lockList:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
//        
//    }];
    
    [DeviceManager keyListOfAdmin:11 token:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        DLog(@"");
    }];
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

#pragma mark -
- (void)cycleScrollView:(RLCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

}
@end
