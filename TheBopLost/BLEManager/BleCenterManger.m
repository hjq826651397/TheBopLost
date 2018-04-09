//
//  BleCenterManger.m
//  TheBopLost
//
//  Created by mosaic on 2018/4/9.
//  Copyright © 2018年 mosaic. All rights reserved.
//

#import "BleCenterManger.h"
#import "AppDelegate.h"

@implementation BleCenterManger{
    NSDictionary *_managerDict;
    NSDictionary *_scanDict;
    NSDictionary *_connectDict;
    NSMutableArray <BlePeripheral *>*_newsPers; // 扫描到的设备
    NSMutableArray <BlePeripheral *>*_onlinePers; // 不重复de在线设备数组
    BlePeripheral *_bleP;
}

singleton_implementation(BleCenterManger)

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions{
    self = [super init];
    if (self) {
        _managerDict = @{CBCentralManagerOptionShowPowerAlertKey:@YES,CBCentralManagerOptionRestoreIdentifierKey:(launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey] ?: [[NSUUID UUID] UUIDString])};
        // 表示不会重复扫描已发现的设备--扫描中使用
        _scanDict = @{CBCentralManagerScanOptionAllowDuplicatesKey: @YES };
        // 链接外设时...使用
        _connectDict = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
        dispatch_queue_t centralQueue = dispatch_queue_create("lostLock",0);
        //
        _centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue options:_managerDict];
        
        //
        _onlinePers = [NSMutableArray array];
        _newsPers = [NSMutableArray array];
    }
    return self;
}

- (void)scan{
    [self stopScan];
    [_onlinePers removeAllObjects];
    [_newsPers removeAllObjects];
    //
    [self.centerManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFE0"]] options:_scanDict];
}

- (void)stopScan{
    if (@available(iOS 9.0, *)) {
        if (self.centerManager.isScanning) {
            [self.centerManager stopScan];
        }
    }else{
        [self.centerManager stopScan];
    }
}

- (void)connectPeripheral:(BlePeripheral *)periphera{
    ZKLog(@"++++ %@", periphera);
    _bleP = nil;
    _bleP = periphera;
    if (@available(iOS 9.0, *)) {
        if (periphera.peripheral.state == CBPeripheralStateDisconnected || periphera.peripheral.state == CBPeripheralStateDisconnecting) {
            [self.centerManager connectPeripheral:periphera.peripheral options:_connectDict];
        }
    }else{
        if (periphera.peripheral.state == CBPeripheralStateDisconnected) {
            [self.centerManager connectPeripheral:periphera.peripheral options:_connectDict];
        }
    }
}

- (void)disConnectPeripheral:(BlePeripheral *)peripheral{
    if (peripheral.peripheral != CBPeripheralStateDisconnected) {
        [self.centerManager cancelPeripheralConnection:peripheral.peripheral];
    }
}

#pragma mark ==CBCentralManagerDelegate==
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict{
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
}

#pragma mark  初始化CBCentralManager后---回调
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (@available(iOS 10.0, *)) {
        switch (central.state) {
            case CBManagerStateUnknown:
                break;
            case CBManagerStateResetting:
                break;
            case CBManagerStateUnsupported:
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持BLE4.0" delegate:nil
                                      cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
                break;
            case CBManagerStateUnauthorized:
                break;
            case CBManagerStatePoweredOff:
                break;
            case CBManagerStatePoweredOn:  // 手机蓝牙打开
                [self scan];
                break;
            default:
                break;
        }
    }else{
        switch (central.state) {
            case CBCentralManagerStateUnknown:
                break;
            case CBCentralManagerStateResetting:
                break;
            case CBCentralManagerStateUnsupported:
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持BLE4.0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                });
                break;
            case CBCentralManagerStateUnauthorized:
                break;
            case CBCentralManagerStatePoweredOff:
                break;
            case CBCentralManagerStatePoweredOn:
                [self scan];
                break;
            default:
                break;
        }
    }
}

#pragma mark  扫描到 CBPeripheral
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    ZKLog(@"%@ --- %@", peripheral, advertisementData);
    if (peripheral.state != CBPeripheralStateConnected) {
//        [self connectPeripheral:peripheral];
        // 筛选
        for (BlePeripheral *blep in _newsPers) {
            if (blep.peripheral != peripheral) {
                [_onlinePers addObject:blep];
            }
        }
        BlePeripheral *blep = [[BlePeripheral alloc] init];
        blep.peripheral = peripheral;
        blep.name = peripheral.name;
        blep.RSSI = peripheral.RSSI;
        [_newsPers addObject:blep];
    }
}

#pragma mark  连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    ZKLog(@"链接成功");
    [_bleP discoverMoreServices];
}

// 链接失败的回调
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    ZKLog(@"链接失败");
    if (peripheral.state != CBPeripheralStateConnected) {
        [self.centerManager connectPeripheral:peripheral options:_connectDict];
    }
}

// 断开链接的回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if (peripheral.state != CBPeripheralStateConnected) {
        [self.centerManager connectPeripheral:peripheral options:_connectDict];
    }
}

@end
