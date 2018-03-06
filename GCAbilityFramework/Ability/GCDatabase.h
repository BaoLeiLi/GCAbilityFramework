//
//  GCDatabase.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^OperationResult)(BOOL result);

@interface GCDatabase : NSObject

+ (instancetype)database;
/**
 *  @brief 创建并打开数据库
 *  @return 操作结果
 */
- (BOOL)gc_creaateDatabase;
/**
 *  @brief 启动所有数据库的API
 *  @attention 仅对交互生效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 建表
 *  @param param 建表参数 格式 : { params: { tableName:xxx , column : [ {name:xx,type:int,isId:true,isAutoIncrement:true },{name:xxxx,type:string,isId:false,isAutoIncrement:false } ] } }
 *  @attention 如果交互调用，请把 'param' 置空
 *  @param response 操作结果
 */
- (void)gc_createTableInfo:(NSDictionary *)param response:(OperationResult)response;
/**
 *  @brief 插入数据
 *  @param param 数据内容 格式 : { params: { tableName:xxx , column : [ {name:xx,type:int,value:123 },{name:xxxx,type:string,value:xxx } ] } }
 *  @attention 如果交互调用，请把 'param' 置空
 *  @param response 操作结果
 */
- (void)gc_insertInfo:(NSDictionary *)param response:(OperationResult)response;
/**
 *  @brief 删除表
 *  @param param 删除表参数
 *  @attention 如果交互调用，请把 'param' 置空
 *  @param response 操作结果
 */
- (void)gc_deteleTable:(NSDictionary *)param response:(OperationResult)response;
/**
 *  @brief 删除数据(从表中)
 *  @param param 删除数据参数
 *  @attention 如果交互调用，请把 'param' 置空
 *  @param response 操作结果
 */
- (void)gc_deleteData:(NSDictionary *)param response:(OperationResult)response;
/**
 *  @brief 数据查询
 *  @param param 查询参数
 *  @attention 如果交互调用，请把 'param' 置空
 *  @param response 操作结果
 */
- (void)gc_query:(NSDictionary *)param response:(OperationResult)response;
/**
 *  @brief 数据更新
 *  @param param 更新参数
 *  @attention 如果交互调用，请把 'param' 置空
 *  @param response 操作结果
 */
- (void)gc_update:(NSDictionary *)param respone:(OperationResult)response;

@end
