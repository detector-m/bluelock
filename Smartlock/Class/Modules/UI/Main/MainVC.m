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
#import "BuyVC.h"
#import "NotificationMessageVC.h"
#import "MoreVC.h"

#pragma mark -
#import "Message.h"
#import "RecordManager.h"
#import "KeyEntity.h"

#pragma mark -
#import "XMPPManager.h"

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

#pragma mark -
@property (assign) BOOL isBannersLoaded;
@property (assign) BOOL isBannersLoading;
@end

@implementation MainVC

- (void)dealloc {
    [self.lockList removeAllObjects], self.lockList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.messageBadgeNumber = [[MyCoreDataManager sharedManager] objectsCountWithKey:@"isRead" contains:@NO withTablename:NSStringFromClass([Message class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.bannersView stopLoading];
    self.bannersView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"yongjiakeji", nil);
    
    [self setupBLCentralManaer];

    [[SoundManager sharedManager] prepareToPlay];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self setupBackground];
    [self setupBanners];
    [self setupMainView];
    
    [self setupLockList];
    
    [self setupNotification];
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

- (void)setupNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applictionWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage) name:(NSString *)kReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachable:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

//- (void)applictionWillEnterForeground:(id)sender {
//    if(![AFNetworkReachabilityManager sharedManager].isReachable)
//        return;
//
//    [RecordManager updateRecordsWithBlock:^(BOOL success) {
//        [self loadLockList];
//    }];
//}

#pragma mark ----------- network status changed
- (void)networkReachable:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *dic = notification.userInfo;
    NSInteger status = [[dic objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if(status > 0) {
        [self loadBannersRequest];
        
        [self loadLockListForNet];
        [RecordManager updateRecordsWithBlock:^(BOOL success) {
            [self loadLockListForNet];
        }];
    }
    else {
        [self.bannersView stopLoading];
    }
}

static CGFloat BannerViewHeight = 120.0f;
static const NSString *kBannersURLString = @"http://www.dqcc.com.cn:7080/mobile/advice.jsp";
- (void)loadBannersRequest {
    if(!self.isBannersLoaded && !self.isBannersLoading) {
        [self.bannersView loadRequest:[self requestForBanners:self.bannersUrl]];
    }
}

- (NSURLRequest *)requestForBanners:(NSString *)aUrl {
    DLog(@"%@", aUrl);
    NSURL *newsUrl = [NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:newsUrl];
    return request;
}

- (void)setupBanners {
    CGFloat ratio = (3.0/1.0);
    self.bannersUrl = (NSString *)kBannersURLString;
    CGRect frame = self.view.frame;
    BannerViewHeight = frame.size.width/ratio;
    self.bannersView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, BannerViewHeight)];
    self.bannersView.delegate = self;
    self.bannersView.scrollView.bounces = NO;
    [self.view addSubview:self.bannersView];
    [self loadBannersRequest];
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
    __weak __typeof(self)weakSelf = self;
    [weakSelf.lockList removeAllObjects];
    NSArray *array = [[MyCoreDataManager sharedManager] objectsSortByAttribute:nil withTablename:NSStringFromClass([KeyEntity class])];
    for(KeyEntity *key in array) {
        [weakSelf.lockList addObject:[[KeyModel alloc] initWithKeyEntity:key]];
    }
    [self loadLockListForNet];
}

- (void)loadLockListForNet {
    __weak __typeof(self)weakSelf = self;
    [DeviceManager lockList:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        if(!response.list.count) {
            return;
        }
        
        [weakSelf.lockList removeAllObjects];
        [weakSelf.lockList addObjectsFromArray:response.list];
        for(KeyModel *key in weakSelf.lockList) {
            [[MyCoreDataManager sharedManager] insertUpdateObjectInObjectTable:keyEntityDictionaryFromKeyModel(key) updateOnExistKey:@"keyID" withTablename:NSStringFromClass([KeyEntity class])];
        }
        
    }];

}

