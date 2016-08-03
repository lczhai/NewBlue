//
//  DeviceInfoManager.h
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJDataBaseManager.h"
#import "DeviceInfo.h"

@interface DeviceInfoManager : LJDataBaseManager

+ (instancetype)defaultManager;

- (void)synchroniedDeviceInfoWithDeviceInfo:(DeviceInfo*)info;

- (NSMutableArray*)findDeviceInfo;

@end
