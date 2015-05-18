//
//  MainVC.m
//  Smartlock
//
//  Created by RivenL on 15/3/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MainVC.h"
#import "ScanningQRCodeVC.h"

#import "LockDevicesVC.h"
#import "SendKeyVC.h"
#import "ProfileVC.h"
#import "NotificationMessageVC.h"
#import "MoreVC.h"

#if 0
#import "RLCycleScrollView.h"
#import "RLScrollItem.h"
#endif

#import "RLColor.h"
#import "SoundManager.h"

#import "DeviceManager.h"

@interface MainVC () <UIWebViewDelegate> //<RLCycleScrollViewDelegate>

#pragma mark -
@property (nonatomic, strong) NSString *bannersUrl;
@property (nonatomic, strong) UIWebView *bannersView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *openLockBtn;
@property (nonatomic, strong) UIButton *cupidBtn;
@property (nonatomic, strong) UIImageView *arrow;

@property (nonatomic, strong) UIButton *myDeviceBtn;
@property (nonatomic, strong) UIButton *sendKeyBtn;
@property (nonatomic, strong) UIButton *profileBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UILabel *messageBadgeLabel;

#pragma mark -
@property (nonatomic, strong) NSMutableArray *lockList;

@end

@implementation MainVC

- (void)dealloc {
    [self.lockList removeAllObjects], self.lockList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannersView stopLoading];
    self.bannersView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"yongjiakeji", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageComming) name:@"MessageComming" object:nil];
    
    [self setupBLCentralManaer];

    [[SoundManager sharedManager] prepareToPlay];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self setupBackground];
    [self setupBanners];
    [self setupMainView];
    
    [self setupLockList];
}

- (void)setupBLCentralManaer {
    self.manager = [RLBluetooth sharedBluetooth];//[RLCentralManager new];
}

- (void)setupBackground {
    self.backgroundImage.image = [UIImage imageNamed:@"MainBackground.jpeg"];
//    self.view.backgroundColor = [RLColor colorWithHex:/*0x167CB0*/0x253640];//0xF2DF9B];
}

- (void)setupLockList {
    if(!self.lockList) {
        self.lockList = [NSMutableArray new];
    }
    [self loadLockList];
}

static CGFloat BannerViewHeight = 120.0f;
static const NSString *kBannersURLString = @"http://www.dqcc.com.cn:7080/mobile/advice.jsp";
- (void)loadBannersRequest {
    [self.bannersView loadRequest:[self requestForBanners:self.bannersUrl]];
}

- (NSURLRequest *)requestForBanners:(NSString *)aUrl {
    DLog(@"%@", aUrl);
    NSURL *newsUrl = [NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:newsUrl];
    return request;
}

- (void)setupBanners {
#if 0
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
    
    CGFloat w = self.view.bounds.size.width;
    RLCycleScrollView *cycleScrollView = [[RLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, w, BannerViewHeight)];
    cycleScrollView.items = images;
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
#else
    CGFloat ratio = (3.0/1.0);
    self.bannersUrl = (NSString *)kBannersURLString;
    CGRect frame = self.view.frame;
    BannerViewHeight = frame.size.width/ratio;
    self.bannersView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, BannerViewHeight)];
    self.bannersView.delegate = self;
    self.bannersView.scrollView.bounces = NO;
    [self.view addSubview:self.bannersView];
    [self loadBannersRequest];
#endif
}

