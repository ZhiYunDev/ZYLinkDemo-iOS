#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BabyBluetooth.h"
#import "BabyCallback.h"
#import "BabyCentralManager.h"
#import "BabyDefine.h"
#import "BabyOptions.h"
#import "BabyPeripheralManager.h"
#import "BabyRhythm.h"
#import "BabySpeaker.h"
#import "BabyToy.h"

FOUNDATION_EXPORT double BabyBluetoothVersionNumber;
FOUNDATION_EXPORT const unsigned char BabyBluetoothVersionString[];

