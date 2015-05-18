//
//  TestViewController.m
//  Smartlock
//
//  Created by RivenL on 15/3/13.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "TestViewController.h"
#if 1
#import "RLCharacteristic.h"
#import "RLDefines.h"
#import "RLPeripheral.h"
#import "BluetoothLockCommand.h"

#import "ServicesViewController.h"

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) RLCentralManager *manager;

@property (nonatomic, strong) RLTable *peripheralsTable;
@end

@implementation TestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Peripheral", nil);
    
    self.manager = [RLCentralManager new];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.view.frame.size.width/2 - 40, 70, 80, 40);
    [self.view addSubview:button];
    
    [self tableDoLoad];
}

- (void)tableDoLoad {
    CGRect frame = self.view.frame;
    self.peripheralsTable = [RLTable new];
    UITableView *view = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, frame.size.width, frame.size.height-90) style:UITableViewStylePlain];
    view.delegate = self;
    view.dataSource = self;
    [self.view addSubview:view];
    
    self.peripheralsTable.tableView = view;
}

- (void)clicked {
//    [self.manager scanForPeripherals];
    
        __weak TestViewController *weakSelf = self;
        [self.manager scanForPeripheralsByInterval:1 completion:^(NSArray *peripherals) {
            weakSelf.peripheralsTable.datas = [NSMutableArray arrayWithArray:peripherals];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.peripheralsTable.tableView reloadData];
            });
            if(peripherals.count > 0) {
                [weakSelf testPeripheral:peripherals[0]];
            }
        }];
}

- (void)testPeripheral:(RLPeripheral *)peripheral {
    __weak __typeof(self)weakSelf = self;
    [peripheral connectWithCompletion:^(NSError *error) {
        if(error) {
            NSLog(@"error = %@", error);
        }
        else {
            [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
                if(error) {
                    NSLog(@"error = %@", error);
                }
                else {
                    for(RLService *service in services) {
                        [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                            if(error) {
                                NSLog(@"error = %@", error);
                            }
                            else {
                                // We need to count down completed operations for disconnecting
                                for (RLCharacteristic *charact in characteristics) {
                                    if(charact.cbCharacteristic.properties == CBCharacteristicPropertyNotify) {
                                        [charact setNotifyValue:YES completion:^(NSError *error) {
                                        }];
                                    }
                                    else if(charact.cbCharacteristic.properties == CBCharacteristicPropertyWrite || CBCharacteristicPropertyWriteWithoutResponse == charact.cbCharacteristic.properties) {
                                        if([charact.UUIDString isEqualToString:@"fff2"]) {
                                            [weakSelf test:charact];
                                        }
                                    }
                                    else {
                                        if([charact.UUIDString isEqualToString:@"2a25"]) {
                                        }
                                    }
                                }
                            }
                        }];
                    }
                }
            }];
        }
    }];
}

- (void)test:(RLCharacteristic *)cb {
    Byte data[] = {0x3c, 0xbd, 0xec, 0x37, 0xd6, 0xa2, 0x40, 0x4f, 0x96, 0xa0, 0x83, 0xa3, 0xaa, 0x5d, 0x73, 0x82, 0x3c, 0xbd, 0xec, 0x37, 0xd6, 0xa2, 0x40, 0x4f, 0x96, 0xa0, 0x83, 0xa3, 0xaa, 0x5d, 0x73, 0x82};
    
    struct BL_cmd cmd = {0};
    cmd.ST = 0x55;
    cmd.CRC += cmd.ST;
    cmd.cmd_code = 0x01;
    cmd.CRC += cmd.cmd_code;
    cmd.union_mode.connection = 0x01;
    cmd.CRC += cmd.union_mode.connection;
    cmd.result.keep = 0x00;
    cmd.CRC += cmd.union_mode.keep;
    cmd.END = 0x66;
    
    cmd.data = data;
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
        [NSThread sleepForTimeInterval:0.1];
    }
    
    NSLog(@"str = %@", str);
    free((void *)bytes);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripheralsTable.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    RLPeripheral *peripheral = [self.peripheralsTable.datas objectAtIndex:indexPath.row];
    cell.textLabel.text = peripheral.cbPeripheral.name;
    cell.detailTextLabel.text = peripheral.cbPeripheral.identifier.UUIDString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServicesViewController *vc = [ServicesViewController new];
    vc.peripheral = [self.peripheralsTable.datas objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
#else
#import "RLCycleScrollView.h"
#import "RLScrollItem.h"

@interface TestViewController () <RLCycleScrollViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"测试", nil);

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
    RLCycleScrollView *cycleScrollView = [[RLCycleScrollView alloc] initWithFrame:CGRectMake(0, 60, w, 180)];
    cycleScrollView.items = images;
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
}

@end
#endif