//
//  Header.h
//  SLLights
//
//  Created by lj on 15/12/30.
//  Copyright © 2015年 lj. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define COLOR(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]

#define WINDOWN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WINDOWN_HEIGHT [UIScreen mainScreen].bounds.size.height

//数据类型转换相关的宏
#define INT_STRING(a) [NSString stringWithFormat:@"%d",a]
#define INT(a) [a intValue]


/**通过给定的分隔符分割主字符串，得到子字符串*/
#define GET_SUB_STRING(superString,cutString,index) [superString componentsSeparatedByString:cutString][index]

/**表储存的位置*/
#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cache.db"]

/**连接过的设备的信息相关的表*/
#define CONNECT_DEVICE_TABLE @"CONNECT_DEVICE_TABLE"
#define CONNECT_DEVICE_NAME @"CONNECT_DEVICE_NAME"
#define CONNECT_DEVICE_UUID @"CONNECT_DEVICE_UUID"
#define CONNECT_DEVICE_MAC @"CONNECT_DEVICE_MAC"
#endif /* Header_h */









