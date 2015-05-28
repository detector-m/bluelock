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

#import "RLBluetooth.h"

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
    
    CGRect frame = self.table.tableView.frame;
    frame.size.height -= WarnLabelHeight;
    self.table.tableView.rowHeight = 64.0f;
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
        if(!peripherals.count) return ;
        weakSelf.table.datas = [NSMutableArray arrayWithArray:peripherals];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.table.tableView reloadData];
        });
    }];
}

- (void)clickRightItem {
    [self scanBLPeripherals];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
    for(LockModel *lock in self.lockDevicesVC.table.datas) {
        if([lock.name isEqualToString:name]) {
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
    cell.textLabel.text = peripheral.cbPeripheral.name;
    cell.imageView.image = [UIImage imageNamed:@"Bluetooth.png"];
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([self isAddedWithName:peripheral.name]) {
        cell.detailTextLabel.text = NSLocalizedString(@"已存在", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.userInteractionEnabled = NO;
    }
    else {
        cell.detailTextLabel.text = NSLocalizedString(@"新设备", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexForData:indexPath];

    __weak __typeof(self)weakSelf = self;

    RLPeripheral *peripheral = [self.table.datas objectAtIndex:index];
    [[RLBluetooth sharedBluetooth] connectPeripheral:peripheral withConnectedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for(RLService *service in peripheral.services) {
                if([service.UUIDString isEqualToString:@"1910"]) {
                    for(RLCharacteristic *characteristic in service.characteristics) {
                        if(characteristic.cbCharacteristic.properties == CBCharacteristicPropertyNotify) {
                            
                            [characteristic setNotifyValue:YES completion:^(NSError *error) {
                                for(RLCharacteristic *characteristic in service.characteristics) {
                                    if([characteristic.UUIDString isEqualToString:@"fff2"]) {
                                        [weakSelf writeDataToCharacteristic:characteristic withData:nil];
                                    
                                        return ;
                                    }
                                }
                            } onUpdate:^(NSData *data, NSError *error) {
                                BL_response cmdResponse = responseWithBytes(( Byte *)[data bytes], data.length);
                                Byte crc = CRCOfCMDBytes((Byte *)[data bytes], data.length);
                                
                                if(crc == cmdResponse.CRC && cmdResponse.result.result == 0) {
                                    LockModel *lock = [LockModel new];
                                    lock.name = NSLocalizedString(@"我的智能锁", nil);
                                    lock.address = peripheral.name;
                                    lock.token = [User sharedUser].sessionToken;
                                    lock.pwd = weakSelf.pwd;
                                    
                                    [DeviceManager addBluLock:lock withBlock:^(DeviceResponse *response, NSError *error) {
                                        if(error) {
                                            DLog(@"%@", error);
                                            
                                            return;
                                        }
                                        if(response.status == 0) {
                                            [RLHUD hideProgress];
                                            [[weakSelf lockDevicesVC] addLockWithPeripheral:lock];
                                            
                                            [RLHUD hudAlertSuccessWithBody:NSLocalizedString(@"配对成功", nil)];
                                        }
                                    }];
                                }
                            }];
                        }
                    }
                }
            }

        });
    }];
    [RLHUD hudProgressWithBody:NSLocalizedString(@"正在配对...", nil) onView:self.view.superview timeout:6.0f];
}

- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic withData:(NSData *)data {
    if(characteristic.cbCharacteristic.properties == CBCharacteristicPropertyWrite || CBCharacteristicPropertyWriteWithoutResponse == characteristic.cbCharacteristic.properties) {
        [self pairPeripheral:characteristic];
    }
}

- (void)pairPeripheral:(RLCharacteristic *)cb {
//        Byte data[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b};
    long long data = [NSDate timeIntervalSinceReferenceDate]*1000;
//    DLog(@"%lli", data);
    self.pwd = data;
    struct BL_cmd cmd = {0};
    cmd.ST = 0x55;
    cmd.CRC += cmd.ST;
    cmd.cmd_code = 0x01;
    cmd.CRC += cmd.cmd_code;
    cmd.union_mode.connection = 0x01;
    cmd.CRC += cmd.union_mode.connection;
    cmd.result.keep = 0x00;
    cmd.CRC += cmd.result.keep;
    cmd.END = 0x66;
    
    cmd.data = (Byte *)&data;
    cmd.data_len = sizeof(data);
    cmd.CRC += cmd.data_len;
    
    cmd.CRC +=  CMDDatasCRCCheck(cmd.data, cmd.data_len);
    
    cmd.fixation_len = BLcmdFixationLen();
    NSInteger len = cmd.data_len + cmd.fixation_len;
    
    Byte *bytes = calloc(len, sizeof(UInt8));
    
    wrappCMDToBytes(&cmd, bytes);
    
    int i;
    
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSInteger length = len;//sizeof(bytes);
    
    for(i=0; i<length; i++) {
        [str appendString:[NSString stringWithFormat:@"%02x", bytes[i]]];
    }
    for(i=0; i<length; i++) {
        [cb writeValue:[NSData dataWithBytes:&bytes[i] length:1] completion:nil];
        [NSThread sleepForTimeInterval:0.05];
    }
    
    NSLog(@"str = %@", str);
    free((void *)bytes);
}
@end
