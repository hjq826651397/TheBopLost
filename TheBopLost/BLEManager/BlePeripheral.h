//
//  BlePeripheral.h
//  TheBopLost
//
//  Created by mosaic on 2018/4/9.
//  Copyright © 2018年 mosaic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BlePeripheralDelegate<NSObject>

@end

@interface BlePeripheral : NSObject<CBPeripheralDelegate>

@property (nonatomic, strong)CBPeripheral *peripheral;
@property (nonatomic, strong)CBCharacteristic *writeCharacteristic;

//
@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong)NSNumber *RSSI;

- (void)discoverMoreServices;
- (void)writeCharacteristicData:(NSData *)data;

@end
