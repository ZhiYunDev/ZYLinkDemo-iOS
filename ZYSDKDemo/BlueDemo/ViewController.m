//
//  ViewController.m
//  FimicSDK
//
//  Created by Liao GJ on 2019/8/5.
//  Copyright © 2019 Liao GJ. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"

//#import "ZYBlueManager.h"
#import <ZYDeviceSDK/ZYDeviceSDK.h>

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<ZYDeviceManagerDelegate,ZYDeviceDelegate>{
    
    NSArray *scanedDevice;
    NSMutableArray *connectionedDevice;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---------");
    [ZYDeviceManager sharedInstance].delegate = self;
    [self reloadData];
    
    //导航右侧菜单
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [navRightBtn setTitle:@"scan" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    [navRightBtn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //导航右侧菜单
    UIButton *navRightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn1 setFrame:CGRectMake(0, 0, 60, 44)];
    [navRightBtn1 setTitle:@"send" forState:UIControlStateNormal];
    [navRightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn1];
    [navRightBtn1 addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    // Do any additional setup after loading the view.
}

-(void)leftClick:(UIButton *)sender{
        NSLog(@"left click");
    if (connectionedDevice.count > 0) {
        if ([connectionedDevice.firstObject isConneted]) {
            [self controlPosition];
        }
        else{
            NSLog(@"设备还没连接上");
        }
    }
}

-(void)navRightBtnClick{
    NSLog(@"scan click");
    [[ZYDeviceManager sharedInstance] scan:ZYDeviceTypeBle];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[ZYDeviceManager sharedInstance] scan:ZYDeviceTypeBle];
    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
}
-(void)reloadData{
    connectionedDevice = [ZYDeviceManager sharedInstance].connectionedDevices;
    scanedDevice = [[ZYDeviceManager sharedInstance] scanedDevices];
 

    [self.tableView reloadData];
}


#pragma mark -table委托 table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return connectionedDevice.count;
    }
    else{
        return scanedDevice.count;
        
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZYDevice *item = nil;
    if (indexPath.section == 0) {
        item = [scanedDevice objectAtIndex:indexPath.row];
    }
    else{
        item = [connectionedDevice objectAtIndex:indexPath.row];

    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    cell.textLabel.text = item.displayName;
    
    if (item.isConneted) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else{
        cell.textLabel.textColor = [UIColor blackColor];
        
    }
    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%ld",(long)item.rssi];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        ZYDevice *item = [connectionedDevice objectAtIndex:indexPath.row];
        [item disConnect];
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"断开连接%@",item.displayName]];
        item.delegate = self;
        
        return;
    }
    else{
        //停止扫描
        [[ZYDeviceManager sharedInstance] cancelScan];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ZYDevice *item = [scanedDevice objectAtIndex:indexPath.row];
        item.delegate = self;
        [item connect];
 

    }
    
}


// 16进制转NSData
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
#pragma -mark ZYDeviceManagerDelegate
-(void)connectStateChange{
    [self reloadData];
}

-(void)onScaned:(ZYDevice *)device{
    [self reloadData];
}

#pragma -mark ZYDeviceDelegate
-(void)onStatusChange:(ZYDevice *)device status:(ZYDeviceStatus)status{
    [self reloadData];
    
    if (status == ZYDeviceStatusCanSendData) {
       if (connectionedDevice.count > 0) {
           //[self controlPosition];
       }
    }
}

-(void)clickedInDevice:(ZYDevice *)device funcEventCodeAndParam:(NSArray *)funcEventArray{
    NSMutableString *mutString = [NSMutableString stringWithFormat:@"%@",[device displayName]];
    for (int i =0; i < funcEventArray.count; i ++) {
        NSDictionary *dic = funcEventArray[i];
        NSString *key = dic.allKeys.firstObject;
        NSString *value = dic[key];

        NSString *funcEventCodeString = [NSString stringWithFormat:@"%lx",(unsigned long)[key integerValue]];
        NSString *funcEventParamString = [NSString stringWithFormat:@"%ld",[value integerValue]];
        NSString *str = [NSString stringWithFormat:@" code: %@  param： %@ ",funcEventCodeString,funcEventParamString];
        NSLog(@"i = %d %@",i,str);
        [mutString appendString:str];
    }
    NSLog(@"%@",mutString);

    [SVProgressHUD showInfoWithStatus:mutString];

}

-(void)clickedInDevice:(ZYDevice *)device funcEventCode:(NSUInteger)funcEventCode funcEventParam:(NSUInteger)funcEventParam{
    NSString *funcEventCodeString = [NSString stringWithFormat:@"%lx",(unsigned long)funcEventCode];
    NSString *funcEventParamString = [NSString stringWithFormat:@"%ld",funcEventParam];
    NSString *str = [NSString stringWithFormat:@"%@ code: %@  param： %@ ",device.displayName,funcEventCodeString,funcEventParamString];
    NSLog(@"%@",str);
    [SVProgressHUD showInfoWithStatus:str];
}

