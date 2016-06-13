//
//  DataBase.h
//  WCJAddressBook
//
//  Created by ZhengHongye on 16/6/12.
//  Copyright © 2016年 WuChaojie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGODatabase.h"

typedef void(^CallBack)(BOOL isSuccess);

@interface DataBase : NSObject


//增
+ (void)insertDataToDataBase:(AddressBookModel *)model;

//删
+ (void)removeDataWithTelephone:(NSString *)telephone WithCallBack:(void(^)(BOOL))callBack;

//改
+ (void)upDateDataWithOldTel:(NSString *)telephone WithNewTel:(NSString *)newtelephone WithNewName:(NSString *)name;

//查
+ (void)selectDataFromDataBaseCallBack:(void(^)(NSArray *))callBack;


@end
