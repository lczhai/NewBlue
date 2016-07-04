//
//  RootViewController.m
//  NewBlue
//
//  Created by 翟留闯 on 16/7/4.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "DeviceInfo.h"
#import "BLEManager.h"
#import "SVProgressHUD/SVProgressHUD.h"


@interface RootViewController ()<BLEManagerDelegate>

@end

@implementation RootViewController
{
    BLEManager *_bleManager;
    NSString *sendString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主页";
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    _bleManager = [BLEManager defaultManager];//初始化蓝牙管理实例对象
    _bleManager.delegate = self;//遵循协议
    
    
    
    
    
    UIButton *intoBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.2, self.view.frame.size.width*0.4, 40)];
    [intoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [intoBtn setTitle:@"CLICK" forState:UIControlStateNormal];
    [intoBtn setBackgroundColor:[UIColor orangeColor]];
    intoBtn.layer.cornerRadius = 12;
    intoBtn.backgroundColor  =  [UIColor grayColor];
    [intoBtn addTarget:self action:@selector(button_OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:intoBtn];
    
    
    
    [self setControlButton];
    
    
    
    
    UIButton *intoBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.13, self.view.frame.size.width*0.4, 40)];
    [intoBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [intoBtn1 setTitle:@"链接" forState:UIControlStateNormal];
    [intoBtn1 setBackgroundColor:[UIColor orangeColor]];
    intoBtn1.layer.cornerRadius = 12;
    intoBtn1.backgroundColor  =  [UIColor grayColor];
    [intoBtn1 addTarget:self action:@selector(button1_OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:intoBtn1];
    
   

    
    
}
#pragma mark --按钮事件
- (void)button1_OnClick:(UIButton *)sender
{
    //搜索蓝牙
//    [self performSelector:@selector(gotoCollection) withObject:nil afterDelay:1];
    
    [self gotoCollection];
    
}

#pragma mark- 链接设备
- (void)gotoCollection
{
    
    NSString  *uuidString = [[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceInfo"];
    if ((![uuidString isEqualToString:@""]) || uuidString != nil) {
        CBPeripheral* device = [_bleManager getDeviceByUUID:uuidString];//取出device
        [_bleManager connectToDevice:device];//链接设备
        [SVProgressHUD show];

    }
    
}
#pragma mark --连接设备成功回调
- (void)connectDeviceSuccess:(CBPeripheral *)device error:(NSError *)error
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"已经连接"];
}
#pragma mark --连接设备失败回调
- (void)didDisconnectDevice:(CBPeripheral *)device error:(NSError *)error {
    
    [SVProgressHUD showErrorWithStatus:@"链接失败，请重新链接"];
}








#pragma mark --按钮事件
- (void)button_OnClick:(UIButton *)sender
{
    [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
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
    
    
    NSString  *uuidString = [[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceInfo"];
        CBPeripheral* cb = [_bleManager getDeviceByUUID:uuidString];
        [_bleManager sendDataToDevice1:string device:cb];
    
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
