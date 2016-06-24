//
//  InsertOrUpdateViewController.m
//  WCJAddressBook
//
//  Created by ZhengHongye on 16/6/13.
//  Copyright © 2016年 WuChaojie. All rights reserved.
//

#import "InsertOrUpdateViewController.h"
#import "InsertPhoneCell.h"
#import "PhoneCell.h"

@interface InsertOrUpdateViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UITextField *phoneTextField;



@end

@implementation InsertOrUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.phoneArr = [NSMutableArray array];
    [self _initView];
}

- (void)_initView
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 60, 60);
//    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 60, 60);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    

    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 80) / 2, 10, 80, 80)];
    
    imageView.image = [UIImage imageNamed:@"userphoto"];
    
    [headerView addSubview:imageView];
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth - 250) / 2, imageView.bottom + 20, 250, 40)];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.text = self.nameStr;
    self.nameTextField.placeholder = @"输入联系人姓名";
    [self.nameTextField addTarget:self action:@selector(textFiledValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.nameTextField];
    self.tableView.sectionHeaderHeight = 200;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = headerView;
}

- (void)cancleClick:(UIButton *)btn
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishClick:(UIBarButtonItem *)item
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.nameStr) {
        //改
        if (![self.nameStr isEqualToString:self.nameTextField.text]) {
            //姓名
            [DataBase upDateDataWithOldTel:self.phoneStr WithNewTel:nil WithNewName:self.nameTextField.text WithCallBack:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self presentAlter:@"更改姓名成功!"];
                }else {
                    [self presentAlter:@"更改姓名失败!"];
                }
            }];
        }
        
        if (![self.phoneStr isEqualToString:self.phoneTextField.text]) {
            //电话
            [DataBase upDateDataWithOldTel:self.phoneStr WithNewTel:self.phoneTextField.text WithNewName:nil WithCallBack:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self presentAlter:@"更改电话成功!"];
                }else {
                    [self presentAlter:@"更改电话失败!"];
                }
            }];
        }
    }else {
        //增
        AddressBookModel *model = [[AddressBookModel alloc] init];
        model.name = self.nameTextField.text;
        model.telephone = self.phoneTextField.text;
        [DataBase insertDataToDataBase:model WithCallBack:^(BOOL isSuccess) {
            if (isSuccess) {
                [self presentAlter:@"添加信息成功!"];
            }else {
                [self presentAlter:@"添加信息失败!"];
            }
        }];
    }

}

- (void)presentAlter:(NSString *)messageStr
{
    UIAlertController *alterCtrl = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancleClick:nil];
    }];
    [alterCtrl addAction:enterAction];
    [self presentViewController:alterCtrl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isInsertPhone) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == 1 && self.isInsertPhone) || (indexPath.row == 0 && !self.isInsertPhone)) {
        InsertPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"insertCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InsertPhoneCell" owner:self options:nil].lastObject;
        }
        return cell;
    }else {
        PhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PhoneCell" owner:self options:nil].lastObject;
        }
        self.phoneTextField = cell.phoneTextFiled;
        self.phoneTextField.text = self.phoneStr;
        [self.phoneTextField addTarget:self action:@selector(textFiledValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.phoneTextFiled.text = self.phoneStr;
        return cell;
    }
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
//    }
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UIAlertController *alterCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经有一个电话了还添加？怎么那么多电话呀！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"那不添加了！" style:UIAlertActionStyleDefault handler:nil];
        [alterCtrl addAction:enterAction];
        [self presentViewController:alterCtrl animated:YES completion:nil];
        return;
    }
    self.isInsertPhone = YES;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)textFiledValueChanged:(UITextField *)textFiled
{
    if (![self.phoneTextField.text isEqualToString:@""] && ![self.nameTextField.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


@end
