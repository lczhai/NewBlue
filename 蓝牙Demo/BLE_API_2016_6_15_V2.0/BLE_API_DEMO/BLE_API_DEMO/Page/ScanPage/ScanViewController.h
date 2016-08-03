//
//  ScanViewController.h
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;


- (IBAction)clickScanButton:(id)sender;


@end
