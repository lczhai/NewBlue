//
//  ConnectViewController.h
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)clickSendDataButton:(id)sender;

@end
