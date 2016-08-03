//
//  OadViewController.m
//  new_HY_BLE
//
//  Created by LJ on 16/6/6.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "OadViewController.h"

#import "BLEManager.h"

@interface OadViewController () <BLEManagerDelegate> {
    BLEManager* _manager;
}
@end

@implementation OadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _manager = [BLEManager defaultManager];
    _manager.delegate = self;
    _manager.oadStyle = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI {
    _upgradeButton.layer.cornerRadius = 8;
    _upgradeButton.layer.borderColor = [UIColor blueColor].CGColor;
    _upgradeButton.layer.borderWidth = 1;
    _progressLabel.text = @"0 %";
}

- (IBAction)clickOadButton:(id)sender {
    if (([_upgradeButton.titleLabel.text isEqualToString:@"开始升级"] || [_upgradeButton.titleLabel.text isEqualToString:@"升级失败"])) {
        [_manager configureProfile:_manager.oadPeripheral];
        if (_manager.oadStyle == 1) {//2541 A,B 版升级
            [_upgradeButton setTitle:@"取消升级" forState:UIControlStateNormal];
        } else if (_manager.oadStyle == 4) {
            [_manager startOADFileWithFileName:@"MK_SR_02_20160531_V1.0.11_7x7.bin" peripheral:_manager.oadPeripheral progressBlock:^(float progress, NSError *error) {
                _progressView.progress = progress;
                _progressLabel.text = [NSString stringWithFormat:@"%0.f %%",progress * 100.0];
            }];
            [_upgradeButton setTitle:@"取消升级" forState:UIControlStateNormal];
        }
    } else {
        _manager.canceled = YES;
        [_upgradeButton setTitle:@"开始升级" forState:UIControlStateNormal];
    }
}

#pragma mark - BLEManager Delegate
- (void)didCanSelectOADFileWithFileType:(char)fileType {
    if (_manager.oadStyle == 1) {
        NSLog(@"bin文件类型%c",fileType);
        if (fileType == 'A') {
            [_manager startOADFileWithFileName:@"A-DK-SL-01-20160125-V1.0.3"];
        } else if (fileType == 'B') {
            [_manager startOADFileWithFileName:@"B-DK-SL-01-20160125-V1.0.3"];
        }
    }
}

- (void)returnSendOADFailure {
    [_upgradeButton setTitle:@"升级失败" forState:UIControlStateNormal];
}

- (void)returnSendOADSuccess {
    [_upgradeButton setTitle:@"升级成功" forState:UIControlStateNormal];
}

- (void)returnSendOADFileProgressWith:(float)filePer {
    _progressView.progress = filePer;
    _progressLabel.text = [NSString stringWithFormat:@"%0.f %%",filePer * 100.0];
}

@end
