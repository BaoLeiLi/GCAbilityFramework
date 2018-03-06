//
//  GCDatabase.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCDatabase.h"
#import "FMDB.h"
@interface GCDatabase ()
{
    FMDatabase *_database;
}
@end

@implementation GCDatabase

+ (instancetype)database{
    
    static GCDatabase *database = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        database = [[GCDatabase alloc] init];
    });
    return database;
}

- (BOOL)gc_creaateDatabase{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"ustc_sinovate_app.sqlite"];
    
    _database = [FMDatabase databaseWithPath:filePath];
    
    BOOL isopen = [_database open];
    
    return isopen;
}

- (void)gc_startEntireApi{
    
    [self gc_creaateDatabase];
    [self gc_createTableInfo:nil response:nil];
    [self gc_insertInfo:nil response:nil];
    [self gc_deteleTable:nil response:nil];
    [self gc_deleteData:nil response:nil];
    [self gc_query:nil response:nil];
    [self gc_update:nil respone:nil];
}

- (void)gc_createTableInfo:(NSDictionary *)param response:(OperationResult)response{
    
    if (param) {
        
        BOOL create = [self createTableInfo:param];
        
        if (response) {
            
            response(create);
        }
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:CreateTableInfo handler:^(id data, WVJBResponseCallback responseCallback) {
            // 格式化参数成json
            NSDictionary *dict = [GCHelper jsonDictionary:param];
            
            BOOL create = [self createTableInfo:dict];
            
            NSString *result = create ? @"Success":@"failure";
            
            responseCallback(result);
            
        }];
    }
}

- (void)gc_insertInfo:(NSDictionary *)param response:(OperationResult)response{
    
    if (param) {
        
        BOOL result = [self insertInfo:param];
        
        if (response) {
            
            response(result);
        }
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:InsertInfo handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSDictionary *dict = [GCHelper jsonDictionary:param];
            
            BOOL insert = [self insertInfo:dict];
            
            NSString *result = insert ? @"Success":@"failure";
            
            responseCallback(result);
            
        }];
        
    }
}

- (void)gc_deteleTable:(NSDictionary *)param response:(OperationResult)response{
    
    if (param) {
        
        
    }else{
#warning Handler
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *drop_sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",@""];
            
            BOOL drop = [_database executeUpdate:drop_sql];
            
            NSString *dropStr = drop?@"success":@"failure";
            
            responseCallback(@{@"data":dropStr});
            
        }];
    }
}

- (void)gc_deleteData:(NSDictionary *)param response:(OperationResult)response{
    
    if (param) {
        
        
    }else{
#warning Handler
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *delete_sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",@"",@""];
            BOOL delete = [_database executeUpdate:delete_sql];
            
            NSString *deleteStr = delete?@"success":@"failure";
            
            responseCallback(@{@"data":deleteStr});
        }];
    }
}

- (void)gc_query:(NSDictionary *)param response:(OperationResult)response{
    
    if (param) {
        
        
        
    }else{
#warning Handler
        __weak typeof(self)weakSelf = self;
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSMutableArray *query = [weakSelf query:data];
            
            responseCallback(@{@"data":query});
            
        }];
    }
}

- (void)gc_update:(NSDictionary *)param respone:(OperationResult)response{
    
    if (param) {
        
        
        
    }else{
#warning Handler
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *update_sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",@"",@"",@""];
            BOOL update = [_database executeUpdate:update_sql];
            
            NSString *updateStr = update?@"success":@"failure";
            
            responseCallback(@{@"data":updateStr});
            
        }];
    }
}






#pragma mark - private
- (BOOL)createTableInfo:(NSDictionary *)dict{
    
    // 表名
    NSString *tableName = dict[@"tableName"];
    // 表字段
    NSArray *columns = (NSArray *)dict[@"column"];
    
    NSMutableString *createTable_Sql = [[NSMutableString alloc] initWithFormat:@"create table '%@'",tableName];
    
    for (int i = 0; i < columns.count; i++) {
        
        NSDictionary *item = columns[i];
        // 属性名称
        NSString *nameKey = item[@"name"];
        // 数据类型(int／String 两种类型)
        NSString *typeKey = item[@"type"];
        // 是否主键
        BOOL isId = [item[@"isId"] boolValue];
        // 主键是否自增长
        BOOL isAutoIncrementKey = [item[@"isAutoIncrement"] boolValue];
        
        NSString *typeStr = @"text";
        
        if ([typeKey isEqualToString:@"int"]) {
            
            typeStr = @"Integer";
        }
        
        if (i == 0) {
            
            if (isId) {
                
                if (isAutoIncrementKey) {
                    
                    [createTable_Sql appendFormat:@"('%@' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ",nameKey];
                    
                    continue;
                    
                }else{
                    
                    NSString *tmpType = [typeStr isEqualToString:@"text"] ? @"TEXT":@"INTEGER";
                    
                    [createTable_Sql appendFormat:@"('%@' %@ PRIMARY KEY ",nameKey,tmpType];
                    
                    continue;
                }
                
            }else{
                
                [createTable_Sql appendFormat:@"('%@' %@ ",nameKey,typeStr];
                
                continue;
            }
        }
        
        if (i == columns.count - 1) {
            
            [createTable_Sql appendFormat:@"'%@' %@ )",nameKey,typeStr];
            
            continue;
        }
        
        [createTable_Sql appendFormat:@",'%@' %@ ",nameKey,typeStr];
    }
    
    NSLog(@"create table sql : %@",createTable_Sql);
    
    BOOL isCreate = [_database executeUpdate:createTable_Sql];
    
    return isCreate;
    
}

- (BOOL)insertInfo:(NSDictionary *)dict{
    
    // 表名
    NSString *tableName = dict[@"tableName"];
    // 表字段
    NSArray *columns = (NSArray *)dict[@"column"];
    
    NSMutableString *insterTable_Sql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO '%@' (",tableName];
    NSMutableString *values_sql = [[NSMutableString alloc] initWithFormat:@"VALUES ("];
    for (int i = 0; i < columns.count; i++) {
        
        NSDictionary *item = columns[i];
        
        NSString *name = item[@"name"];
        __unused NSString *type = item[@"type"];
        id value = item[@"value"];
        
        if (i == columns.count - 1) {
            
            [insterTable_Sql appendFormat:@"%@ )",name];
            
            [values_sql appendFormat:@"%@ )",value];
            
            continue;
        }
        
        [insterTable_Sql appendFormat:@"%@,",name];
        
        [values_sql appendFormat:@"%@,",value];
    }
    
    [insterTable_Sql appendString:values_sql];
    
    NSLog(@"inster values sql : %@",insterTable_Sql);
    
    BOOL isInster = [_database executeUpdate:insterTable_Sql];
    
    return isInster;
}

- (NSMutableArray *)query:(NSDictionary *)param{
    
#warning Param
//    NSDictionary *data = [GCHelper jsonDictionary:param];
    
    NSString *query_sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",@"",@""];
    
    //执行sql查询语句(调用FMDB对象方法)
    FMResultSet *set =  [_database executeQuery:query_sql];
    
    NSMutableArray *queryArray = [NSMutableArray array];
    
    while ([set next]) {
        
        int column = set.columnCount;
        
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < column; i++) {
            
            NSString *columnName = [set columnNameForIndex:i];
            // 无法区辩数据类型,通用字符串处理
            NSString *columnValue = [set stringForColumn:columnName];
            
            [tmpDict setObject:columnValue forKey:columnName];
        }
        
        [queryArray addObject:tmpDict];
        
    }
    
    return queryArray;
}

@end
