//
//  ZYDeviceManager.h
//  ZYDevice
//
//  Created by lgj on 2017/12/27.
//  Copyright © 2017年 ZYAPPTEAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDeviceDefine.h"
#import "ZYDevice.h"
@protocol ZYDeviceManagerDelegate <NSObject>

@optional

/**
 discover Device
 
 @param device discovered Device
 */
-(void)onScaned:(ZYDevice *)device;


/**
 手机系统(WIFI,USB,bluetooth)连接状态改变
 */
/**
 The iphone system state((WIFI,USB,bluetooth)) changes.
 */
-(void)connectStateChange;

@end

@interface ZYDeviceManager : NSObject
/**
 连接的设备
 */
/**
 connectioned Devices
 */
@property (nonatomic, strong,readonly)    NSMutableArray<ZYDevice *> *connectionedDevices;
/**
 代理
 */
/**
 delegate
 */
@property (nonatomic, weak)               id<ZYDeviceManagerDelegate> delegate;
/**
 单例
 
 @return 单例对象
 */
/*!
 +sharedInstance returns a global instance .
 */
+(instancetype)sharedInstance;

/// 通过json注册 appid secretKey certificate
/// @param certPath cert.json 文件的完整路径

/// user cert.json registered appid、secretKey、certificate
/// @param certPath Full path to the cert.json file
+(void)setCertPath:(NSString *)certPath error:(NSError **)error;

/**
 注册appid
 
 @param appid 服务器生成的唯一 appId
 @param secretKey 私钥;
 */

/**
 registered appid and secretKey
 
 @param appid appid
 @param secretKey secretKey
 */
+(void)setAppId:(NSString *)appid secretKey:(NSString *)secretKey;

/**
 加入证书
 
 @param certificate 证书;
 */

/**
 Registration certificate
 
 @param certificate certificate
 */
+(void)validCertificate:(NSString *)certificate;

/// 验证证书数据
/// @param certdata 数据
/// @param error 证书错误

/// verify certificate
/// @param certdata certificate data
/// @param error error
+(void)validateCertWithData:(NSData *)certdata error:(NSError **)error;

/**
 扫描对象
 
 @param type 设备类型（蓝牙，USB，Wi-Fi）
 */

/**
 scan
 
 @param type DeviceType（bluetooth，USB，Wi-Fi）
 */
-(void)scan:(ZYDeviceType)type;

/**
 取消扫描
 */

/**
 cancelScan
 */
-(void)cancelScan;

/**
 扫描到的设备
 
 @param index 下标
 @return 对应的扫描到的设备
 */

/**
 scaned device
 
 @param index index
 @return scanned device.
 */
-(ZYDevice *)deviceAtIndex:(NSUInteger )index;

/**
 通过设备的identifier获取设备
 
 @param identifier 设备的唯一标识
 @return 对应的设备
 */

/**
 Get the device through the device's identifier.
 
 @param identifier identifier
 @return device
 */
-(ZYDevice *)queryDeviceWithIdentifier:(NSString *)identifier;


/**
 扫描到的设备（每次新的扫描都会清空上次的扫描设备）
 
 @return 所以的扫描到的设备
 */

/**
 all scanned device.
 
 @return all scanned device.
 */
-(NSArray<ZYDevice *>*)scanedDevices;



@end

