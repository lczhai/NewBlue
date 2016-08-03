//
//  ConnectDeviceInfoCell.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ConnectDeviceInfoCell.h"

@implementation ConnectDeviceInfoCell

- (void)awakeFromNib {
    [_selectedButton setImage:[UIImage imageNamed:@"checkbox01"] forState:UIControlStateNormal];
    [_selectedButton setImage:[UIImage imageNamed:@"checkbox02"] forState:UIControlStateSelected];
    _selectedButton.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)clickSelectedButton:(id)sender {
    if (_selectedButton.selected) {
        _selectedButton.selected = NO;
    } else {
        _selectedButton.selected = YES;
    }
}

- (IBAction)clickOADButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(enterOadPageWithIndex:)]) {
        [_delegate enterOadPageWithIndex:self.index];
    }
}
@end
