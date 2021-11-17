//
//  ZYPeripheralViewController.h
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <BabyBluetooth/BabyBluetooth.h>
#import "ZYOtherDevice.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZYPeripheralViewController : UIViewController
@property(strong,nonatomic)ZYOtherDevice *device;
@property (nonatomic, strong)BabyBluetooth * babytooth;

@end

NS_ASSUME_NONNULL_END
