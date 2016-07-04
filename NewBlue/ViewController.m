//
//  ViewController.m
//  NewBlue
//
//  Created by shining3d on 16/7/4.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import "ViewController.h"
#import "BLE/BLEManager.h"
#import "DeviceInfo.h"

#import "SVProgressHUD.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,BLEManagerDelegate>

@end

@implementation ViewController
{
	BLEManager* _bleManager;//蓝牙管理
	UITableView *blueTableView;
	NSMutableArray *blueNameDataSource;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"bluelist";
    
    
    _bleManager = [BLEManager defaultManager];//初始化蓝牙管理实例对象
    _bleManager.delegate = self;//遵循协议

    
	//设置tableview
	[self setTableView];
	
    
    //搜索蓝牙
    [self performSelector:@selector(scanBlueToothEquipment) withObject:nil afterDelay:0.1f];

    
    
}



#pragma mark --设置tableview
- (void)setTableView
{
	blueTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
	blueTableView.delegate = self;
	blueTableView.dataSource = self;
	blueTableView.tableFooterView = [[UIView alloc]init];
	[self.view addSubview:blueTableView];
	//让底部不被遮挡
	blueTableView.autoresizingMask  = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	//初始化数据源
	blueNameDataSource = [[NSMutableArray alloc]init];
    
	
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return blueNameDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	}
	
	
	DeviceInfo *info = blueNameDataSource[indexPath.row];
	cell.textLabel.text = info.name;
	cell.detailTextLabel.text = info.macAddrss;
	
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}


#pragma mark --进入搜索蓝牙状态
- (void)scanBlueToothEquipment
{
       	[_bleManager scanDeviceTime:10];//开始搜索
        [SVProgressHUD show];
}
#pragma mark --接受蓝牙搜索结果回调
- (void)scanDeviceRefrash:(NSMutableArray *)array
{
	[SVProgressHUD dismiss];
	[blueNameDataSource addObjectsFromArray:array];
	[blueTableView reloadData];
    
    
    for (DeviceInfo *info in array) {
        CBPeripheral* device = [_bleManager getDeviceByUUID:info.UUIDString];//取出device
        [_bleManager connectToDevice:device];//链接设备
    }
    
}







#pragma mark --点解蓝牙名称链接蓝牙
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_bleManager manualStopScanDevice];//停止扫描
	
	DeviceInfo* info = blueNameDataSource[indexPath.row];
	CBPeripheral* device = [_bleManager getDeviceByUUID:info.UUIDString];//取出device
	[_bleManager connectToDevice:device];//链接设备
}
#pragma mark --连接设备成功回调
- (void)connectDeviceSuccess:(CBPeripheral *)device error:(NSError *)error
{
    
    
    [SVProgressHUD dismiss];
	NSString* string = nil;
	//验证，链接成功的是否为存在于扫描结果列表内的设备
	for (DeviceInfo* info in blueNameDataSource) {
		if ([info.UUIDString isEqualToString:device.identifier.UUIDString]) {
			string = info.macAddrss;
            
            
            //将设备信息存入沙盒
            [[NSUserDefaults standardUserDefaults] setObject:info.UUIDString forKey:@"DeviceInfo"];
            
			break;
		}
	}
    
    
    
    
    
	[SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ 已连接",string]];//提示已链接
	//？？？
	[[BLEManager defaultManager] enableNotify2000ServiceDevice:device withcharacteristicUUID:0x2005];
	[[BLEManager defaultManager] sendData:@"F041" to2000ServiceDevice:device WithCharacteristic:0x2005 responseState:NO];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --连接设备失败回调
- (void)didDisconnectDevice:(CBPeripheral *)device error:(NSError *)error {
	NSString* string = nil;
	//验证，链接成功的是否为存在于扫描结果列表内的设备
	for (DeviceInfo* info in blueNameDataSource) {
		if ([info.UUIDString isEqualToString:device.identifier.UUIDString]) {
			string = info.macAddrss;
			break;
		}
	}
	[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ 断开连接",string]];
}


#pragma mark --发送数据
- (void)sendValueToBra:(NSString *)string
{
	
	NSLog(@"%@",string);
	if (string.length == 0) {
		return;
	}
	if (string.length % 2 != 0 ) {
		string = [NSString stringWithFormat:@"%@0",string];
	}
	
	//给扫描结果列表中的每个设备都发送信息
	for (DeviceInfo* info in blueNameDataSource) {
		CBPeripheral* cb = [_bleManager getDeviceByUUID:info.UUIDString];
		[_bleManager sendDataToDevice1:string device:cb];
	}
}




#pragma --mark 发送数据后，接收从设备返回的数据
- (void)receiveDeviceDataSuccess_3:(NSData *)data device:(CBPeripheral *)device
{
	NSLog(@"主动请求返回的data：%@",data);
	
	
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
	NSLog(@"主动请求返回的字符串：%@",string);
}

#pragma mark --接收设备的广播数据
- (void)receiveDeviceDataSuccess_1:(NSData *)data device:(CBPeripheral *)device
{
	NSLog(@"接收到的广播data：%@",data);
	
	
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
	NSLog(@"接收到的广播字符串：%@",string);
	
}


#pragma mark --十进制转十六进制
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
