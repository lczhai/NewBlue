//
//  HomePageViewController.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "HomePageViewController.h"
#import "ScanViewController.h"
#import "ConnectViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)settingView {
    NSMutableArray* viewControllers = [[NSMutableArray alloc] init];
    
    ScanViewController* vc1 = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    UINavigationController* nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    ConnectViewController* vc2 = [[ConnectViewController alloc] initWithNibName:@"ConnectViewController" bundle:nil];
    UINavigationController* nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    [viewControllers addObject:nc1];
    [viewControllers addObject:nc2];
    self.viewControllers = viewControllers;
    
    NSArray* itemsArray = self.tabBar.items;
    NSArray* titleArray = @[@"扫描BLE",@"已连接"];
    for (int i = 0; i < itemsArray.count; i++) {
        UITabBarItem* item = itemsArray[i];
        item.title = titleArray[i];
    }
}

@end
