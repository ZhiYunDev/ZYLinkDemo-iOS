//
//  ZYOtherBlueToothTools.m
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/30.
//

#import "ZYOtherBlueToothTools.h"

@implementation ZYOtherBlueToothTools

+ (CBService*)findServiceFromUUID:(NSString*)UUID peripheral:(CBPeripheral*)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([[s.UUID UUIDString] isEqualToString:UUID])
            return s;
    }
    return nil;
}

+ (CBCharacteristic*)findCharacteristicFromUUID:(NSString*)UUID service:(CBService*)service {
    for(int i=0; i<service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([[c.UUID UUIDString] isEqualToString:UUID])
            return c;
    }
    return nil;
}

+ (void)notification:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    CBService *service = [self findServiceFromUUID:serviceUUID peripheral:p];
    if (!service) {
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    if (!characteristic) {
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

+ (BOOL)enableNotification:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID service:(CBService *)service peripheral:(CBPeripheral *)p on:(BOOL)on {

    if ([[service.UUID  UUIDString] isEqualToString:serviceUUID]) {
        for (int i=0; i<service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            if ([[c.UUID UUIDString] isEqualToString:characteristicUUID]) {
                [p setNotifyValue:YES forCharacteristic:c];
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)isExistCharacteristic:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID service:(CBService *)service {
    if ([[service.UUID  UUIDString] isEqualToString:serviceUUID]) {
        for (int i=0; i<service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            if ([[c.UUID UUIDString] isEqualToString:characteristicUUID]) {
                return YES;
            }
        }
    }
    return NO;
}


@end