-(void)clickedInDevice:(ZYDevice *)device KeyEvent:(ZYKeyEvent)event keyType:(ZYKeyType)type originalKeyValue:(NSUInteger)originalKeyValue{
    NSString *eventString = [self eventStringWithEvent:event];
    NSString *keyString = [self keyTypeStringWithEvent:type];
    NSString *str = [NSString stringWithFormat:@"%@ 按钮: %@  事件： %@ origionKeyValue = %lx",device.displayName,keyString,eventString,(unsigned long)originalKeyValue];
    NSLog(@"%@",str);
    [SVProgressHUD showInfoWithStatus:str];
    
}

-(void)device:(ZYDevice *)device onModeChanged:(ZYBleDeviceWorkMode)workMode{
    NSString *workModeString = [self workModeStringWithMode:workMode];
    NSString *str = [NSString stringWithFormat:@"%@ 工作模式: %@",device.displayName,workModeString];
    NSLog(@"%@",str);
    [SVProgressHUD showInfoWithStatus:str];
}

-(NSString *)workModeStringWithMode:(ZYBleDeviceWorkMode)workMode{
    switch (workMode) {
        case ZYBleDeviceWorkModeUnkown:
            return @"未知";
        case ZYBleDeviceWorkModeFollow:
            return @"航向跟随模式";
        case ZYBleDeviceWorkModeLock:
            return @"锁定模式";
        case ZYBleDeviceWorkModeFullyFollow:
            return @"全跟随模式";
        case ZYBleDeviceWorkModePOV:
            return @"POV模式";
        case ZYBleDeviceWorkModeGo:
            return @"GO模式";
        case ZYBleDeviceWorkMode360:
            return @"V模式";
        
        default:
            break;
    }

}

-(NSString *)eventStringWithEvent:(ZYKeyEvent)event{
    switch (event) {
        case ZYKeyEventNone:
            return @"无按钮事件类型";
        case ZYKeyEventPressed:
            return @"按钮按下";
        case ZYKeyEventReleased:
            return @"按钮释放";
        case ZYKeyEventClicked:
            return @"按钮按下";
        case ZYKeyEventPress1S:
            return @"按钮按下1s";
        case ZYKeyEventPress3S:
            return @"按钮按下3s";
        case ZYKeyEventPressDoubleClicked:
            return @"按钮双击";
        case ZYKeyEventPressTripleClicked:
            return @"按钮三击";
        default:
            break;
    }
    return @"无按钮事件类型";
    
}

-(NSString *)keyTypeStringWithEvent:(ZYKeyType)type{
    switch (type) {
        case ZYKeyTypeNone:
            return @"没有按钮";
        case ZYKeyTypeUp:
            return @"按钮上";
        case ZYKeyTypeDown:
            return @"按钮下";
        case ZYKeyTypeMode:
            return @"模式按钮";
        case ZYKeyTypeLeft:
            return @"按钮左";
        case ZYKeyTypeRight:
            return @"按钮右";
        case ZYKeyTypePhotos:
            return @"拍照按钮";
        case ZYKeyTypeT:
            return @"t按钮";
        case ZYKeyTypeW:
            return @"w按钮";
        case ZYKeyTypeCW:
            return @"cw按钮";
        case ZYKeyTypeCCW:
            return @"ccw按钮";
        case ZYKeyTypeFN:
            return @"fn按钮";
        case ZYKeyTypeMENU:
            return @"MenuAndBack按钮";
        case ZYKeyTypeDISP:
            return @"DISP按钮";
        case ZYKeyTypeFLashOK:
            return @"flashOK按钮";
        case ZYKeyTypeSwitch:
            return @"switch按钮";
        case ZYKeyTypeRecord:
            return @"Record按钮";
        case ZYKeyTypeSIDE_CW:
            return @"side_CW按钮";
        case ZYKeyTypeSIDE_CCW:
            return @"side_CCW按钮";
        case ZYKeyTypeFocus_Down:
            return @"Focus_Down按钮";
        case ZYKeyTypeFocus_Up:
            return @"Focus_Up按钮";
        case ZYKeyTypeZoom_Down:
            return @"Zoom_Down按钮";
        case ZYKeyTypeZoom_Up:
            return @"Zoom_Up按钮";
        case ZYKeyTypeCapture:
            return @"Capture按钮";
        case ZYKeyTypeFN_Down:
            return @"fn_down按钮";
        case ZYKeyTypePhoto:
            return @"photo按钮";
        default:
            break;
    }
    return @"没有按钮";
}

//work with Crane M2
-(void) setPhoneMode {
    NSData *data = [self convertHexStrToData:@"243c05001818090001a316"];
    [connectionedDevice.firstObject writeData:data];
}

//work with Crane M2
-(void) setCameraMode {
    NSData *data = [self convertHexStrToData:@"243c050018180900008206"];
    [connectionedDevice.firstObject writeData:data];
}

//work with Smooth X
-(void) controlSpeed {
    NSData *data = [self convertHexStrToData:@"243c0b00181c02000800080010c800220f"];
    [connectionedDevice.firstObject writeData:data];
}

//work with Smooth X
-(void) controlPosition {
    NSData *data = [self convertHexStrToData:@"243c0b00181c0100000000b80bc8006674"];
    [connectionedDevice.firstObject writeData:data];
}

@end
