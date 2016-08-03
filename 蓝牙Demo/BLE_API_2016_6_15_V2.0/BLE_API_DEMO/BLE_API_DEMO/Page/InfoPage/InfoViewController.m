//
//  InfoViewController.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "InfoViewController.h"
#import "BLEManager.h"

@interface InfoViewController () <BLEManagerDelegate,UITextFieldDelegate> {
    BLEManager* _bleManager;
    NSTimer* rssiTimer;
}
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self settingView];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
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
    [_advDisTextField resignFirstResponder];
    [_connectDisTextField resignFirstResponder];
    return YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [UIView animateWithDuration:1.5f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createData {
    _advDisTextField.delegate = self;
    _connectDisTextField.delegate = self;
    _bleManager = [BLEManager defaultManager];
    _bleManager.delegate = self;
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getRSSI) userInfo:nil repeats:YES];
}

- (void)getRSSI {
    CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
    [_bleManager readDeviceRSSI:cb getRssiBlock:^(NSNumber *RSSI) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _rssiNumLabel.text = [NSString stringWithFormat:@"%d",[RSSI intValue]];
        });
    }];
}

- (void)settingView {
    _deviceNameLabel.text = _info.name;
    _macLabel.text = _info.macAddrss;
    _deviceNameButton.layer.borderWidth = 0.5;
    _editButton.layer.borderWidth = 0.5;
    _powerButton.layer.borderWidth = 0.5;
    _readAdvDisButton.layer.borderWidth = 0.5;
    _setAdvDisButton.layer.borderWidth = 0.5;
    _readConnectDisButton.layer.borderWidth = 0.5;
    _setConnectDisButton.layer.borderWidth = 0.5;
}

- (IBAction)readDeviceName:(id)sender {
    CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
    [_bleManager readDeviceSettingName:cb];
}

- (void)receiveDeviceSettingName:(NSString *)name device:(CBPeripheral *)device {
    _showDevicelNameLabel.text = name;
}

- (IBAction)readEditInfo:(id)sender {
    CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
    [_bleManager readDeviceVersion:cb];
}

- (void)receiveDeviceVersion:(NSString *)version device:(CBPeripheral *)device {
    _showEditLabel.text = version;
}

- (IBAction)readPower:(id)sender {
    CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
    [_bleManager readDeviceBattery:cb];
}

- (void)receiveDeviceBattery:(NSInteger)battery device:(CBPeripheral *)device {
    _showPowerLabel.text = [NSString stringWithFormat:@"%ld",(long)battery];
}

- (IBAction)readAdvDis:(id)sender {
    CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
    [_bleManager readDeviceAdvertInterval:cb];
}

- (void)receiveDeviceAdvertInterval:(NSInteger)interval device:(CBPeripheral *)device {
    _showAdvDisLabel.text = [NSString stringWithFormat:@"%ld",(long)interval];
}

- (IBAction)setAdvDis:(id)sender {
    NSString* string = _advDisTextField.text;
    int a = [string intValue];
    if (a >= 32 && a <= 24000) {
        CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
        [_bleManager setDeviceAdvertDistanceData:string device:cb];
    }
}

- (IBAction)readConnectAdv:(id)sender {
    CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
    [_bleManager readDeviceConnectInterval:cb];
}

-(void)receiveDeviceConnectInterval:(NSInteger)interval device:(CBPeripheral *)device{
    _showConnectDisLabel.text = [NSString stringWithFormat:@"%ld",(long)interval];
}

- (IBAction)setConnectDis:(id)sender {
    NSString* string = _connectDisTextField.text;
    int a = [string intValue];
    if (a >= 16 && a <= 3200) {
        CBPeripheral* cb = [_bleManager getDeviceByUUID:_info.UUIDString];
        [_bleManager setDeviceConnectDistanceData:string device:cb];
    }
}

@end
