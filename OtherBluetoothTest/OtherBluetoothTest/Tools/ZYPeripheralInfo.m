//
//  ZYPeripheralInfo.m
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import "ZYPeripheralInfo.h"

@implementation ZYPeripheralInfo

- (instancetype)init{
    if (self = [super init]) {
        _characteristics = [NSMutableArray new];
    }
    return self;
}

@end
