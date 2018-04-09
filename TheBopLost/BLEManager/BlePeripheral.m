//
//  BlePeripheral.m
//  TheBopLost
//
//  Created by mosaic on 2018/4/9.
//  Copyright © 2018年 mosaic. All rights reserved.
//

#import "BlePeripheral.h"

@implementation BlePeripheral

-(void)setPeripheral:(CBPeripheral *)peripheral{
    _peripheral = peripheral;
}

- (void)discoverMoreServices{
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];
}

- (void)writeCharacteristicData:(NSData *)data{
    [_peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark  CBPeripheralDelegate
// 更新外设 名字
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    // 遍历出外设中所有的服务
    for (CBService *service in peripheral.services) {
        ZKLog(@"所有的服务：%@",service);
    }
    // 这里仅有一个服务，所以直接获取
    CBService *service = peripheral.services.lastObject;
    // 根据UUID寻找服务中的特征
    [peripheral discoverCharacteristics:nil forService:service];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    // 遍历出所需要的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        ZKLog(@"所有特征：%@", characteristic);
        // 从外设开发人员那里拿到不同特征的UUID，不同特征做不同事情，比如有读取数据的特征，也有写入数据的特征
    }
    // 这里只获取一个特征，写入数据的时候需要用到这个特征
    self.writeCharacteristic = service.characteristics.lastObject;
    // 直接读取这个特征数据，会调用didUpdateValueForCharacteristic
    [peripheral readValueForCharacteristic:self.writeCharacteristic];
    // 订阅通知
    [peripheral setNotifyValue:YES forCharacteristic:self.writeCharacteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功");
    } else {
        NSLog(@"取消订阅");
    }
}

// 写入数据成功的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    ZKLog(@"写入数据成功");
}

@end
