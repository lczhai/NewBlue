//
//  ConnectViewController.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ConnectViewController.h"
#import "ConnectDeviceInfoCell.h"
#import "OadViewController.h"

#import "InfoViewController.h"
#import "DeviceInfoManager.h"
#import "HomePageViewController.h"
#import "BLEManager.h"

@interface ConnectViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BLEManagerDelegate,ConnectDeviceInfoCellDelegate> {
    NSMutableArray* _connectDeviceArray;
    NSMutableArray* _selectedDeviceArray;//保存选中的设备信息的数组
    BLEManager* _bleManager;
    NSMutableArray* _dataArray;
    
    
    int sendCount;//发送计数
    NSString *sendString;
    BOOL zongkaiguan;
    BOOL zhendongkaiguan;
    BOOL jiarekaiguan;
}
@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
    
    
    
    
    
    zongkaiguan = NO;
    zhendongkaiguan = NO;
    jiarekaiguan = NO;
    [self setControlButton];
    
    
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    _connectDeviceArray = [[NSMutableArray alloc] init];
    _selectedDeviceArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _bleManager = [BLEManager defaultManager];
    [self createData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self createData];
    _bleManager.delegate = self;
    [self showRightTabbar:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createData {
    [_connectDeviceArray removeAllObjects];
    [_selectedDeviceArray removeAllObjects];
    [_dataArray removeAllObjects];
    NSMutableArray* tempArray = [[DeviceInfoManager defaultManager] findDeviceInfo];
    for (DeviceInfo* info in tempArray) {
        CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
        if ([_bleManager readDeviceIsConnect:cb]) {
            [_connectDeviceArray addObject:info];
            [_dataArray addObject:@"no data"];
        }
    }
    [_selectedDeviceArray addObjectsFromArray:_connectDeviceArray];
    [_tableView reloadData];
}

- (void)settingView {
    self.navigationItem.title = @"new_HY_BLE";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    _dataTextField.delegate = self;
    _sendDataButton.layer.cornerRadius = 3;
    _sendDataButton.clipsToBounds = YES;
    _sendDataButton.layer.borderWidth = 0.5;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
   [UIView animateWithDuration:1.5f animations:^{
       CGRect frame = self.view.frame;
       frame.origin.y = -keyBoardFrame.size.height;
       self.view.frame = frame;
   }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_dataTextField resignFirstResponder];
    return YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [UIView animateWithDuration:1.5f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}










- (IBAction)clickSendDataButton:(id)sender {
    [_dataTextField resignFirstResponder];
    [UIView animateWithDuration:1.5f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
    
    NSString* string = _dataTextField.text;
    NSLog(@"%@",string);
    if (string.length == 0) {
        return;
    }
    if (string.length % 2 != 0 ) {
        string = [NSString stringWithFormat:@"%@0",string];
    }
    for (DeviceInfo* info in _selectedDeviceArray) {
        CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
        
        
        
        [_bleManager sendDataToDevice1:string device:cb];
    }
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _connectDeviceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnectDeviceInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConnectDeviceInfoCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    DeviceInfo* info = _connectDeviceArray[indexPath.row];
    if ([_selectedDeviceArray containsObject:info]) {
        cell.selectedButton.selected = YES;
    } else {
        cell.selectedButton.selected = NO;
    }
    CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
    if ([_bleManager readDeviceIsConnect:cb]) {
        [_bleManager readDeviceRSSI:cb getRssiBlock:^(NSNumber *RSSI) {
            info.RSSI = [RSSI integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.rssiNumberLabel.text = [NSString stringWithFormat:@"%d",[RSSI intValue]];
            });
        }];
    }
    if ([_bleManager judgeCanOADWith:cb]) {
        cell.oadButton.hidden = NO;
    } else {
        cell.oadButton.hidden = YES;
    }
    cell.index = indexPath.row;
    cell.deviceNameLabel.text = info.name;
    cell.deviceUUIDLabel.text = info.macAddrss;
    NSString* data = _dataArray[indexPath.row];
    cell.recieveDataLabel.text = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hidenRightTabbar:self];
    InfoViewController* VC= [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    DeviceInfo* info = _connectDeviceArray[indexPath.row];
    VC.info = info;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma BleManager Delegate
- (void)receiveDeviceDataSuccess_1:(NSData *)data device:(CBPeripheral *)device {
    
    
    NSLog(@"返回data：%@",data);
    
    
    Byte* byte = (Byte*)[data bytes];
    NSString* string = @"";
    for (int i = 0; i < data.length; i++) {
        NSString* string1 = [NSString stringWithFormat:@"%X",byte[i]];
        if (string1.length == 1) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"0%@",string1]];
        } else {
            string = [string stringByAppendingString:string1];
        }
    }
    NSLog(@"返回字符串：%@",string);
    for (int i = 0 ; i < _selectedDeviceArray.count; i++) {
        DeviceInfo* info = _selectedDeviceArray[i];
        if ([info.UUIDString isEqualToString:device.identifier.UUIDString]) {
            [_dataArray replaceObjectAtIndex:i withObject:string];
        }
    }
    [_tableView reloadData];
}

- (void)showRightTabbar:(UIViewController *)vc {
    UINavigationController* nc = (UINavigationController*)vc.parentViewController;
    HomePageViewController* rc = (HomePageViewController*)nc.parentViewController;
    rc.tabBar.hidden = NO;
}

