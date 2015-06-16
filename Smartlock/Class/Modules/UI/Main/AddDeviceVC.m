//
//  AddDeviceVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/8.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "AddDeviceVC.h"
#import "RLHUD.h"
#import "LockDevicesVC.h"
#import "DeviceManager.h"
#import "MainVC.h"

#import "RLBluetooth.h"

#import "RLDate.h"
#import "RecordManager.h"

@interface AddDeviceVC ()
@property (nonatomic, strong) UILabel *warnLabel;

@property (nonatomic, assign) long long pwd;
@end

@implementation AddDeviceVC
#define WarnLabelHeight (60)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self scanBLPeripherals];
    
    self.title = NSLocalizedString(@"添加设备", nil);
    
    CGRect frame = self.view.frame;//self.table.tableView.frame;
    frame.size.height -= WarnLabelHeight;
    self.table.tableView.rowHeight = 60.0f;
    self.table.tableView.frame = frame;
    
    [self.view addSubview:self.warnLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
}

- (UILabel *)warnLabel {
    if(_warnLabel)
        return _warnLabel;
    
    CGRect frame = self.view.frame;
    CGFloat orignalX = 10;
    CGFloat orignalY = frame.size.height - 60;
    _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(orignalX, orignalY, frame.size.width-orignalX*2, WarnLabelHeight)];
    _warnLabel.textColor = [UIColor blueColor];
    _warnLabel.text = NSLocalizedString(@"注： 添加设备时请点击锁，请勿离设备超过5米或者中间没有物品间隔！", nil);
    _warnLabel.numberOfLines = 0;
    
    return _warnLabel;
}

- (void)scanBLPeripherals {
    __weak __typeof(self)weakSelf = self;
    
    [[RLBluetooth sharedBluetooth] scanBLPeripheralsWithCompletionBlock:^(NSArray *peripherals) {
        [self.table.datas removeAllObjects];
        if(!peripherals.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.table.tableView reloadData];
            });
            return ;
        }
        for(RLPeripheral *peripheral in peripherals) {
            if(peripheral.name.length == 0)
                continue;
            if(![peripheral.name hasPrefix:PeripheralPreStr]) continue;
            [weakSelf.table.datas addObject:peripheral];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.table.tableView reloadData];
        });
    }];
}

- (void)clickRightItem {
    [self scanBLPeripherals];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.table.datas.count;
}

- (NSInteger)indexForData:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    for(NSInteger i=0; i<indexPath.section; i++) {
        index += [self tableView:nil numberOfRowsInSection:i];
    }
    index += indexPath.row;
    return index;
}

- (BOOL)isAddedWithName:(NSString *)name {
    for(KeyModel *key in self.lockDevicesVC.table.datas) {
        if([key.keyOwner.address isEqualToString:name]) {
            return YES;
        }
    }
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[LockCell class] forCellReuseIdentifier:kCellIdentifier];
    LockCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)kCellIdentifier forIndexPath:indexPath];
    NSInteger index = [self indexForData:indexPath];
    RLPeripheral *peripheral = [self.table.datas objectAtIndex:index];
    cell.textLabel.text = peripheral.name;
    cell.imageView.image = [UIImage imageNamed:@"Bluetooth.png"];
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([self isAddedWithName:peripheral.name]) {
        cell.detailTextLabel.text = NSLocalizedString(@"已存在", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.detailTextLabel.text = NSLocalizedString(@"新设备", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexForData:indexPath];
    [self deselectRow];
    if(!self.table.datas.count) return;
    RLPeripheral *peripheral = [self.table.datas objectAtIndex:index];
    [self connectPeripheral:peripheral];
    [RLHUD hudProgressWithBody:NSLocalizedString(@"正在配对...", nil) onView:self.view.superview timeout:6.0f];
}

#pragma mark -
- (void)connectPeripheral:(RLPeripheral *)peripheral {
    if(peripheral == nil)
        return;
    __weak __typeof(self)weakSelf = self;
    [[RLBluetooth sharedBluetooth] connectPeripheral:peripheral withConnectedBlock:^{
        RLService *service = [[RLBluetooth sharedBluetooth] serviceForUUIDString:@"1910" withPeripheral:peripheral];
        RLCharacteristic *characteristic = [[RLBluetooth sharedBluetooth] characteristicForNotifyWithService:service];
        
        [characteristic setNotifyValue:YES completion:^(NSError *error) {
            RLCharacteristic *innerCharacteristic = [[RLBluetooth sharedBluetooth] characteristicForUUIDString:@"fff2" withService:service];
            [weakSelf writeData:innerCharacteristic];
            
        } onUpdate:^(NSData *data, NSError *error) {
            BL_response cmdResponse = responseWithBytes(( Byte *)[data bytes], data.length);
            Byte crc = CRCOfCMDBytes((Byte *)[data bytes], data.length);
            
            if(crc == cmdResponse.CRC && cmdResponse.result.result == 0) {
                LockModel *lock = [LockModel new];
                NSString *subString = [peripheral.name substringWithRange:NSMakeRange(peripheral.name.length-6, 6)];
                NSString *lockName = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"我的智能锁", nil), subString];
                lock.name = lockName;
                lock.address = peripheral.name;
                lock.token = [User sharedUser].sessionToken;
                lock.pwd = weakSelf.pwd;
                
                [DeviceManager addBluLock:lock withBlock:^(DeviceResponse *response, NSError *error) {
                    [RLHUD hideProgress];
                    if(error) return ;
                    if(response.status) {
                        [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"配对失败", nil)];
                        return ;
                    }
                    [RecordManager removeRecordsWithAddress:lock.address];
                    [[weakSelf lockDevicesVC].mainVC loadLockList];
                    [RLHUD hudAlertSuccessWithBody:NSLocalizedString(@"配对成功", nil)];
                }];
            }
            else {
                [RLHUD hideProgress];
                [RLHUD hudAlertErrorWithBody:NSLocalizedString(@"配对失败", nil)];
            }
        }];
    }];
}

- (void)writeData:(RLCharacteristic *)characteristic {
    long long data = timestampSince1970();//[NSDate timeIntervalSinceReferenceDate]*1000;
    self.pwd = data;
    int size = sizeof(data);
    
    NSData *writeData = [NSData dataWithBytes:&data length:size];
    [[RLBluetooth sharedBluetooth] writeDataToCharacteristic:characteristic cmdCode:0x01 cmdMode:0x01 withDatas:writeData];
}
@end
