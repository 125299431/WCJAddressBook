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
+ (void)insertDataToDataBase:(AddressBookModel *)model
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    
    NSString *insertSql = @"INSERT  INTO AddressBookList (name,telephone,image) VALUES (?,?,?);";
    NSArray *params = @[model.name, model.telephone, model.image];
    EGODatabaseRequest *request = [dataBase requestWithUpdate:insertSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        NSLog(@"添加数据完成");
        //关闭数据库
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

//删
+ (void)removeDataWithTelephone:(NSString *)telephone
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    NSString *delecateSql = [NSString stringWithFormat:@"DELETE FROM AddressBookList WHERE id=(?)"];
    NSArray *params = @[telephone];
    EGODatabaseRequest *request = [dataBase requestWithUpdate:delecateSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
        NSLog(@"删除数据成功");
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

//改
+ (void)upDateDataWithOldTel:(NSString *)telephone WithNewTel:(NSString *)newtelephone WithNewName:(NSString *)name
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
        NSLog(@"删除数据成功");
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
