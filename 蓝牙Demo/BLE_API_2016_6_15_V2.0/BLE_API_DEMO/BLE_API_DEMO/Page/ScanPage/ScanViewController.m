//
//  ScanViewController.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ScanViewController.h"
#import "DeviceInfoCell.h"
#import "DeviceInfo.h"
#import "BLEManager.h"
#import "DeviceInfoManager.h"
#import "AlertView.h"

@interface ScanViewController () <UITableViewDataSource,UITableViewDelegate,BLEManagerDelegate> {
    BLEManager* _bleManager;
    DeviceInfoManager* _deviceInfoManager;
    NSMutableArray* _deviceArray;
    NSTimer* _scanTimer;
    NSInteger* _scnaID;
    UIActivityIndicatorView* _activityIndicatorView;
    NSTimer* _connectTimer;
    NSInteger a;
}
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
    [self createData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self stopScan];
    _bleManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)settingView {
    self.navigationItem.title = @"new_HY_BLE";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    _scanButton.layer.cornerRadius = 5;
    _scanButton.layer.borderWidth = 0.5;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加密" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButton)];
}

- (void)clickRightBarButton {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"加密"]) {
        _bleManager.isEncryption = NO;
        self.navigationItem.rightBarButtonItem.title = @"不加密";
    } else {
        _bleManager.isEncryption = YES;
        self.navigationItem.rightBarButtonItem.title = @"加密";
    }
}

- (void)createData {
    a = 0;
    _bleManager = [BLEManager defaultManager];
    _bleManager.delegate = self;
    _deviceInfoManager = [DeviceInfoManager defaultManager];
    _deviceArray = [[NSMutableArray alloc] init];
    [self performSelector:@selector(scan) withObject:nil afterDelay:1.0f];
//    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(connect) userInfo:nil repeats:YES];
}

- (void)connect {
    if ( a >= _deviceArray.count) {
        a = 0;
    }
    if (_deviceArray.count > 0) {
        DeviceInfo* info = _deviceArray[a];
        CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
        if (![_bleManager readDeviceIsConnect:cb]) {
            [_bleManager connectToDevice:cb];
        }
    }
}

- (void)settingScanButton {
    if ([_scanButton.titleLabel.text isEqualToString:@"STOP"]) {
        [_scanButton setTitle:@"SCAN" forState:UIControlStateNormal];
        [self stopScan];
    }
}

/**搜索设备*/
- (void)scan {
    [self performSelector:@selector(settingScanButton) withObject:nil afterDelay:10.0f];
    [_scanButton setTitle:@"STOP" forState:UIControlStateNormal];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.color = [UIColor grayColor];
    _activityIndicatorView.center = self.view.center;
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [_bleManager scanDeviceTime:10];
}

/**停止搜索*/
- (void)stopScan {
    [_bleManager manualStopScanDevice];
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView hidesWhenStopped];
}

- (IBAction)clickScanButton:(id)sender {
    if ([_scanButton.titleLabel.text isEqualToString:@"STOP"]) {
        [self stopScan];
        [_scanButton setTitle:@"SCAN" forState:UIControlStateNormal];
    } else {
        [self scan];
        [_scanButton setTitle:@"STOP" forState:UIControlStateNormal];
    }
}

#pragma mark - UItableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deviceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceInfoCell" owner:self options:nil] lastObject];
    }
    DeviceInfo* info = _deviceArray[indexPath.row];
    cell.deviceNameLabel.text =info.name;
    cell.deviceMacLabel.text = info.macAddrss;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopScan];
    
    DeviceInfo* info = _deviceArray[indexPath.row];
    CBPeripheral* device = [_bleManager getDeviceByUUID:info.UUIDString];
    NSArray* array = [_deviceInfoManager findDeviceInfo];
    BOOL isSave = NO;
    for (DeviceInfo* saveInfo in array) {
        if ([saveInfo.UUIDString isEqualToString:info.UUIDString]) {
            isSave = YES;
            break;
        }
    }
    if (isSave == NO) {
        [_deviceInfoManager synchroniedDeviceInfoWithDeviceInfo:info];
    }
    [_bleManager connectToDevice:device];
}

#pragma mark - BLeManager Delegate
- (void)scanDeviceRefrash:(NSMutableArray *)array {
    [_deviceArray removeAllObjects];
    for (DeviceInfo* info in array) {
        if (![_deviceArray containsObject:info]) {
            [_deviceArray addObject:info];
        }
    }
    [_deviceTableView reloadData];
}

- (void)connectDeviceSuccess:(CBPeripheral *)device error:(NSError *)error {
    AlertView* view = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] lastObject];
    NSString* string = nil;
    for (DeviceInfo* info in _deviceArray) {
        if ([info.UUIDString isEqualToString:device.identifier.UUIDString]) {
            string = info.macAddrss;
            break;
        }
    }
    [view showViewWith:[NSString stringWithFormat:@"%@ 已连接",string]];
    [[BLEManager defaultManager] enableNotify2000ServiceDevice:device withcharacteristicUUID:0x2005];
    [[BLEManager defaultManager] sendData:@"F041" to2000ServiceDevice:device WithCharacteristic:0x2005 responseState:NO];
}

- (void)didDisconnectDevice:(CBPeripheral *)device error:(NSError *)error {
    AlertView* view = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] lastObject];
    NSString* string = nil;
    for (DeviceInfo* info in _deviceArray) {
        if ([info.UUIDString isEqualToString:device.identifier.UUIDString]) {
            string = info.macAddrss;
            break;
        }
    }
    [view showViewWith:[NSString stringWithFormat:@"%@ 断开连接",string]];
}

- (void)receiveData:(NSData *)data with2000ServiceDevice:(CBPeripheral *)cb withCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"%@",data);
}

@end
