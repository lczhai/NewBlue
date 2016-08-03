//
//  LJDataBaseManager.h
//  SLLights
//
//  Created by lj on 16/1/5.
//  Copyright © 2016年 lj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface LJDataBaseManager : NSObject

/**实例化的方法*/
- (instancetype)initWithPath:(NSString*)path;

/**建表*/
- (void)createTableWithTableName:(NSString*)tableName columns:(NSDictionary*)columnDic;

/**插入数据*/
- (void)insertDataWithColumnDic:(NSDictionary*)columnDic toTable:(NSString*)tableName;

/**删除数据*/
- (void)deleteDataWithColumns:(NSDictionary*)columnDic fromTable:(NSString*)tableName;

/**更新数据*/
- (void)updateDataWithTable:(NSString*)tableName columns:(NSDictionary*)columnDic condition:(NSInteger)condition;

#pragma mark - 查找数据
/**查找表中的所有数据*/
- (FMResultSet*)findDataFromTable:(NSString*)tableName;
/*查询表中的某一列数据*/
- (FMResultSet*)findDataFromeTable:(NSString*)tableName condition:(NSString*)columnName;
/**查询表中符合某一条件的整条数据*/
- (FMResultSet*)findDataFromTable:(NSString*)tableName conditionColumnName:(NSString*)conditionColumnName condition:(NSString*)condition;
/**查询表中符合某一条件的某一列数据*/
- (FMResultSet*)findDataFromTable:(NSString*)tableName columnName:(NSString*)columnName conditionColumnName:(NSString*)conditionColumnName condition:(NSString*)condition;

- (NSArray*)findDataFromTableName:(NSString *)tableName withColumnName:(NSString *)columnName;


@end
