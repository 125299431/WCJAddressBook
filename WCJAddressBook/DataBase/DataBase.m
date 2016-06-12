//
//  DataBase.m
//  ManClothes
//
//  Created by imac on 15/10/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DataBase.h"
@implementation DataBase


//插入数据(单品收藏)
+ (void)insertDPDataToDataBase:(SellModel *)sellModel
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    
    NSString *insertSql = @"INSERT  INTO DPTable (PictureUrl,title,price,id) VALUES (?,?,?,?);";
    NSArray *params = @[sellModel.pic_url, sellModel.title, sellModel.coupon_price,sellModel.item_id];
    EGODatabaseRequest *request = [dataBase requestWithUpdate:insertSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        NSLog(@"添加数据完成");
        //关闭数据库
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}

//插入数据(专题收藏)
+ (void)insertZTDataToDataBase:(IssuseModel *)issuseModel
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    
    NSString *insertSql = @"INSERT  INTO ZTTable (pictureUrl,title,type,id) VALUES (?,?,?,?);";
    NSArray *params = @[issuseModel.img, issuseModel.title,issuseModel.album_type,issuseModel.albumId];
    EGODatabaseRequest *request = [dataBase requestWithUpdate:insertSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        if (!error) {
            NSLog(@"添加数据完成");
        }else {
            NSLog(@"error%@", error);
        }
        //关闭数据库
        [dataBase close];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
    
}

//删除数据
+ (void)removeDataWithTableName:(NSString *)tableName ItemId:(NSString *)itemId
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    NSString *delecateSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id=(?)",tableName];
    NSArray *params = @[itemId];
    EGODatabaseRequest *request = [dataBase requestWithUpdate:delecateSql parameters:params];
    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
        NSLog(@"删除数据成功");
        [dataBase close];
    }];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}


//查询数据
+ (void)selectDataFromDataBaseWithTableName:(NSString *)tableName block:(void(^)(NSArray *))competionHandle
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:dataBaseFilePath];
    [dataBase open];
    
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@", tableName];
    EGODatabaseRequest *request = [dataBase requestWithQuery:selectStr];
    [request setCompletion:^(EGODatabaseRequest *requst, EGODatabaseResult *result, NSError *error) {
        NSLog(@"查询操作执行完成");
        NSMutableArray *mArr = [NSMutableArray array];
        for (int i = 0; i < result.count; i++) {
            EGODatabaseRow *row = result.rows[i];
            if ([tableName isEqualToString:@"DPTable"]) {
                //单品
                SellModel *sellModel = [[SellModel alloc] init];
                sellModel.item_id = [row stringForColumn:@"id"];
                sellModel.pic_url = [row stringForColumn:@"PictureUrl"];
                sellModel.title = [row stringForColumn:@"title"];
                sellModel.coupon_price = [row stringForColumn:@"price"];
                [mArr addObject:sellModel];
            }else if ([tableName isEqualToString:@"ZTTable"]){
                //专题收藏
                
                IssuseModel *issuseModel = [[IssuseModel alloc] init];
                issuseModel.albumId = [row stringForColumn:@"id"];
                issuseModel.title = [row stringForColumn:@"title"];
                issuseModel.img = [row stringForColumn:@"pictureUrl"];
                issuseModel.album_type = [NSNumber numberWithInteger:[[row stringForColumn:@"type"] integerValue]] ;
                [mArr addObject:issuseModel];
                
            }else {
                NSLog(@"表名出错了");
                return;
            }
        }
        
        competionHandle(mArr);
        
        [dataBase close];
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
}




@end