- (void)hidenRightTabbar:(UIViewController*)vc {
    UINavigationController* nc = (UINavigationController*)vc.parentViewController;
    HomePageViewController* rvc = (HomePageViewController*)nc.parentViewController;
    rvc.tabBar.hidden = YES;
}

#pragma mark - ConnectDeviceInfoCellDelegate
- (void)enterOadPageWithIndex:(NSInteger)index {
    [self hidenRightTabbar:self];
    DeviceInfo* info = _connectDeviceArray[index];
    CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
    _bleManager.oadPeripheral = cb;
    
    OadViewController* vc = [[OadViewController alloc] initWithNibName:@"OadViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --设置控制按钮
- (void)setControlButton
{

    
    
    UISwitch *zongSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(10, 200, 50, 30)];
    [self.view addSubview:zongSwitch];
    zongSwitch.on = NO;
    [zongSwitch addTarget:self action:@selector(zongSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    UISwitch *zhendongSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(100, 200, 50, 30)];
    [self.view addSubview:zhendongSwitch];
    zhendongSwitch.on = NO;
    [zhendongSwitch addTarget:self action:@selector(zhendongSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    UISwitch *jiareSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(170, 200, 50, 30)];
    [self.view addSubview:jiareSwitch];
    jiareSwitch.on = NO;
    [jiareSwitch addTarget:self action:@selector(jiareSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UISlider *zhendongSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 240, 200, 20)];
    zhendongSlider.minimumValue = 0;
    zhendongSlider.maximumValue = 10;
    zhendongSlider.value = 0;
    [self.view addSubview:zhendongSlider];
    [zhendongSlider addTarget:self action:@selector(zhendongSlider:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UISlider *wenduSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 280, 200, 20)];
    wenduSlider.minimumValue = 35;
    wenduSlider.maximumValue = 42;
    wenduSlider.value = 0;
    [self.view addSubview:wenduSlider];
    [wenduSlider addTarget:self action:@selector(wenduSlider:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    UISlider *zhendongModel = [[UISlider alloc]initWithFrame:CGRectMake(10, 350, 200, 20)];
    zhendongModel.minimumValue = 10;
    zhendongModel.maximumValue = 20;
    zhendongModel.value = 0;
    [self.view addSubview:zhendongModel];
    [zhendongModel addTarget:self action:@selector(zhendongModel:) forControlEvents:UIControlEventValueChanged];
    

    
    
    

}


//震动模式
- (void)zhendongModel:(UISlider *)slider
{
    int modelIndex = slider.value/1;
    NSString * zhendongString = [NSString stringWithFormat:@"55AA0200030000%@%@",[self ToHex:modelIndex],[self ToHex:modelIndex+4]];//    55 AA 02 00 03 00 00 model Check

    NSLog(@"震动模式：%@",zhendongString);
    [self sendValueToBra:zhendongString];

}

//温度设置
- (void)wenduSlider:(UISlider *)selder
{
    int modelIndex = selder.value/1;
    NSString * zhendongString = [NSString stringWithFormat:@"55AA0200010000%@%@",[self ToHex:modelIndex],[self ToHex:modelIndex+2]];
    NSLog(@"加热强度：%@",zhendongString);
    [self sendValueToBra:zhendongString];

}

//震动强度
- (void)zhendongSlider:(UISlider *)slider
{
    int modelIndex = slider.value/1;
    NSString * zhendongString = [NSString stringWithFormat:@"55AA0200020000%@%@",[self ToHex:modelIndex],[self ToHex:modelIndex+3]];
    NSLog(@"震动强度：%@",zhendongString);     //55 AA 02 00 03 00 00 model Check
    [self sendValueToBra:zhendongString];
    
}
- (void)zongSwitch:(UISwitch *)swt
{
    if (swt.on) {
        NSLog(@"总开关开");
        sendString = @"55AA01000100000102";

    }
    else
    {
        NSLog(@"总开关闭");
        sendString = @"55aa01000100000001";

    }
    
    [self sendValueToBra:sendString];

    
}


- (void)zhendongSwitch:(UISwitch *)swt
{
    if (swt.on) {
        NSLog(@"震动开关开");
        sendString = @"55aa01000200010003";
        
//        55 AA 01 00 02 heat Vib 00 Check
//        55aa01000200010003

    }
    else
    {
        NSLog(@"震动开关闭");
        sendString = @"55aa01000200000002";

    }
    
    [self sendValueToBra:sendString];

    
}

- (void)jiareSwitch:(UISwitch *)swt
{
    if (swt.on) {
        NSLog(@"加热开关开");
        sendString = @"55aa01000201000003";
        
      

    }
    else
    {
        NSLog(@"加热开关闭");
        sendString = @"55aa01000200000002";

    }
    
    [self sendValueToBra:sendString];
    
}



- (void)sendValueToBra:(NSString *)string
{
    
    NSLog(@"%@",string);
    if (string.length == 0) {
        return;
    }
    if (string.length % 2 != 0 ) {
        string = [NSString stringWithFormat:@"%@0",string];
    }
    for (DeviceInfo* info in _selectedDeviceArray) {
        CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
        
        
        
        [_bleManager sendDataToDevice1:string device:cb];
    }
}




//转16进制
-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lld",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }
    
    if (str.length == 1) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;  
}
@end

