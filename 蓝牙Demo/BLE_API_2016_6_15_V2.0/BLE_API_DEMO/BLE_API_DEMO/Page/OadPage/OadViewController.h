//
//  OadViewController.h
//  new_HY_BLE
//
//  Created by LJ on 16/6/6.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
- (IBAction)clickOadButton:(id)sender;

@end
