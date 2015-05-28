//
//  RLBluetooth.m
//  Smartlock
//
//  Created by RivenL on 15/3/12.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBluetooth.h"
#import "RLHUD.h"

@interface RLBluetooth ()
@property (nonatomic, readwrite, strong) RLCentralManager *manager;

@property (nonatomic, strong) void (^connectedCallback)();
@end

@implementation RLBluetooth
- (void)dealloc {
    self.manager = nil;
    self.connectedCallback = nil;
}

+ (instancetype)sharedBluetooth {
    static RLBluetooth *_sharedBluetooth = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBluetooth = [[RLBluetooth alloc] init];
    });
    
    return _sharedBluetooth;
}

- (instancetype)init {
    if(self = [super init]) {
        [self setupBLCentralManaer];
    }
    
    return self;
}

#pragma mark -
- (BOOL)bluetoothIsReady {
    return self.manager.centralReady;
}

#pragma mark -
- (void)setupBLCentralManaer {
    self.manager = [RLCentralManager new];
}

- (void)scanBLPeripheralsWithCompletionBlock:(void (^)(NSArray *peripherals))completionCallback {
    if(![self bluetoothIsReady]) {
        if(completionCallback) {
            completionCallback(nil);
        }
        [RLHUD hudAlertWarningWithBody:NSLocalizedString(@"蓝牙未开启！", nil)];
        return;
    }
    [self disconnectAllPeripherals];
    [self.manager scanForPeripheralsByInterval:1 completion:^(NSArray *peripherals) {
        if(completionCallback) {
            completionCallback(peripherals);
        }
    }];
}

- (void)removeBLPeripherals {
    [self disconnectAllPeripherals];
}

- (void)connectPeripheral:(RLPeripheral *)peripheral withConnectedBlock:(void (^)())callback {
    __weak __typeof(self)weakSelf = self;
//    DLog(@"%@", peripheral.cbPeripheral.uuid)
    if(callback) {
        self.connectedCallback = nil;
        self.connectedCallback = callback;
    }
    RLPeripheralConnectionCallback peripheralConnectionCallback = ^(NSError *error) {
        if(error) {
            if(weakSelf.connectedCallback) {
                self.connectedCallback();
            }
            self.connectedCallback = nil;
            NSLog(@"error = %@", error);
            
            return ;
        }
        
        [weakSelf discoverPeripheralServicesWithPeripheral:peripheral];
    };
    
    [peripheral connectWithCompletion:peripheralConnectionCallback];
}

- (void)disconnectAllPeripherals {
    for(RLPeripheral *peripheral in self.manager.peripherals) {
        if(peripheral.cbPeripheral.state == CBPeripheralStateConnected || peripheral.cbPeripheral.state == CBPeripheralStateConnecting) {
            [self disconnectPeripheral:peripheral];
        }
    }
}

- (void)disconnectPeripheral:(RLPeripheral *)peripheral {
    if(!peripheral) return;
    
    self.connectedCallback = nil;
    [peripheral disconnectWithCompletion:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)discoverPeripheralServicesWithPeripheral:(RLPeripheral *)peripheral {
    __weak __typeof(self)weakSelf = self;
    
    RLPeripheralDiscoverServicesCallback discoverPeripheralServicesCallback = ^(NSArray *services, NSError *error) {
        if(error) {
            self.connectedCallback = nil;
            NSLog(@"error = %@", error);
            
            return ;
        }
        
        for(RLService *service in services) {
            [weakSelf discoverServiceCharacteristicsWithService:service];
        }
    };
    
    [peripheral discoverServicesWithCompletion:discoverPeripheralServicesCallback];
}

- (void)discoverServiceCharacteristicsWithService:(RLService *)service {
//    __weak __typeof(self)weakSelf = self;
    
    RLServiceDiscoverCharacteristicsCallback discoverServiceCharacteristicsCallback = ^(NSArray *characteristics, NSError *error) {
        if(error) {
            self.connectedCallback = nil;
            NSLog(@"error = %@", error);
            return;
        }
        
        if(self.connectedCallback) {
            self.connectedCallback();
        }
        
//        self.connectedCallback = nil;
    };
    
    [service discoverCharacteristicsWithCompletion:discoverServiceCharacteristicsCallback];
}

- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic withData:(NSData *)data {
    [self writeDataToCharacteristic:characteristic cmdCode:0x00 cmdMode:0x00 withDatas:data];
}

#pragma mark -
- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic cmdCode:(Byte)cmdCode cmdMode:(Byte)cmdMode withDatas:(NSData *)data {
    if(characteristic.cbCharacteristic.properties == CBCharacteristicPropertyWrite || CBCharacteristicPropertyWriteWithoutResponse == characteristic.cbCharacteristic.properties) {
        
        union union_mode mode = {cmdMode};
        struct BL_cmd cmd = getCMD(cmdCode, mode);
        cmd.CRC = CMDCRCCheck(&cmd);
        
        cmd.data = (Byte *)[data bytes];
        cmd.data_len = data.length;//sizeof(data);
        cmd.CRC += cmd.data_len;
        
        cmd.CRC +=  CMDDatasCRCCheck(cmd.data, cmd.data_len);
        
        cmd.fixation_len = BLcmdFixationLen();
        NSInteger len = cmd.data_len + cmd.fixation_len;
        
        Byte *bytes = calloc(len, sizeof(Byte));
        
        wrappCMDToBytes(&cmd, bytes);
        int i;
        
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for(i=0; i<len; i++) {
            [str appendString:[NSString stringWithFormat:@"%02x", bytes[i]]];
            [characteristic writeValue:[NSData dataWithBytes:&bytes[i] length:1] completion:nil];
            [NSThread sleepForTimeInterval:0.05];
        }
        
        DLog(@"str = %@", str);
        free((void *)bytes);
    }
}

@end
