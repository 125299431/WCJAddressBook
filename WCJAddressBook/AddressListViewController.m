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

@interface AddressListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSArray *allKeys;//右边的索引


@property (nonatomic, strong) UISearchController *searchVC;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = 40;
    self.tableView.sectionFooterHeight = 0.000001;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _initView];
    [self _loadData];
}

- (void)_initView
{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
////    self.searchBar.backgroundColor = [UIColor redColor];
//    self.searchBar.placeholder = @"搜索";
//    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
////    self.searchBar.showsCancelButton = YES;
//    [self.searchBar setShowsCancelButton:YES animated:YES];
//    self.searchBar.barStyle = UIBarStyleDefault;
//    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [self.view addSubview:self.searchBar];
    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchVC.delegate = self;
    self.searchVC.searchResultsUpdater = self;
    self.searchVC.dimsBackgroundDuringPresentation = NO;
    self.searchVC.obscuresBackgroundDuringPresentation = NO;
    self.searchVC.hidesNavigationBarDuringPresentation = YES;
    self.searchVC.searchBar.placeholder = @"搜索";
    self.searchVC.searchBar.frame = CGRectMake(self.searchVC.searchBar.frame.origin.x, self.searchVC.searchBar.frame.origin.y, self.searchVC.searchBar.frame.size.width, 44);
    self.searchVC.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.tableView.tableHeaderView = self.searchVC.searchBar;
//    self.tableView.top = self.searchBar.bottom;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadData
{
    [DataBase selectDataFromDataBaseCallBack:^(NSArray *array) {
        [self compareDataWith:array];
    }];
}

- (void)compareDataWith:(NSArray *)array
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
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
    
    //批量添加数据
    NSArray *fontNameArr = [UIFont familyNames];
    long long telephone = 13584834983;
    for (int i = 0; i < fontNameArr.count; i++) {
        AddressBookModel *model = [[AddressBookModel alloc] init];
        model.name = fontNameArr[i];
        model.telephone = [NSString stringWithFormat:@"%lld", telephone--];
        [DataBase insertDataToDataBase:model WithCallBack:^(BOOL isSuccess) {
            [self.tableView reloadData];
        }];
    }
    [self.tableView reloadData];
     
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchVC.active = NO;
    NSLog(@"%ld组-----%ld行被点击", indexPath.section, indexPath.row);
    InsertOrUpdateViewController *insertVC = [[InsertOrUpdateViewController alloc] init];
    insertVC.title = @"联系人详情";
    NSArray *modelArray = [self.dataArr objectAtIndex:indexPath.section];
    AddressBookModel *model = [modelArray objectAtIndex:indexPath.row];
    insertVC.phoneStr = model.telephone;
    insertVC.nameStr = model.name;
    insertVC.isInsertPhone = YES;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:insertVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:nil];
    });
    //    [self.navigationController pushViewController:insertVC animated:YES];
    
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

#pragma mark----UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.active) {
        if (searchController.searchBar.text.length == 0) {
            self.allKeys = nil;
            self.dataArr = nil;
            [self.tableView reloadData];
            return;
        }
        [DataBase selectPreciseDataFromDataBaseWithString:searchController.searchBar.text CallBack:^(NSArray *array) {
            [self compareDataWith:array];
        }];
    }else {
        [self _loadData];
    }
  
}





@end
