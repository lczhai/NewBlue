//
//  ConnectDeviceInfoCell.h
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConnectDeviceInfoCellDelegate <NSObject>

- (void)enterOadPageWithIndex:(NSInteger)index;

@end

@interface ConnectDeviceInfoCell : UITableViewCell

@property (nonatomic, strong) id <ConnectDeviceInfoCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *recieveDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiUnitLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *oadButton;

@property (nonatomic, assign) NSInteger index;

- (IBAction)clickSelectedButton:(id)sender;

- (IBAction)clickOADButton:(id)sender;
@end
