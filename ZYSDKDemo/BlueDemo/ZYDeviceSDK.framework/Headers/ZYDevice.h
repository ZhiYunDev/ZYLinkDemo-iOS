//
//  ZYDevice.h
//  ZYDevice
//
//  Created by lgj on 2017/12/27.
//  Copyright © 2017年 ZYAPPTEAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDeviceDefine.h"
@class ZYDevice;
@protocol ZYDeviceDelegate <NSObject>

@optional


/**
 设备连接状态变化
 
 @param device 设备
 @param status 设备连接状态
 */

/**
 Device connection status changes.
 
 @param device device
 @param status device conntection status
 */
-(void)onStatusChange:(ZYDevice *)device status:(ZYDeviceStatus)status;
/**
 设备有按钮按下
 
 @param device 设备
 @param event 按钮的事件
 @param type 按钮的类型
 */

/**
 设备有按钮按下
 
 @param device 设备
 @param event 按钮的事件
 @param type 按钮的类型
 @param originalKeyValue 原始的数据
 */

/**
 The device has a button to press.
 
 @param device device
 @param event keyevent
 @param type keytype
 @param originalKeyValue originalKeyValue
 */
-(void)clickedInDevice:(ZYDevice *)device KeyEvent:(ZYKeyEvent)event keyType:(ZYKeyType)type  originalKeyValue:(NSUInteger)originalKeyValue;
/**
  功能事件
  @param device 设备
  @param funcEventCode 事件编号
  @param funcEventParam 事件参数
 */

/**
  funcevent
  @param device device
  @param funcEventCode funcevent code
  @param funcEventParam funcevent param
 */
-(void)clickedInDevice:(ZYDevice *)device funcEventCode:(NSUInteger)funcEventCode funcEventParam:(NSUInteger)funcEventParam;
/**
  功能组合事件
  @param device 设备
 @param funcEventArray @[@{@(funcEventCode):@(funcEventParam),@(funcEventCode):@(funcEventParam)}]，设备组合发出两个或以上功能事件的数据
 */

/**
  funcevent
  @param device device
  @param funcEventArray @[@{@(funcEventCode):@(funcEventParam)}]
 */
-(void)clickedInDevice:(ZYDevice *)device funcEventCodeAndParam:(NSArray *)funcEventArray;


/**
  onModeChanged
  @param device device
  @param onModeChanged 工作模式改变
 */
-(void)device:(ZYDevice *)device onModeChanged:(ZYBleDeviceWorkMode)workMode;

@end

@interface ZYDevice : NSObject

/// 外部初始化对象，通过此种方式初始化的时候,onStatusChange:status:方法不生效,当接收到数据之后调用reciveData:方法，发送端SendDataBlock用于发送数据
/// @param type ZYDeviceType对象的类型
/// @param needMessage 广播数据或者，description的字符串
/// @param identifier 设备的唯一标识符,外部提供，
+ (instancetype)initWithType:(ZYDeviceType)type needMessage:(id)needMessage identifier:(NSString *)identifier;

/// 发送数据
@property (nonatomic, copy) SendDataBlock sendDataBlock;

/// 收到数据
/// @param data 代理必须实现
-(void)reciveData:(NSData *)data;


/**
 设备的唯一标识符
 */

/**
 The unique identifier of the device.
 */
@property (nonatomic, copy, readonly)     NSString *identifier;

/**
 设备的信号强度0～100
 */

/**
 RSSI range 0 ~ 100.
 */
@property (nonatomic, assign,readonly)    NSInteger rssi;

/**
 设备是否在连接上
 */

/**
 Whether the device is connected.
 */
@property (nonatomic, assign, readonly)   BOOL     isConneted;
/**
 设备显示的名称
 */

/**
 The name of the device display.
 */
@property (nonatomic, copy, readonly)     NSString *displayName;
/**
 设备的名称
 */

/**
 model name
 */
@property (nonatomic, copy, readonly)     NSString *modelName;

/**
 well-known name
 */
@property (nonatomic, copy, readonly)     NSString *marketingName;






/**
 设备的代理
 */

/**
 delegate
 */
@property (nonatomic, weak)               id<ZYDeviceDelegate> delegate;

/**
 连接设备
 */

/**
 device Connect
 */
-(void)connect;

/**
 断开设备
 */

/**
 device disConnect
 */
-(void)disConnect;


/**
 设备支持的事件按钮类型
只支持  SmoothQ Smooth3 smooth4 查询
 @return 所有支持的数组
 */

/**
 Device support Types of keys
 only support SmoothQ Smooth3 smooth4 smoothQ2 query

 @return support arrays
 */
-(NSArray *)supportKeyTypes;


/**
 写数据

 @param data 数据
 */
-(void)writeData:(NSData *)data;

/**
 写数据，需要加crc的数据，只对数据长度大于4的数据加crc

 @param data 数据
 @param needAddCrc 是否需要添加CRC
 */
-(void)writeData:(NSData *)data needAddCrc:(BOOL)needAddCrc;

/**
 获取3个轴的位置
 @param handler 俯仰轴位置 横滚轴位置 航向轴位置
 */
-(void) queryCurrectAxisesPosition:(void (^)(float pitch, float roll, float yaw, BOOL success)) handler;

/**
 在指定时间内移动到指定点,smooth4在lock模式使用才不会移动完之后回中
 @param pitch 俯仰轴目标位置(-180, 180)
 @param roll 横滚轴目标位置(-180, 180)
 @param yaw 航向轴目标位置(-180, 180)
 @param totalTime 移动总耗时
 @param handler 完成通知
 */
-(void) moveToPitch:(float)pitch roll:(float)roll yaw:(float)yaw withInTime:(NSTimeInterval)totalTime compeletion:(void (^)(BOOL success))handler;

/**
 取消正在进行的移动
 */
-(void) cancelMove;

@end

