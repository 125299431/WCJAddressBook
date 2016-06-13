//
//  InsertOrUpdateViewController.m
//  WCJAddressBook
//
//  Created by ZhengHongye on 16/6/13.
//  Copyright © 2016年 WuChaojie. All rights reserved.
//

#import "InsertOrUpdateViewController.h"

@interface InsertOrUpdateViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InsertOrUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    imageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:imageView];
    UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth - 250) / 2, imageView.bottom + 20, 250, 40)];
    textFiled.borderStyle = UITextBorderStyleRoundedRect;
    textFiled.placeholder = @"输入联系人姓名";
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:textFiled];
    self.tableView.sectionHeaderHeight = 200;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = headerView;
}

- (void)cancleClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishClick:(UIBarButtonItem *)item
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    return cell;
}

@end
