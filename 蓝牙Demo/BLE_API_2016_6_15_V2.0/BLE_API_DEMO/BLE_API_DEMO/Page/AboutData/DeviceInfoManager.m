//
//  DeviceInfoManager.m
//  new_HY_BLE
//
//  Created by LJ on 16/2/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "DeviceInfoManager.h"
#import "DeviceInfo.h"
#import "FMResultSet.h"
#import "Header.h"

@implementation DeviceInfoManager

+ (instancetype)defaultManager {
    static DeviceInfoManager* manager = nil;
    if (!manager) {
        manager = [[DeviceInfoManager alloc] initWithPath:PATH];
        [manager createTable];
    }
    return manager;
}

- (void)createTable {
    [self createTableWithTableName:CONNECT_DEVICE_TABLE columns:@{CONNECT_DEVICE_NAME:@"varchar(100)",CONNECT_DEVICE_UUID:@"varchar(100)",CONNECT_DEVICE_MAC:@"varchar(100)"}];
}

- (void)synchroniedDeviceInfoWithDeviceInfo:(DeviceInfo*)info {
    [self insertDataWithColumnDic:@{CONNECT_DEVICE_UUID:info.UUIDString,CONNECT_DEVICE_NAME:info.name,CONNECT_DEVICE_MAC:info.macAddrss} toTable:CONNECT_DEVICE_TABLE];
}

- (NSMutableArray*)findDeviceInfo {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    FMResultSet* set  = [self findDataFromTable:CONNECT_DEVICE_TABLE];
    while ([set next]) {
        DeviceInfo* info = [[DeviceInfo alloc] init];
        info.UUIDString = [set stringForColumn:CONNECT_DEVICE_UUID];
        info.name = [set stringForColumn:CONNECT_DEVICE_NAME];
        info.macAddrss = [set stringForColumn:CONNECT_DEVICE_MAC];
        [array addObject:info];
        info = nil;
    }
    return array;
}

@end
