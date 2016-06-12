//
//  DataBase.h
//  ManClothes
//
//  Created by imac on 15/10/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGODatabase.h"
#import "SellModel.h"
#import "IssuseModel.h"
@interface DataBase : NSObject


//插入数据（单品收藏）
+ (void)insertDPDataToDataBase:(SellModel *)sellModel;

//插入数据(专题收藏)
+ (void)insertZTDataToDataBase:(IssuseModel *)issuseModel;

//删除数据
+ (void)removeDataWithTableName:(NSString *)tableName ItemId:(NSString *)itemId;


//查询数据
+ (void)selectDataFromDataBaseWithTableName:(NSString *)tableName block:(void(^)(NSArray *))competionHandle;



@end
