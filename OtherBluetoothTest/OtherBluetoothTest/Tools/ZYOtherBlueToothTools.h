//
//  ZYOtherBlueToothTools.h
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/30.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYOtherBlueToothTools : NSObject

+ (CBService*)findServiceFromUUID:(NSString*)UUID peripheral:(CBPeripheral*)p;
+ (CBCharacteristic*)findCharacteristicFromUUID:(NSString*)UUID service:(CBService*)service;

+ (void)notification:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on;
+ (BOOL)enableNotification:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID service:(CBService *)service peripheral:(CBPeripheral *)p on:(BOOL)on;
+ (BOOL)isExistCharacteristic:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID service:(CBService *)service;

@end

NS_ASSUME_NONNULL_END
