//
//  AlertView.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "AlertView.h"
#import "AppDelegate.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation AlertView

- (void)awakeFromNib {
    self.backgroundColor = [UIColor grayColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)showViewWith:(NSString*)string {
    _alertLabel.text = string;
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    self.frame = CGRectMake(0, 0, 200, 50);
    self.center = CGPointMake(WIDTH/2, HEIGHT-80);
    [delegate.window addSubview:self];
    [self performSelector:@selector(remove) withObject:nil afterDelay:1.5f];
}

- (void)remove {
    [self removeFromSuperview];
}

@end
