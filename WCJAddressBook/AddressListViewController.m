//
//  AddressListViewController.m
//  WCJAddressBook
//
//  Created by ZhengHongye on 16/6/12.
//  Copyright © 2016年 WuChaojie. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressBookCell.h"
#import "InsertOrUpdateViewController.h"

@interface AddressListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) NSDictionary *dicData;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSArray *allKeys;//右边的索引

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = 40;
    self.tableView.sectionFooterHeight = 0.000001;
    [self _loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadData
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [DataBase selectDataFromDataBaseCallBack:^(NSArray *array) {
        for (int i = 0; i < array.count; i++) {
            AddressBookModel *model = [array objectAtIndex:i];
            NSString *firStr = [self transformCharacter:model.name];
            if (![mDic.allKeys containsObject:firStr]) {
                NSMutableArray *littleMArr = [NSMutableArray array];
//                [littleMArr addObject:firStr];
                [littleMArr addObject:model];
                [mDic setObject:littleMArr forKey:firStr];
            }else {
                NSMutableArray *littleMArr = [mDic objectForKey:firStr];
                [littleMArr addObject:model];
            }
        }
        NSArray *arr = [[mDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        self.allKeys = arr;
        NSMutableArray *bigArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            [bigArr addObject:[mDic valueForKey:arr[i]]];
        }
        
        self.dataArr = bigArr;
        /*
         [[addModel,addModel],[addModel,...],...]//按照首字母顺序排序
         */
        [self.tableView reloadData];
    }];
}

- (NSString *)transformCharacter:(NSString *)sourceStr
{
    NSMutableString *ms = [NSMutableString stringWithString:sourceStr];
    if (ms.length) {
        //将汉字转换成拼音
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformToLatin, NO);
        //将拼音的声调去掉
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        //将字符串所有的字母大写
        NSString *upStr = [ms uppercaseString];
        //截取首字母
        NSString *firstStr = [upStr substringToIndex:1];
        return firstStr;
    }
    return @"#";
}
- (IBAction)insertData:(UIButton *)sender {
    /*
    //批量添加数据
    NSArray *fontNameArr = [UIFont familyNames];
    long long telephone = 13584834983;
    for (int i = 0; i < fontNameArr.count; i++) {
        AddressBookModel *model = [[AddressBookModel alloc] init];
        model.name = fontNameArr[i];
        model.telephone = [NSString stringWithFormat:@"%lld", telephone--];
        [DataBase insertDataToDataBase:model];
    }
    [self.tableView reloadData];
     */
    InsertOrUpdateViewController *insertVC = [[InsertOrUpdateViewController alloc] init];
    insertVC.title = @"新建联系人";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:insertVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allKeys.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.left = 10;
    [headerView addSubview:label];
    label.text = self.allKeys[section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *firNameArray = [self.dataArr objectAtIndex:section];
    return firNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
        
    }
    NSArray *modelArray = [self.dataArr objectAtIndex:indexPath.section];
    AddressBookModel *model = [modelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.telephone;
    return cell;
//    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookIdentifier"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressBookCell" owner:self options:nil] lastObject];
//    }
//    return cell;
}

//右边的索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSArray *modelArray = [self.dataArr objectAtIndex:indexPath.section];
        AddressBookModel *model = [modelArray objectAtIndex:indexPath.row];
        [DataBase removeDataWithTelephone:model.telephone WithCallBack:^(BOOL isSuccess) {
            if (isSuccess) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [self _loadData];
            }else {
                NSLog(@"删除数据失败！");
            }
        }];
//        [DataBase removeDataWithTelephone:model.telephone];
        [self _loadData];
    }];
    return @[deleteAction];
}




@end
