//
//  ZYUUIDs.m
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/30.
//

#import "ZYUUIDs.h"

@implementation ZYUUIDs

+(NSString *)ZYServiceUUID{
    return @"FEE9";
}
+(NSString *)ZYCharacteristicUUID_Retrieve{
    return @"0000FEE9-0000-1000-8000-00805F9B34FB";
}
+(NSString *)ZYCharacteristicUUID_Write{
    return @"D44BC439-ABFD-45A2-B575-925416129600";
}
+(NSString *)ZYCharacteristicUUID_Read{
    return @"D44BC439-ABFD-45A2-B575-925416129601";
}
@end
