//
//  InfoViewController.h
//  new_HY_BLE
//
//  Created by LJ on 16/2/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
@interface InfoViewController : UIViewController

@property (nonatomic,strong) DeviceInfo* info;



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiUnitLabel;

@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line3;
@property (weak, nonatomic) IBOutlet UIImageView *line4;
@property (strong, nonatomic) IBOutlet UIView *line5;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDevicelNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deviceNameButton;

@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *showEditLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *showPowerLabel;
@property (weak, nonatomic) IBOutlet UIButton *powerButton;

@property (weak, nonatomic) IBOutlet UILabel *advDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *showAdvDisLabel;
@property (weak, nonatomic) IBOutlet UIButton *readAdvDisButton;
@property (weak, nonatomic) IBOutlet UIButton *setAdvDisButton;
@property (weak, nonatomic) IBOutlet UITextField *advDisTextField;

@property (weak, nonatomic) IBOutlet UILabel *connectDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *readConnectDisButton;
@property (weak, nonatomic) IBOutlet UILabel *showConnectDisLabel;
@property (weak, nonatomic) IBOutlet UIButton *setConnectDisButton;
@property (weak, nonatomic) IBOutlet UITextField *connectDisTextField;


- (IBAction)readDeviceName:(id)sender;
- (IBAction)readEditInfo:(id)sender;
- (IBAction)readPower:(id)sender;
- (IBAction)readAdvDis:(id)sender;
- (IBAction)setAdvDis:(id)sender;
- (IBAction)readConnectAdv:(id)sender;
- (IBAction)setConnectDis:(id)sender;



@end
