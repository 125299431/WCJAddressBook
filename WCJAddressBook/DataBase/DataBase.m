//
//  DataBase.m
//  WCJAddressBook
//
//  Created by ZhengHongye on 16/6/12.
//  Copyright © 2016年 WuChaojie. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase

//增
+ (void)insertDataToDataBase:(AddressBookModel *)model WithCallBack:(void(^)(BOOL))callBack
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    
    NSString *insertSql;
    NSArray *params;
    if (!model.image) {
        insertSql = @"INSERT  INTO AddressBookList (name,telephone) VALUES (?,?);";
        params = @[model.name, model.telephone];
    }else {
        insertSql = @"INSERT  INTO AddressBookList (name,telephone,image) VALUES (?,?,?);";
        params = @[model.name, model.telephone, model.image];
    }
    
    
    EGODatabaseRequest *request = [dataBase requestWithUpdate:insertSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        if (!error) {
            NSLog(@"添加数据完成");
            if (callBack) {
                callBack(YES);
            }
        }else {
            if (callBack) {
                callBack(NO);
            }
        }
        
        
        //关闭数据库
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

//删
+ (void)removeDataWithTelephone:(NSString *)telephone WithCallBack:(void(^)(BOOL))callBack
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    NSString *delecateSql = [NSString stringWithFormat:@"DELETE FROM AddressBookList WHERE telephone=(?)"];
    NSArray *params = @[telephone];
    EGODatabaseRequest *request = [dataBase requestWithUpdate:delecateSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
        if (!error) {
            NSLog(@"删除数据成功");
            if (callBack) {
                callBack(YES);
            }
        }else{
            NSLog(@"Error---------%@", error);
            if (callBack) {
                callBack(NO);
            }
        }
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

//改
+ (void)upDateDataWithOldTel:(NSString *)telephone WithNewTel:(NSString *)newtelephone WithNewName:(NSString *)name WithCallBack:(void(^)(BOOL))callBack
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    NSString *upDateSql;
    NSArray *params;
    if (!newtelephone && name) {
        upDateSql = [NSString stringWithFormat:@"Update AddressBookList set name = (?) where telephone = (?)"];
        params = @[name, telephone];
    }else if(!name && newtelephone){
        upDateSql = [NSString stringWithFormat:@"Update AddressBookList set telephone = (?) where telephone = (?)"];
        params = @[newtelephone, telephone];
    }else {
        NSLog(@"两者都为空");
        return;
    }
    
    EGODatabaseRequest *request = [dataBase requestWithUpdate:upDateSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
        if (!error) {
             NSLog(@"删除数据成功");
            if (callBack) {
                callBack(YES);
            }
        }else {
            if (callBack) {
                callBack(NO);
            }
        }
       
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

//查
+ (void)selectDataFromDataBaseCallBack:(void(^)(NSArray *))callBack
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    
    NSString *selectStr = [NSString stringWithFormat:@"select * from AddressBookList"];
    EGODatabaseRequest *request = [dataBase requestWithQuery:selectStr];
    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
        if (!error) {
            NSLog(@"查询操作执行完成");
            NSMutableArray *mArr = [NSMutableArray array];
            for (int i = 0; i < result.count; i++) {
                EGODatabaseRow *row = result.rows[i];
                AddressBookModel *model = [[AddressBookModel alloc] init];
                model.name = [row stringForColumn:@"name"];
                model.telephone = [row stringForColumn:@"telephone"];
                model.image = [row dataForColumn:@"image"];
                [mArr addObject:model];
            }
            
            callBack(mArr);
        }
       
        
        [dataBase close];
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

+ (void)selectPreciseDataFromDataBaseWithString:(NSString *)nameOrTelephone CallBack:(void(^)(NSArray *))callBack
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    NSString *phoneOrName;
    nameOrTelephone = [nameOrTelephone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    nameOrTelephone = [nameOrTelephone stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    nameOrTelephone = [nameOrTelephone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([nameOrTelephone integerValue]) {
        phoneOrName = @"telephone";
    }else {
        phoneOrName = @"name";
    }
//    NSString *selectStr = [NSString stringWithFormat:@"select * from AddressBookList where (?) is (?)"];
//    NSArray *params = @[phoneOrName,nameOrTelephone];
//    NSLog(@"%@------", phoneOrName);
//    EGODatabaseRequest *request = [dataBase requestWithQuery:selectStr parameters:params];
////    EGODatabaseRequest *request = [dataBase requestWithUpdate:selectStr parameters:params];
////    EGODatabaseRequest *request = [dataBase requestWithQuery:selectStr];
//    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
//        if (!error) {
//            NSLog(@"查询操作执行完成");
//            NSMutableArray *mArr = [NSMutableArray array];
//            for (int i = 0; i < result.count; i++) {
//                EGODatabaseRow *row = result.rows[i];
//                AddressBookModel *model = [[AddressBookModel alloc] init];
//                model.name = [row stringForColumn:@"name"];
//                model.telephone = [row stringForColumn:@"telephone"];
//                model.image = [row dataForColumn:@"image"];
//                [mArr addObject:model];
//            }
//            
//            callBack(mArr);
//        }else {
//            NSLog(@"查询出错Error---%@", error);
//        }
//        
//        
//        [dataBase close];
//        
//    }];
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:request];
    
    /*********************************系统自带*************************************/
    sqlite3 *sqlite = nil;
    //创建句柄,本身不是指针，但是作用是个指针
    sqlite3_stmt *stmt = nil;
    /*
     打开数据库
     如果数据库存在就直接打开
     如果不存在就创建
     */
    int result = sqlite3_open([dataBaseFilePath UTF8String], &sqlite);
    
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return;
    }
    
    NSString *selectData = [NSString stringWithFormat:@"SELECT * FROM AddressBookList WHERE %@ like '%%%@%%';", phoneOrName, nameOrTelephone];
//    @"SELECT * FROM AddressBookList WHERE ? > ?;";
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [selectData UTF8String],  -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"编译失败");
        sqlite3_close(sqlite);
        return;
    }
    
    //填充占位符
//    int age = 10;
//    sqlite3_bind_int(stmt, 1, age);
    //执行语句
    result = sqlite3_step(stmt);
    //创建可变数组装字典
    NSMutableArray *mArr = [NSMutableArray array];
    //SQLITE_ROW还有下一个值
    while (result == SQLITE_ROW) {
        //取出数据
        //从0开始取
        char *name = (char *)sqlite3_column_text(stmt, 0);
        char *telephone = (char *)sqlite3_column_text(stmt, 1);
        
        //c->oc
        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString *phoneStr = [NSString stringWithCString:telephone encoding:NSUTF8StringEncoding];
        AddressBookModel *model = [[AddressBookModel alloc] init];
        model.name = nameStr;
        model.telephone = phoneStr;
        [mArr addObject:model];
        
        //把result改变
        result = sqlite3_step(stmt);
        
    }
    
    callBack(mArr);
}


@end