- (void)setupMainView {
    if(!self.scrollView) {
        CGRect frame = self.view.frame;
        CGFloat heightOffset = BannerViewHeight;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightOffset, frame.size.width, frame.size.height-heightOffset)];
        self.scrollView.contentSize = CGSizeMake(frame.size.width, self.scrollView.frame.size.width);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.panGestureRecognizer.delaysTouchesBegan = YES;
        [self.view addSubview:self.scrollView];
        
        /**************** central button ***************/
        frame = self.scrollView.frame;
        
        self.cupidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cupidBtn.frame = CGRectMake(frame.size.width/2+60, 20, 80, 80);
        [self.cupidBtn setImage:[UIImage imageNamed:@"Cupid.png"] forState:UIControlStateNormal];
        [self.scrollView addSubview:self.cupidBtn];
        
        frame = self.cupidBtn.frame;
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+3, frame.origin.y+46, frame.size.width/2, frame.size.height/2)];
        self.arrow.image = [UIImage imageNamed:@"Arrow.png"];
        [self.scrollView addSubview:self.arrow];
        
        frame = self.scrollView.frame;
        heightOffset = self.cupidBtn.frame.origin.y + self.cupidBtn.frame.size.height;
        
        self.openLockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.openLockBtn.frame = CGRectMake(frame.size.width/2-120, heightOffset-7, 160, 160);
        [self.openLockBtn setImage:[UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
        [self.openLockBtn setImage:[UIImage imageNamed:@"Unlock.png"] forState:UIControlStateSelected];
        [self.openLockBtn addTarget:self action:@selector(clickOpenLockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.openLockBtn];
        [self.scrollView bringSubviewToFront:self.arrow];
        
        heightOffset += self.openLockBtn.frame.size.height + 30;
        CGFloat btnWidth = (frame.size.width - 2*(15+5))/3;
        CGFloat btnWidthOffset = 15;
        CGFloat btnHeight = 40;
        self.myDeviceBtn = [self buttonWithTitle:NSLocalizedString(@"我的设备", nil) selector:@selector(clickMyDeviceBtn:) frame:CGRectMake(btnWidthOffset, heightOffset, btnWidth, btnHeight)];
        [self.scrollView addSubview:self.myDeviceBtn];
        
        btnWidthOffset += 5+btnWidth;
        self.sendKeyBtn = [self buttonWithTitle:NSLocalizedString(@"发送钥匙", nil) selector:@selector(clickSendKeyBtn:) frame:CGRectMake(btnWidthOffset, heightOffset, btnWidth, btnHeight)];
        [self.scrollView addSubview:self.sendKeyBtn];
        
        btnWidthOffset += 5+btnWidth;
        self.profileBtn = [self buttonWithTitle:NSLocalizedString(@"我的资料", nil) selector:@selector(clickProfileBtn:) frame:CGRectMake(btnWidthOffset, heightOffset, btnWidth, btnHeight)];
        [self.scrollView addSubview:self.profileBtn];
        
        heightOffset += btnHeight + 5;
        btnWidthOffset = 15;
        self.buyBtn = [self buttonWithTitle:NSLocalizedString(@"购买", nil) selector:@selector(clickBuyBtn:) frame:CGRectMake(btnWidthOffset, heightOffset, btnWidth, btnHeight)];
        [self.scrollView addSubview:self.buyBtn];
    
        btnWidthOffset += 5+btnWidth;
        self.messageBtn = [self buttonWithTitle:NSLocalizedString(@"消息", nil) selector:@selector(clickMessageBtn:) frame:CGRectMake(btnWidthOffset, heightOffset, btnWidth, btnHeight)];
        [self.scrollView addSubview:self.messageBtn];
        
        self.messageBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.messageBtn.frame.size.width-20-2, 2, 20, 20)];
        self.messageBadgeLabel.backgroundColor = [UIColor redColor];
        self.messageBadgeLabel.textColor = [UIColor whiteColor];
        
        self.messageBadgeLabel.textAlignment = NSTextAlignmentCenter;
        self.messageBadgeLabel.font = [UIFont systemFontOfSize:11];
        self.messageBadgeLabel.layer.cornerRadius = 10;
        self.messageBadgeLabel.clipsToBounds = YES;
//        self.messageBadgeLabel.text = @"1";
        self.messageBadgeNumber = 0;
        [self.messageBtn addSubview:self.messageBadgeLabel];
        
        btnWidthOffset += 5+btnWidth;
        self.moreBtn = [self buttonWithTitle:NSLocalizedString(@"更多", nil) selector:@selector(clickMoreBtn:) frame:CGRectMake(btnWidthOffset, heightOffset, btnWidth, btnHeight)];
        [self.scrollView addSubview:self.moreBtn];
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title selector:(SEL)selector frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [RLColor colorWithHex:0x81D4EA];//[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.5];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[RLColor colorWithHex:0x000000 alpha:0.8]/*[RLColor colorWithHex:0xF2E9AE alpha:0.9]*/ forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)loadLockList {
    [DeviceManager lockList:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        if(error) {
            return ;
        }
        if(response.status) {
            return;
        }
        if(!response.list.count) {
            return;
        }
        
        [self.lockList addObjectsFromArray:response.list];
        
    }];
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
    
//    [DeviceManager keyListOfAdmin:11 token:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
//        DLog(@"");
//    }];
    
}

