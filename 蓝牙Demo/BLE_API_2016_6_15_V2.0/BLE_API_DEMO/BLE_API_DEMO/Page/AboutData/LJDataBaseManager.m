//
//  LJDataBaseManager.m
//  SLLights
//
//  Created by lj on 16/1/5.
//  Copyright © 2016年 lj. All rights reserved.
//

#import "LJDataBaseManager.h"
#import "FMDatabase.h"
#import "Header.h"

@implementation LJDataBaseManager {
    FMDatabase* _dataBase;
    NSLock* _lock;
}

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        //打开数据库
        BOOL ret = [_dataBase open];
        if (!ret) {
            NSLog(@"打开数据库失败");
        }
        _lock = [[NSLock alloc] init];
    }
    return self;
}

//建表
- (void)createTableWithTableName:(NSString*)tableName columns:(NSDictionary*)columnDic {
    //create table if not exists USER(id integer primary key autoincrement, name)
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(UID INTEGER PRIMARY KEY AUTOINCREMENT",tableName];
    for (NSString* columnName in columnDic) {
        sql = [sql stringByAppendingFormat:@",%@ %@",columnName,columnDic[columnName]];
    }
    sql = [sql stringByAppendingFormat:@");"];
    //NSLog(@"%@",sql);
    BOOL ret = [_dataBase executeUpdate:sql];
    if (ret == NO) {
        NSLog(@"建表失败");
    }
    [_lock unlock];
}

//插入数据
- (void)insertDataWithColumnDic:(NSDictionary*)columnDic toTable:(NSString*)tableName {
    [_lock lock];
    NSString* columnName = [columnDic.allKeys componentsJoinedByString:@","];
    NSMutableArray* tempArray = [NSMutableArray array];
    for(NSInteger a = 0;a<columnDic.allKeys.count;a++) {
        [tempArray addObject:@"?"];
    }
    NSString* valueString = [tempArray componentsJoinedByString:@","];
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@);",tableName,columnName,valueString];
    BOOL ret = [_dataBase executeUpdate:sql withArgumentsInArray:columnDic.allValues];
//    NSLog(@"%@",sql);
    if (ret == NO) {
        NSLog(@"插入数据失败");
    }
    [_lock unlock];
}

//删除数据
- (void)deleteDataWithColumns:(NSDictionary*)columnDic fromTable:(NSString*)tableName {
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    BOOL isFirst = YES;
    for (NSString* key in columnDic) {
        if (isFirst) {
            sql = [sql stringByAppendingString:@" WHERE "];
            isFirst = NO;
        } else {
            sql = [sql stringByAppendingString:@" AND "];
        }
        sql = [sql stringByAppendingFormat:@"%@=?",key];
    }
    sql = [sql stringByAppendingString:@";"];
    //NSLog(@"%@",sql);
    BOOL ret = [_dataBase executeUpdate:sql withArgumentsInArray:columnDic.allValues];
    if (!ret) {
        NSLog(@"删除数据失败");
    }
    [_lock unlock];
}

//查找表中的所有数据
- (FMResultSet*)findDataFromTable:(NSString*)tableName {
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@;",tableName];
    FMResultSet* set = [_dataBase executeQuery:sql];
    [_lock unlock];
    return set;
}

//查询表中的某一列数据
- (FMResultSet*)findDataFromeTable:(NSString*)tableName condition:(NSString*)columnName {
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"SELECT %@ FROM %@;",columnName,tableName];
    FMResultSet* set = [_dataBase executeQuery:sql];
    [_lock unlock];
    return set;
}

//查询表中符合某一条件的整条数据
- (FMResultSet*)findDataFromTable:(NSString*)tableName conditionColumnName:(NSString*)conditionColumnName condition:(NSString*)condition {
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@';",tableName,conditionColumnName,condition];
    FMResultSet* set = [_dataBase executeQuery:sql];
    [_lock unlock];
    return set;
}

//查询表中符合某一条件的某一列数据
- (FMResultSet*)findDataFromTable:(NSString*)tableName columnName:(NSString*)columnName conditionColumnName:(NSString*)conditionColumnName condition:(NSString*)condition {
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@';",columnName,tableName,conditionColumnName,condition];
    FMResultSet* set = [_dataBase executeQuery:sql];
    [_lock unlock];
    return set;
}

- (NSArray*)findDataFromTableName:(NSString *)tableName withColumnName:(NSString *)columnName {
    FMResultSet* set = [self findDataFromeTable:tableName condition:columnName];
    NSMutableArray* array = [NSMutableArray array];
    NSString* string;
    while ([set next]) {
        if ([columnName isEqualToString:@"UID"]) {
            string = INT_STRING([set intForColumn:@"UID"]);
        } else {
            string = [set stringForColumn:columnName];
        }
        if (string != nil) {
            [array addObject:string];
        }
    }
    return array;
}

#pragma mark - 更新数据
//更新数据
- (void)updateDataWithTable:(NSString*)tableName columns:(NSDictionary*)columnDic condition:(NSInteger)condition {
    [_lock lock];
    NSString* sql = [NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
    NSArray* tempAttay = columnDic.allKeys;
    for (int a = 0; a < tempAttay.count; a++) {
        NSString* key = tempAttay[a];
        if (a == (tempAttay.count-1)) {
            sql = [sql stringByAppendingFormat:@"%@ ='%@' ",tempAttay[a],columnDic[key]];
        } else {
            sql = [sql stringByAppendingFormat:@"%@ = '%@' ,",tempAttay[a],columnDic[key]];
        }
    }
    sql = [sql stringByAppendingFormat:@"WHERE UID = %ld;",(long)condition];
    BOOL ret = [_dataBase executeUpdate:sql];
    //NSLog(@"%@",sql);
    if (!ret) {
        NSLog(@"更新数据失败");
    }
    [_lock unlock];
}

@end
