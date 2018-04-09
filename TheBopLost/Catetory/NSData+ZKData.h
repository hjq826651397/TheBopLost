//
//  NSData+ZKData.h
//  蓝牙电子锁
//
//  Created by mosaic on 2017/12/6.
//  Copyright © 2017年 mosaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZKData)
// 十六进制转换NSData
+ (NSData *)convertHexStrToData:(NSString *)str;
@end