- (void)clickOpenLockBtn:(UIButton *)button {
    
    if(!self.lockList.count)
        return;
    
    self.openLockBtn.userInteractionEnabled = NO;
    __weak __typeof(self)weakSelf = self;
    
    [[RLBluetooth sharedBluetooth] scanBLPeripheralsWithCompletionBlock:^(NSArray *peripherals) {
        if(!peripherals.count) {
            weakSelf.openLockBtn.userInteractionEnabled = YES;
            return ;
        }
        
        for(RLPeripheral *peripheral in peripherals) {
            for(LockModel *lock in self.lockList) {
                if([peripheral.name isEqualToString:lock.name]) {
                    [[RLBluetooth sharedBluetooth] connectPeripheral:peripheral withConnectedBlock:^{
                        weakSelf.openLockBtn.userInteractionEnabled = YES;
                        for(RLService *service in peripheral.services) {
                            if([service.UUIDString isEqualToString:@"1910"]) {
                                for(RLCharacteristic *characteristic in service.characteristics) {
                                    if(characteristic.cbCharacteristic.properties == CBCharacteristicPropertyNotify) {
                                        
                                        [characteristic setNotifyValue:YES completion:^(NSError *error) {
                                            for(RLCharacteristic *characteristic in service.characteristics) {
                                                if([characteristic.UUIDString isEqualToString:@"fff2"]) {
                                                    [weakSelf writeDataToCharacteristic:characteristic withData:453289921600ll];//lock.pwd];
                                                    
                                                    return ;
                                                }
                                            }
                                        } onUpdate:^(NSData *data, NSError *error) {
                                            BL_response cmdResponse = responseWithBytes(( Byte *)[data bytes], data.length);
                                            Byte crc = CRCOfCMDBytes((Byte *)[data bytes], data.length);
                                            
                                            if(crc == cmdResponse.CRC && cmdResponse.result.result == 0) {
//                                                crc++;
                                                [weakSelf openLock:nil];
                                            }
                                        }];
                                    }
                                }
                            }
                        }
                    }];
                    
                    return;
                }
            }
        }
    }];
}

- (void)startOpenLockAnimation:(UIButton *)button {
    [[SoundManager sharedManager] playSound:@"SoundOperator.mp3" looping:NO];
    button.userInteractionEnabled = NO;
    CGRect orignalFrame = self.arrow.frame;
    [UIView animateKeyframesWithDuration:1.0f delay:0.0f options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = self.arrow.frame;
        frame.origin = button.center;//CGPointMake(self.openLockBtn.frame.origin.x, self.openLockBtn.frame.origin.y);
        frame.origin.x += 10;
        frame.origin.y -= 22;
        self.arrow.frame = frame;
    } completion:^(BOOL finished) {
        if(finished) {
            self.arrow.frame = orignalFrame;
            self.arrow.hidden = YES;
            button.userInteractionEnabled = YES;
            button.selected = !button.selected;
        }
    }];
}
/*
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
*/

- (void)clickMyDeviceBtn:(UIButton *)button {
    LockDevicesVC *vc = [LockDevicesVC new];
//    vc.manager = self.manager.manager;
    [vc.table addObjectFromArray:self.lockList];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSendKeyBtn:(UIButton *)button {
    SendKeyVC *vc = [[SendKeyVC alloc] init];
    vc.title = NSLocalizedString(@"发送钥匙", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickProfileBtn:(UIButton *)button {
    ProfileVC *vc = [[ProfileVC alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBuyBtn:(UIButton *)button {
    
}

- (void)clickMessageBtn:(UIButton *)button {
    self.messageBadgeNumber = 0;
    NotificationMessageVC *vc = [[NotificationMessageVC alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickMoreBtn:(UIButton *)button {
    MoreVC *vc = [MoreVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 
- (void)messageComming {
    self.messageBadgeNumber ++;
}

#pragma mark - public methods
#pragma mark -
- (void)addLock:(LockModel *)lock {
    if(!lock)
        return;
    [self.lockList addObject:lock];
}

- (void)setMessageBadgeNumber:(NSInteger)messageBadgeNumber {
    if(messageBadgeNumber == 0) {
        self.messageBadgeLabel.hidden = YES;
        
        return;
    }
    
    self.messageBadgeLabel.hidden = NO;
    _messageBadgeNumber = messageBadgeNumber;
    self.messageBadgeLabel.text = [NSString stringWithFormat:@"%i", messageBadgeNumber];
}

#pragma mark - private methods
- (void)openLock:(LockModel *)lock {
    [self performSelectorOnMainThread:@selector(startOpenLockAnimation:) withObject:self.openLockBtn waitUntilDone:YES];
}

- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic withData:(long long)data {
    int size = sizeof(data)+6;
    Byte *tempData = calloc(size, sizeof(Byte));
    tempData[0] = 0xff;
    for(NSInteger j=1; j<6; j++) {
        tempData[j] = 0x0a;
    }
    Byte *temp = (Byte *)&data;
    for(NSInteger j = 6; j<size; j++) {
        tempData[j] = temp[j-6];
    }
    
    NSData *writeData = [NSData dataWithBytes:tempData length:size];
    free(tempData);
    [[RLBluetooth sharedBluetooth] writeDataToCharacteristic:characteristic cmdCode:0x02 cmdMode:0x00 withDatas:writeData];
}
#pragma mark -
#if 0
- (void)cycleScrollView:(RLCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

}
#endif

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [RLHUD hudProgressWithBody:nil onView:webView timeout:5.0f];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [RLHUD hideProgress];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"error=%@", error);
    [RLHUD hideProgress];
}
@end
