//
//  ZYOtherDevice.m
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import "ZYOtherDevice.h"

@implementation ZYOtherDevice


- (id)init{
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)peripheralName{
    return self.peripheral.name;
}
- (NSString *)identifierString{
    return self.peripheral.identifier.UUIDString;
}

@end