- (void)clickOpenLockBtn:(UIButton *)button {
    
    if(!self.lockList.count)
        return;
    
    self.openLockBtn.userInteractionEnabled = NO;
    __weak __typeof(self)weakSelf = self;
    
    [[RLBluetooth sharedBluetooth] scanBLPeripheralsWithCompletionBlock:^(NSArray *peripherals) {
        if(peripherals == nil) {
            weakSelf.openLockBtn.userInteractionEnabled = YES;
            return ;
        }
        
        if(!peripherals.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"未找到设备,请检查蓝牙设备", nil)];
            });
            weakSelf.openLockBtn.userInteractionEnabled = YES;
            return ;
        }
        
        for(RLPeripheral *peripheral in peripherals) {
            for(KeyModel *key in self.lockList) {
                if(![key isValid]) {
                    continue;
                }
                if([peripheral.name isEqualToString:key.keyOwner.address]) {
                    [[RLBluetooth sharedBluetooth] connectPeripheral:peripheral withConnectedBlock:^{
                        weakSelf.openLockBtn.userInteractionEnabled = YES;
                        for(RLService *service in peripheral.services) {
                            if([service.UUIDString isEqualToString:@"1910"]) {
                                for(RLCharacteristic *characteristic in service.characteristics) {
                                    if(characteristic.cbCharacteristic.properties == CBCharacteristicPropertyNotify) {
                                        
                                        [characteristic setNotifyValue:YES completion:^(NSError *error) {
                                            for(RLCharacteristic *characteristic in service.characteristics) {
                                                if([characteristic.UUIDString isEqualToString:@"fff2"]) {
                                                    [weakSelf writeDataToCharacteristic:characteristic withKey:key];//lock.pwd];
                                                    
                                                    return ;
                                                }
                                            }
                                        } onUpdate:^(NSData *data, NSError *error) {
                                            BL_response cmdResponse = responseWithBytes(( Byte *)[data bytes], data.length);
                                            Byte crc = CRCOfCMDBytes((Byte *)[data bytes], data.length);
                                            
                                            if(crc == cmdResponse.CRC && cmdResponse.result.result == 0) {
                                                [weakSelf openLock:key];
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"没有可用的钥匙", nil)];
            weakSelf.openLockBtn.userInteractionEnabled = YES;
        });
    }];
}

- (void)startOpenLockAnimation:(UIButton *)button {
    [[SoundManager sharedManager] playSound:@"SoundOperator.mp3" looping:NO];
    button.userInteractionEnabled = NO;
    CGRect orignalFrame = self.arrow.frame;
    __weak __typeof(self)weakSelf = self;
    [UIView animateKeyframesWithDuration:1.0f delay:0.0f options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = self.arrow.frame;
        frame.origin = button.center;//CGPointMake(self.openLockBtn.frame.origin.x, self.openLockBtn.frame.origin.y);
        frame.origin.x += 10;
        frame.origin.y -= 22;
        weakSelf.arrow.frame = frame;
    } completion:^(BOOL finished) {
        if(finished) {
            weakSelf.arrow.frame = orignalFrame;
            weakSelf.arrow.hidden = NO;
            weakSelf.arrow.alpha = 0.0;
            button.selected = !button.selected;
            
            [UIView animateKeyframesWithDuration:2.0f delay:5.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                weakSelf.arrow.alpha = 0.95;
            } completion:^(BOOL finished) {
                weakSelf.arrow.alpha = 1.0;
                button.userInteractionEnabled = YES;
                button.selected = !button.selected;
            }];
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
    vc.mainVC = self;
//    vc.manager = self.manager.manager;
    [vc.table addObjectFromArray:self.lockList];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSendKeyBtn:(UIButton *)button {
    BOOL isAdmin = NO;
    for(KeyModel *key in self.lockList) {
        if(key.userType == 0) {
            isAdmin = YES;
            break;
        }
    }
    
    if(!isAdmin) {
        [RLHUD hudAlertWarningWithBody:NSLocalizedString(@"你并非管理员！", nil)];
        return;
    }
    SendKeyVC *vc = [[SendKeyVC alloc] init];
    vc.title = NSLocalizedString(@"发送钥匙", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickProfileBtn:(UIButton *)button {
    ProfileVC *vc = [[ProfileVC alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBuyBtn:(UIButton *)button {
    BuyVC *vc = [[BuyVC alloc] init];
    vc.title = NSLocalizedString(@"购买", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickMessageBtn:(UIButton *)button {
    [[MyCoreDataManager sharedManager] updateObjectsInObjectTable:@{@"isRead" : @YES} withKey:@"isRead" contains:@NO withTablename:NSStringFromClass([Message class])];

    self.messageBadgeNumber = 0;

    NotificationMessageVC *vc = [[NotificationMessageVC alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickMoreBtn:(UIButton *)button {
    MoreVC *vc = [MoreVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 
- (void)receiveMessage {
    self.messageBadgeNumber ++;
    [self loadLockListForNet];
}

#pragma mark - public methods
#pragma mark -
- (void)addKey:(KeyModel *)key {
    if(!key )
        return;
    [self.lockList addObject:key ];
}

- (void)removeKey:(KeyModel *)key {
    if(!key)
        return;
    [self.lockList removeObject:key];
}

- (void)setMessageBadgeNumber:(NSInteger)messageBadgeNumber {
    if(messageBadgeNumber == 0) {
        self.messageBadgeLabel.hidden = YES;
        
        return;
    }
    
    self.messageBadgeLabel.hidden = NO;
    _messageBadgeNumber = messageBadgeNumber;
    self.messageBadgeLabel.text = [NSString stringWithFormat:@"%li", (long)messageBadgeNumber];
}

#pragma mark - private methods
- (void)openLock:(KeyModel *)key {
    [self performSelectorOnMainThread:@selector(startOpenLockAnimation:) withObject:self.openLockBtn waitUntilDone:YES];
    if(key.type == kKeyTypeTimes) {
        if(key.validCount > 0) {
            --key.validCount;
            
            [[MyCoreDataManager sharedManager] updateObjectsInObjectTable:@{@"useCount":[NSNumber numberWithInteger:key.validCount]} withKey:@"keyID" contains:[NSNumber numberWithInteger:key.ID] withTablename:NSStringFromClass([KeyEntity class])];
        }
    }
    NSDictionary *record = createOpenLockRecord(key.ID, key.lockID);
    [[MyCoreDataManager sharedManager] insertObjectInObjectTable:record withTablename:NSStringFromClass([OpenLockRecord class])];
    [DeviceManager openLock:openLockRecordToString(record) token:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        [[MyCoreDataManager sharedManager] updateObjectsInObjectTable:record withKey:@"keyID" contains:[NSNumber numberWithLongLong:key.ID] withTablename:NSStringFromClass([OpenLockRecord class])];
    }];
}

- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic withKey:(KeyModel *)key {
    int len = 0;
    long long data = key.keyOwner.pwd;
    Byte *dateData = dateToBytes(&len, key.invalidDate.length? key.invalidDate: @"2015-12-18");
    int size = sizeof(data)+len;
    Byte *tempData = calloc(size, sizeof(Byte));
    memcpy(tempData, dateData, len);
    
    Byte *temp = (Byte *)&(data);
    for(NSInteger j = len; j<size; j++) {
        tempData[j] = temp[j-len];
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
    self.isBannersLoaded = NO;
    self.isBannersLoading = YES;
    [RLHUD hudProgressWithBody:nil onView:webView timeout:5.0f];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.isBannersLoaded = YES;
    self.isBannersLoading = NO;
    [RLHUD hideProgress];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"error=%@", error);
    self.isBannersLoaded = NO;
    self.isBannersLoading = NO;
    [RLHUD hideProgress];
}
@end
