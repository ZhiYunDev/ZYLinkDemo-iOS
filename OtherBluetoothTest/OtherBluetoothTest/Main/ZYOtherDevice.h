//
//  ZYOtherDevice.h
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <ZYDeviceSDK/ZYDevice.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYOtherDevice : NSObject

@property (nonatomic, strong)NSNumber * RSSI;
@property (nonatomic, copy)NSString * peripheralName;
@property (nonatomic, copy)NSString * identifierString;
@property (nonatomic, strong)CBPeripheral * peripheral;//外设
@property (nonatomic, strong)NSDictionary * advertisementData;//未连接之前是广播信息如果通过retrieve方式获取就在获取descriper的回调里赋值
@property (nonatomic, assign)BOOL isRetrieve;//如果是通过retrieveConnectedPeripheralsWithServices方法获取的就赋值为YES 否则为NO
@property (nonatomic, strong)ZYDevice * device;

@end

NS_ASSUME_NONNULL_END
