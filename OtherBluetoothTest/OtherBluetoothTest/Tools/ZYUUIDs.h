//
//  ZYUUIDs.h
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYUUIDs : NSObject
+(NSString *)ZYServiceUUID;//智云设备的服务ID

+(NSString *)ZYCharacteristicUUID_Retrieve;//根据当前UUID在retrieve方法调用的时候找寻指定设备
+(NSString *)ZYCharacteristicUUID_Write;//在当前服务下的特征值ID可写
+(NSString *)ZYCharacteristicUUID_Read;//在当前服务下的特征值ID可读

@end

NS_ASSUME_NONNULL_END
