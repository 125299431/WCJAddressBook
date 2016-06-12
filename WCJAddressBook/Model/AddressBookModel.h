//
//  AddressBookModel.h
//  WCJAddressBook
//
//  Created by ZhengHongye on 16/6/12.
//  Copyright © 2016年 WuChaojie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, strong) NSData *image;

@end
