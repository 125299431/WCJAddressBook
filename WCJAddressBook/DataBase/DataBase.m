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

@end
