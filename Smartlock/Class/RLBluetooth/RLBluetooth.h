//
//  RLBluetooth.h
//  Smartlock
//
//  Created by RivenL on 15/3/12.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLCharacteristic.h"
#import "RLDefines.h"
#import "RLPeripheral.h"
#import "BluetoothLockCommand.h"

@interface RLBluetooth : NSObject
@property (nonatomic, readonly, strong) RLCentralManager *manager;

#pragma mark -
+ (instancetype)sharedBluetooth;

#pragma mark -
- (BOOL)bluetoothIsReady;

#pragma mark -
- (void)scanBLPeripheralsWithCompletionBlock:(void (^)(NSArray *peripherals))completionCallback;
- (void)removeBLPeripherals;

- (void)connectPeripheral:(RLPeripheral *)peripheral withConnectedBlock:(void (^)())callback;
- (void)disconnectAllPeripherals;
- (void)disconnectPeripheral:(RLPeripheral *)peripheral;

- (void)discoverPeripheralServicesWithPeripheral:(RLPeripheral *)peripheral;
- (void)discoverServiceCharacteristicsWithService:(RLService *)service;
- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic withData:(NSData *)data;

#pragma mark -
- (void)writeDataToCharacteristic:(RLCharacteristic *)characteristic cmdCode:(Byte)cmdCode cmdMode:(Byte)cmdMode withDatas:(NSData *)data;
@end
