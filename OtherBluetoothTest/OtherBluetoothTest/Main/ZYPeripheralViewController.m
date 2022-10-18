//
//  ZYPeripheralViewController.m
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import "ZYPeripheralViewController.h"
#import "ZYPeripheralInfo.h"
#import <BabyBluetooth/BabyBluetooth.h>
#import "ZYOtherDevice.h"
#import "ZYOtherBlueToothTools.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ZYUUIDs.h"
#define channelOnPeropheralView @"peripheralView"

@interface ZYPeripheralViewController ()<UITableViewDelegate, UITableViewDataSource, ZYDeviceDelegate>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * services;
@end

@implementation ZYPeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.device.peripheral.name;
    [SVProgressHUD showWithStatus:@"正在连接...."];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
    [self.view addSubview:self.tableView];
    [self babyDelegate];
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction:)];
    self.navigationItem.rightBarButtonItem = bar;
}
-(void)loadData{
    self.babytooth.having(self.device.peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

- (void)sendAction:(UIBarButtonItem *)iten{
    
    //给非智云设备发送示例
    NSData * data = [self convertHexStrToData:@"243e0c00181508200000000000000000"];
//    [self writeValue:ZYUUIDs.ZYServiceUUID characteristicUUID:ZYUUIDs.ZYCharacteristicUUID_Write data:data withPeripheral:self.device.peripheral];
    [self.device.device writeData:data needAddCrc:YES];
////    测试示例(智云设备)
//    [self.device.device queryCurrectAxisesPosition:^(float pitch, float roll, float yaw, BOOL success) {
//        NSLog(@"pitch = %f roll = %f yaw = %f,success = %d",pitch,roll,yaw,success);
//        [self.device.device moveToPitch:pitch roll:roll yaw:yaw + 10 withInTime:2 compeletion:^(BOOL success) {
//            NSLog(@"------%d",success);
//        }];
//    }];
}

/// 写入数据的操作
/// @param serviceUUID 当前设备可进行写入操作的服务ID
/// @param characteristicUUID 当前设备可进行写入操作的特征值ID
/// @param data 传输的数据
/// @param cb 当前连接的蓝牙外设
- (void)writeValue:(NSString*)serviceUUID characteristicUUID:(NSString*)characteristicUUID data:(NSData *)data withPeripheral:(CBPeripheral *)cb{
    CBService *service = [ZYOtherBlueToothTools findServiceFromUUID:serviceUUID peripheral:cb];
    if (!service) {
        return;
    }
    CBCharacteristic *characteristic = [ZYOtherBlueToothTools findCharacteristicFromUUID:characteristicUUID service:service];
    if (!characteristic) {
        return;
    }
    [cb writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}
//赋值ZYDevice 绑定ZYDevice的协议
- (void)registeredWithDescriptor:(CBDescriptor *)descriptor{//如果是Retrieve方法进来的需提交descriptor否则不需要
    typeof(self) __unsafe_unretained weakSelf = self;
    if (!self.device.isRetrieve) {
        [self.device.device setSendDataBlock:^(NSData *data) {
            NSLog(@"data ---- %@", data);
            if (data) {
                [weakSelf writeValue:ZYUUIDs.ZYServiceUUID characteristicUUID:ZYUUIDs.ZYCharacteristicUUID_Write data:data withPeripheral:weakSelf.device.peripheral];
            }
        }];
        self.device.device.delegate = self;
    }else{
        ZYDevice * device = [ZYDevice initWithType:ZYDeviceTypeBle needMessage:descriptor.value identifier:self.device.peripheral.identifier.UUIDString];
        if (device) {
            [device setSendDataBlock:^(NSData *data) {
                NSLog(@"---%@",data);
                if (data) {
                    [weakSelf writeValue:ZYUUIDs.ZYServiceUUID characteristicUUID:ZYUUIDs.ZYCharacteristicUUID_Write data:data withPeripheral:weakSelf.device.peripheral];
                }
            }];
            weakSelf.device.device = device;
            weakSelf.device.device.delegate = weakSelf;
        }
    }
}
//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [self.babytooth setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        [weakSelf registeredWithDescriptor:nil];
        
    }];
    //设置设备连接失败的委托
    [self.babytooth setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败\r\n 原因:%@",peripheral.name, error]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
    //设置设备断开连接的委托
    [self.babytooth setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开连接",peripheral.name]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
    //设置发现设备的Services的委托
    [self.babytooth setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];
        }
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [self.babytooth setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
    }];
    //设置读取characteristics的委托(接收数据的通道)
    [self.babytooth setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //接收数据的通道
        if (weakSelf.device.device) {
            if ([characteristics.UUID.UUIDString isEqualToString:ZYUUIDs.ZYCharacteristicUUID_Read]) {//指定智云设备特征值读取通道读取数据
                [weakSelf.device.device reciveData:characteristics.value];
            }
        }
        NSLog(@"接收数据:characteristic name:%@ value is:%@",characteristics.UUID.UUIDString,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [self.babytooth setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
    }];
    //设置读取Descriptor的委托
    [self.babytooth setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        [weakSelf registeredWithDescriptor:descriptor];
    }];
    
    //读取rssi的委托
    [self.babytooth setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
//        if (<#condition#>) {
//            [bry beatsOver];
//        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提示
    */
     NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    [self.babytooth setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
//
}

#pragma mark -插入table数据
-(void)insertSectionToTableView:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    ZYPeripheralInfo *info = [ZYPeripheralInfo new];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
    
-(void)insertRowToTableView:(CBService *)service{//插入并开启通知
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        ZYPeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        ZYPeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
            [self.device.peripheral setNotifyValue:YES forCharacteristic:c];
        }
        ZYPeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    }
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.services.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZYPeripheralInfo *info = [self.services objectAtIndex:section];
    return [info.characteristics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBCharacteristic *characteristic = [[[self.services objectAtIndex:indexPath.section] characteristics]objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"characteristicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID];
    cell.detailTextLabel.text = characteristic.description;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)services{
    if (!_services) {
        _services = [NSMutableArray new];
    }
    return _services;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - ZYDeviceDelegate
- (void)clickedInDevice:(ZYDevice *)device KeyEvent:(ZYKeyEvent)event keyType:(ZYKeyType)type originalKeyValue:(NSUInteger)originalKeyValue{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"device = %@ \r\n event = %@  \r\n type = %@ \r\n originalKeyValue = %lu", device, [self getEvent:event], [self getKeyType:type], (unsigned long)originalKeyValue]];
}
- (NSString *)getEvent:(ZYKeyEvent)event{
    NSString * eventStr;
    switch (event) {
        case ZYKeyEventNone:eventStr= @"ZYKeyEventNone";break;
        case ZYKeyEventPressed:eventStr= @"ZYKeyEventPressed";break;
        case ZYKeyEventReleased:eventStr= @"ZYKeyEventReleased";break;
        case ZYKeyEventClicked:eventStr= @"ZYKeyEventClicked";break;
        case ZYKeyEventPress1S:eventStr= @"ZYKeyEventPress1S";break;
        case ZYKeyEventPress3S:eventStr= @"ZYKeyEventPress3S";break;
        case ZYKeyEventPressDoubleClicked:eventStr= @"ZYKeyEventPressDoubleClicked";break;
        case ZYKeyEventPressTripleClicked:eventStr= @"ZYKeyEventPressTripleClicked";break;
        default:
            break;
    }
    return eventStr;
}
- (NSString *)getKeyType:(ZYKeyType)keyType{
    NSString * keyTypeStr;
    switch (keyType) {
        case ZYKeyTypeNone:keyTypeStr = @"keyTypeStr";break;
        case ZYKeyTypeUp:keyTypeStr = @"ZYKeyTypeUp";break;
        case ZYKeyTypeDown:keyTypeStr = @"ZYKeyTypeDown";break;
        case ZYKeyTypeMode:keyTypeStr = @"ZYKeyTypeMode";break;
        case ZYKeyTypeLeft:keyTypeStr = @"ZYKeyTypeLeft";break;
        case ZYKeyTypeRight:keyTypeStr = @"ZYKeyTypeRight";break;
        case ZYKeyTypePhotos:keyTypeStr = @"ZYKeyTypePhotos";break;
        case ZYKeyTypeT:keyTypeStr = @"ZYKeyTypeT";break;
        case ZYKeyTypeW:keyTypeStr = @"ZYKeyTypeW";break;
        case ZYKeyTypeCW:keyTypeStr = @"ZYKeyTypeCW";break;
        case ZYKeyTypeCCW:keyTypeStr = @"ZYKeyTypeCCW";break;
        case ZYKeyTypeFN:keyTypeStr = @"ZYKeyTypeFN";break;
        case ZYKeyTypeMENU:keyTypeStr = @"ZYKeyTypeMENU";break;
        case ZYKeyTypeDISP:keyTypeStr = @"ZYKeyTypeDISP";break;
        case ZYKeyTypeFLashOK:keyTypeStr = @"ZYKeyTypeFLashOK";break;
        case ZYKeyTypeSwitch:keyTypeStr = @"ZYKeyTypeSwitch";break;
        case ZYKeyTypeRecord:keyTypeStr = @"ZYKeyTypeRecord";break;
        case ZYKeyTypeSIDE_CW:keyTypeStr = @"ZYKeyTypeSIDE_CW";break;
        case ZYKeyTypeSIDE_CCW:keyTypeStr = @"ZYKeyTypeSIDE_CCW";break;
        case ZYKeyTypeZoom_Up:keyTypeStr = @"ZYKeyTypeZoom_Up";break;
        case ZYKeyTypeZoom_Down:keyTypeStr = @"ZYKeyTypeZoom_Down";break;
        case ZYKeyTypeFocus_Up:keyTypeStr = @"ZYKeyTypeFocus_Up";break;
        case ZYKeyTypeFocus_Down:keyTypeStr = @"ZYKeyTypeFocus_Down";break;
        case ZYKeyTypeCapture:keyTypeStr = @"ZYKeyTypeCapture";break;
        case ZYKeyTypeFN_Down:keyTypeStr = @"ZYKeyTypeFN_Down";break;
        case ZYKeyTypePhoto:keyTypeStr = @"ZYKeyTypePhoto";break;
        default:
            break;
    }
    return keyTypeStr;
}
@end
