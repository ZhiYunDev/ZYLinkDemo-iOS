//
//  ZYDeviceDefine.h
//  ZYDevice
//
//  Created by lgj on 2017/12/27.
//  Copyright © 2017年 ZYAPPTEAM. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 按键的按钮
 
 - ZYKeyTypeNone: 没有按钮
 - ZYKeyTypeUp: 按钮上
 - ZYKeyTypeDown: 按钮下
 - ZYKeyTypeMode: 模式按钮
 - ZYKeyTypeLeft: 按钮左
 - ZYKeyTypeRight: 按钮右
 - ZYKeyTypePhotos: 拍照按钮
 - ZYKeyTypeT: t按钮
 - ZYKeyTypeW: w按钮
 - ZYKeyTypeCW: cw按钮
 - ZYKeyTypeCCW: ccw按钮
 - ZYKeyTypeFN: fn按钮
 - ZYKeyTypeMENU: Menu and back按钮
 - ZYKeyTypeDISP: DISP按钮
 - ZYKeyTypeFLashOK: Flash and OK按钮
 - ZYKeyTypeSwitch: switch按钮
 - ZYKeyTypeRecord: 录像按钮
 - ZYKeyTypeSIDE_CW: Side_CW按钮
 - ZYKeyTypeSIDE_CCW: Side_CCW按钮
 - ZYKeyTypeZoom_Up: Zoom_Up
 - ZYKeyTypeZoom_Down: Zoom_Down
 - ZYKeyTypeFocus_Up: Focus_Up
 - ZYKeyTypeFocus_Down: Focus_Down
 - ZYKeyTypeCapture: Capture
 - ZYKeyTypeFN_Down: FN_down
 - ZYKeyTypePhoto: photo
 
 */


/**
 Types of keys

 - ZYKeyTypeNone: None
 - ZYKeyTypeUp:up
 - ZYKeyTypeDown: down
 - ZYKeyTypeMode: mode
 - ZYKeyTypeLeft: left
 - ZYKeyTypeRight: right
 - ZYKeyTypePhotos: photos
 - ZYKeyTypeT: T
 - ZYKeyTypeW: W
 - ZYKeyTypeCW: CW
 - ZYKeyTypeCCW: CCW
 - ZYKeyTypeFN: FN
 - ZYKeyTypeMENU: Menu and back
 - ZYKeyTypeDISP: DISP
 - ZYKeyTypeFLashOK: Flash and OK
 - ZYKeyTypeSwitch: switch
 - ZYKeyTypeRecord: record
 - ZYKeyTypeSIDE_CW: Side_CW
 - ZYKeyTypeSIDE_CCW: Side_CCW
 - ZYKeyTypeZoom_Up: Zoom_Up
 - ZYKeyTypeZoom_Down: Zoom_Down
 - ZYKeyTypeFocus_Up: Focus_Up
 - ZYKeyTypeFocus_Down: Focus_Down
 - ZYKeyTypeCapture: Capture
 - ZYKeyTypeFN_Down: FN_down
 - ZYKeyTypePhoto: photo
 */

typedef NS_ENUM(NSInteger, ZYKeyType) {
    ZYKeyTypeNone,
    ZYKeyTypeUp,
    ZYKeyTypeDown,
    ZYKeyTypeMode,
    ZYKeyTypeLeft,
    ZYKeyTypeRight,
    ZYKeyTypePhotos,
    ZYKeyTypeT,
    ZYKeyTypeW,
    ZYKeyTypeCW,
    ZYKeyTypeCCW,
    ZYKeyTypeFN,
    ZYKeyTypeMENU,
    ZYKeyTypeDISP,
    ZYKeyTypeFLashOK,
    ZYKeyTypeSwitch,
    ZYKeyTypeRecord,
    ZYKeyTypeSIDE_CW,
    ZYKeyTypeSIDE_CCW,
    ZYKeyTypeZoom_Up,
    ZYKeyTypeZoom_Down,
    ZYKeyTypeFocus_Up,
    ZYKeyTypeFocus_Down,
    ZYKeyTypeCapture,
    ZYKeyTypeFN_Down,
    ZYKeyTypePhoto,

};
/**
 按钮事件类型
 
 - ZYKeyEventNone: 无按钮事件类型
 - ZYKeyEventPressed: 按钮按下
 - ZYKeyEventReleased: 按钮释放
 - ZYKeyEventClicked: 按钮按下
 - ZYKeyEventPress1S: 按钮按下1s
 - ZYKeyEventPress3S: 按钮按下3s
 - ZYKeyEventPressDoubleClicked: 单击
 - ZYKeyEventPressTripleClicked: 双击
 */

/**
 Button event type
 
 - ZYKeyEventNone: None
 - ZYKeyEventPressed: Pressed
 - ZYKeyEventReleased: Released
 - ZYKeyEventClicked: Clicked
 - ZYKeyEventPress1S: Pressed 1 second
 - ZYKeyEventPress3S: Pressed 3 second
 - ZYKeyEventPressDoubleClicked: Double Clicked
 - ZYKeyEventPressTripleClicked: Triple Clicked
 */
typedef NS_ENUM(NSInteger, ZYKeyEvent) {
    ZYKeyEventNone,
    ZYKeyEventPressed,
    ZYKeyEventReleased,
    ZYKeyEventClicked,
    ZYKeyEventPress1S,
    ZYKeyEventPress3S,
    ZYKeyEventPressDoubleClicked,
    ZYKeyEventPressTripleClicked,
};

/**
 设备类型
 
 - ZYDeviceTypeBle: 蓝牙设备
 - ZYDeviceTypeWiFi: wifi设备
 - ZYDeviceTypeUSB: usb设备
 - ZYDeviceTypeAll: 所以设备
 */

/**
 Device type
 
 - ZYDeviceTypeBle: Device type bluetooth
 - ZYDeviceTypeWiFi: Device type WiFi
 - ZYDeviceTypeUSB: Device type USB
 - ZYDeviceTypeAll: ZYDeviceTypeAll
 */
typedef NS_ENUM(NSInteger, ZYDeviceType) {
    ZYDeviceTypeBle,
    ZYDeviceTypeWiFi,
    ZYDeviceTypeUSB,
    ZYDeviceTypeAll,
};

/**
 连接状态
 - ZYDeviceStatusNoConnection: 未连接状态
 - ZYDeviceStatusTobeConnected: 将要连接
 - ZYDeviceStatusKeepConnecting:保持连接
 - ZYDeviceStatusKeepConnecting:能够发送数据
 - ZYDeviceStatusTobeMissed: 将要断开连接
 */

/**
 Connection status
 
 - ZYDeviceStatusNoConnection: Unconnected state
 - ZYDeviceStatusTobeConnected: Will connect
 - ZYDeviceStatusKeepConnecting: keep connected
 - ZYDeviceStatusCanSendData: can send Data
 - ZYDeviceStatusTobeMissed: Will disconnect
 */
typedef NS_ENUM(NSInteger, ZYDeviceStatus) {
    ZYDeviceStatusNoConnection,
    ZYDeviceStatusTobeConnected,
    ZYDeviceStatusKeepConnecting,
    ZYDeviceStatusCanSendData,
    ZYDeviceStatusTobeMissed,
};

//发送数据的block
typedef void (^SendDataBlock)(NSData *data);

#define ZYSendServiceUUID128        @"0000FEE9-0000-1000-8000-00805F9B34FB"
#define ZYSendServiceUUID16         @"FEE9"

@interface ZYDeviceDefine : NSObject

@end

