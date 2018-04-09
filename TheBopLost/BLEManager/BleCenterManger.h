//
//  BleCenterManger.h
//  TheBopLost
//
//  Created by mosaic on 2018/4/9.
//  Copyright © 2018年 mosaic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BleCenterMangerDelegate<NSObject>


@end

@interface BleCenterManger : NSObject<CBCentralManagerDelegate>
@property (nonatomic, weak) id <BleCenterMangerDelegate>centerDelegate;
@property (nonatomic, strong)CBCentralManager *centerManager;

singleton_interface(BleCenterManger)

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions;
- (void)scan; // 扫描
- (void)stopScan; // 停止扫面
- (void)connectPeripheral:(BlePeripheral *)periphera;//连接蓝牙
- (void)disConnectPeripheral:(BlePeripheral *)peripheral; // 断开连接

@end
