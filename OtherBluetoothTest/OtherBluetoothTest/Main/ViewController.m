//
//  ViewController.m
//  OtherBluetoothTest
//
//  Created by 黄品源 on 2020/11/27.
//

#import "ViewController.h"
#import <BabyBluetooth/BabyBluetooth.h>
#import "ZYOtherDevice.h"
#import "ZYPeripheralViewController.h"
#import <SVProgressHUD.h>
#import "ZYUUIDs.h"

/*
 如果出现HUD不居中或者崩溃情况，请将SVProgressHUD.m第638行中
 "self.frame = [[[UIApplication sharedApplication] delegate] window].bounds;"
 改为
 "self.frame= [UIApplication sharedApplication].keyWindow.bounds;"
 */

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)BabyBluetooth * babytooth;
@property (nonatomic, strong)NSMutableArray * dataArray;//列表数据
@property (nonatomic, strong)UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙列表";
    [self.view addSubview:self.tableView];
    [self retrievePeripheral];
    [self babyDelegate];
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(updateAction:)];
    self.navigationItem.rightBarButtonItem = bar;
}
- (void)updateAction:(UIBarButtonItem *)item{
    [self updatePeripherals];
}
- (void)updatePeripherals{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.babytooth cancelAllPeripheralsConnection];
    self.babytooth.scanForPeripherals().begin().stop(30);
}
- (void)retrievePeripheral{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CBUUID *uuid = [CBUUID UUIDWithString:ZYUUIDs.ZYServiceUUID];//智云设备的服务id
        CBUUID *uuid1 = [CBUUID UUIDWithString:ZYUUIDs.ZYCharacteristicUUID_Retrieve];
        NSArray *array = [self.babytooth.centralManager retrieveConnectedPeripheralsWithServices:@[uuid,uuid1]];
        if (array.count > 0) {
            for (CBPeripheral *cb in array) {
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count inSection:0];
                [indexPaths addObject:indexPath];
                ZYOtherDevice * device = [ZYOtherDevice new];
                device.peripheral = cb;
                device.isRetrieve = YES;
                [self.dataArray addObject:device];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    });
}
- (void)babyDelegate{
    typeof(self) __unsafe_unretained weakSelf = self;
    //判断蓝牙是否开启
    [self.babytooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备已打开, 开始扫描"];
        }
    }];
    //设置扫描到设备的委托回调
    [self.babytooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"扫描到的设备名称 : %@ \r\n 广播数据 : %@", peripheral.name, advertisementData);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    //设置发现service的特征值委托回调
    [self.babytooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
    }];
    //设置读取characteristics的委托回调
    [self.babytooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
    }];
    //设置发现characteristics的descriptors的委托回调
    [self.babytooth setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
    }];
    //设置读取descriptors的委托回调
    [self.babytooth setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
    }];
    //设置查找设备的过滤器(设置过滤条件，分别可以从peripheralName，和advertisementData以及RSSI强度去进行筛选过滤)
    [self.babytooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheralName.length > 0) {
            return YES;
        }
        return NO;
    }];
    [self.babytooth setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
       
    [self.babytooth setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [self.babytooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

#pragma mark - tableView
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSArray *peripherals = [self.dataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        ZYOtherDevice * device = [ZYOtherDevice new];
        device.RSSI = RSSI;
        device.advertisementData = advertisementData;
        device.peripheral = peripheral;
        device.device = [ZYDevice initWithType:ZYDeviceTypeBle needMessage:advertisementData identifier:peripheral.identifier.UUIDString];
        [self.dataArray addObject:device];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZYOtherDevice * device = [self.dataArray objectAtIndex:indexPath.row];
    CBPeripheral * peripheral = device.peripheral;
    NSDictionary * advertisementData = device.advertisementData;
    NSNumber *RSSI = device.RSSI;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    cell.textLabel.text = peripheralName;
    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.babytooth cancelScan];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZYPeripheralViewController *vc = [[ZYPeripheralViewController alloc]init];
    ZYOtherDevice * device =  [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"peripheralName = %@", device.peripheralName);
    vc.device = device;
    vc.babytooth = self.babytooth;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (BabyBluetooth *)babytooth{
    if (!_babytooth) {
        _babytooth = [BabyBluetooth shareBabyBluetooth];
    }
    return _babytooth;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
    [self updatePeripherals];
}
@end
