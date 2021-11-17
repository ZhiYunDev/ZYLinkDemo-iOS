//
//  ZYPeripheralInfo.h
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZYPeripheralInfo : NSObject

@property (nonatomic,strong) CBUUID *serviceUUID;
@property (nonatomic,strong) NSMutableArray *characteristics;


@end

NS_ASSUME_NONNULL_END
