//
//  NewEasyConfirmOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewEasyConfirmOrderVc.h"
#import "ConfirmOrdCell.h"
#import "NakedDriConfirmHeadV.h"
#import "ConfirmOrderVC.h"
#import "ChooseAddressVC.h"
#import "OrderListInfo.h"
#import "AddressInfo.h"
#import "DetailTypeInfo.h"
#import "SearchCustomerVC.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
#import "OrderPriceInfo.h"
#import "OrderNewInfo.h"
#import "PayViewController.h"
#import "InvoiceViewController.h"
#import "ProductionOrderVC.h"
#import "NewEasyCusProDetailVC.h"
@interface NewEasyConfirmOrderVc ()<UITableViewDelegate,UITableViewDataSource,ConfirmOrdCellDelegate,NakedDriConfirmHeadVDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) NakedDriConfirmHeadV *headView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selectDataArray;
@property (nonatomic,strong)NSArray *priceArr;
@property (nonatomic,strong)DetailTypeInfo *invoInfo;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@property (nonatomic,strong)AddressInfo *addressInfo;
@property (nonatomic,assign)BOOL isSelBtn;
@end

@implementation NewEasyConfirmOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatConfirmOrder];
}

- (void)creatConfirmOrder{
    [self setupTableView];
    [self setupTableHeadView];
    self.dataArray = @[].mutableCopy;
    self.selectDataArray = @[].mutableCopy;
    self.conBtn.layer.cornerRadius = 5;
    self.conBtn.layer.masksToBounds = YES;
    self.title = @"确认订单";
    [self setupHeaderRefresh];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
        make.right.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setupTableHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 235-96)];
    headView.backgroundColor = DefaultColor;
    NakedDriConfirmHeadV *headV = [[NakedDriConfirmHeadV alloc]initWithFrame:CGRectZero];
    headV.delegate = self;
    [headView addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(-10);
        make.right.equalTo(headView).offset(0);
    }];
    self.tableView.tableHeaderView = headView;
    self.headView = headV;
}
//选择客户
- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.headView.customFie.text = cusInfo.customerName;
    }
}
//选择地址
- (void)setAddressInfo:(AddressInfo *)addressInfo{
    if (addressInfo) {
        _addressInfo = addressInfo;
        self.headView.addInfo = _addressInfo;
    }
}
#pragma mark -- 头视图的点击事件 HeadViewDelegate
- (void)btnClick:(NakedDriConfirmHeadV *)headView andIndex:(NSInteger)index andMes:(NSString *)mes{
    switch (index) {
        case 0:
            [self pushEditVC];
            break;
        case 1:
            if (self.isSelBtn) return;
            [self pushSearchVC];
            break;
        case 2:
            [self pushInvoiceVc];
            break;
        case 3:
            [self loadHaveCustomer:mes];
        default:
            break;
    }
}

- (void)pushEditVC{
    ChooseAddressVC *editVc = [ChooseAddressVC new];
    editVc.addBack = ^(AddressInfo *info){
        self.addressInfo = info;
    };
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)pushSearchVC{
    SearchCustomerVC *cusVc = [SearchCustomerVC new];
    cusVc.searchMes = self.headView.customFie.text;
    cusVc.back = ^(id dict){
        self.cusInfo = dict;
    };
    [self.navigationController pushViewController:cusVc animated:YES];
}

- (void)pushInvoiceVc{
    InvoiceViewController *InvoVc = [InvoiceViewController new];
    InvoVc.invoInfo = self.invoInfo;
    InvoVc.invoBack = ^(id dict){
        self.invoInfo = dict;
        if (self.invoInfo.price) {
            NSString *invoStr = [NSString stringWithFormat:@"类型:%@ 抬头:%@",
                                 self.invoInfo.title,self.invoInfo.price];
            self.headView.invoMes = invoStr;
        }else{
            self.headView.invoMes = self.invoInfo.title;
        }
    };
    [self.navigationController pushViewController:InvoVc animated:YES];
}

- (void)loadHaveCustomer:(NSString *)message{
    if (self.isSelBtn) {
        return;
    }
    self.isSelBtn = YES;
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@IsHaveCustomer",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = message;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        self.isSelBtn = NO;
        if ([response.error intValue]==0) {
            if ([response.data[@"state"]intValue]==0) {
                SHOWALERTVIEW(@"没有此客户记录");
                self.cusInfo.customerID = 0;
            }else if([response.data[@"state"]intValue]==1){
                self.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"customer"]];
            }else if ([response.data[@"state"]intValue]==2){
                [self pushSearchVC];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}
#pragma mark -- 网络请求
- (void)setupHeaderRefresh{
    // 刷新功能
    MJRefreshStateHeader*header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    [header setTitle:@"用力往下拉我!!!" forState:MJRefreshStateIdle];
    [header setTitle:@"快放开我!!!" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    _tableView.header = header;
    [self.tableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _tableView.footer = footer;
}
#pragma mark - refresh
- (void)headerRereshing{
    [self loadNewRequestWith:YES];
}

- (void)footerRereshing{
    [self loadNewRequestWith:NO];
}

- (void)loadNewRequestWith:(BOOL)isPullRefresh{
    if (isPullRefresh){
        curPage = 1;
        [self.dataArray removeAllObjects];
        [self.selectDataArray removeAllObjects];
    }
    self.allBtn.selected = NO;
    [self syncPriceLabel];
    [self getCommodityData];
}
#pragma mark - 网络数据
- (void)getCommodityData{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(curPage);
    NSString *url = [NSString stringWithFormat:@"%@OrderListNowPage",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setupDataWithDict:response.data];
                [self setupListDataWithDict:response.data[@"currentOrderlList"]];
                [self.tableView reloadData];
                self.view.userInteractionEnabled = YES;
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}
//更新数据
- (void)setupDataWithDict:(NSDictionary *)dict{
    if ([YQObjectBool boolForObject:dict[@"address"]]&&!self.addressInfo) {
        self.addressInfo = [AddressInfo objectWithKeyValues:
                            dict[@"address"]];
    }
    if (dict[@"customer"]&&!self.cusInfo) {
        self.cusInfo = [CustomerInfo objectWithKeyValues:
                        dict[@"customer"]];
    }
    if (dict[@"orderInfo"]) {
        OrderNewInfo *orderInfo = [OrderNewInfo objectWithKeyValues:dict[@"orderInfo"]];
        self.invoInfo = [DetailTypeInfo new];
        self.invoInfo.price = orderInfo.invoiceTitle;
        self.invoInfo.title = orderInfo.invoiceType;
    }
}
//更新list数据
- (void)setupListDataWithDict:(NSDictionary *)dicList{
    if([YQObjectBool boolForObject:dicList[@"list"]]){
        self.tableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dicList[@"list_count"]intValue];
        NSArray *seaArr = [OrderListInfo objectArrayWithKeyValuesArray:dicList[@"list"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _tableView.footer.state = MJRefreshStateNoMoreData;
    }
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConfirmOrdCell *ordCell = [ConfirmOrdCell cellWithTableView:tableView];
    ordCell.tag = indexPath.section;
    ordCell.delegate = self;
    OrderListInfo *collectInfo;
    if (indexPath.section < self.dataArray.count)
    {
        collectInfo= self.dataArray[indexPath.section];
    }
    ordCell.listInfo = collectInfo;
    return ordCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self editIndex:indexPath.section];
}

#pragma mark -- cell中的按钮点击
- (void)btnCellClick:(ConfirmOrdCell *)headView andIndex:(NSInteger)index{
    NSInteger ind = headView.tag;
    switch (index) {
        case 0:
            [self selectBtnClick:ind];
            break;
        case 1:
            [self editIndex:ind];
            break;
        case 2:
            [self deleteIndex:ind];
            break;
        default:
            break;
    }
}
//勾选
- (void)selectBtnClick:(NSInteger )indx
{
    if (indx < self.dataArray.count)
    {
        OrderListInfo *OrderListInfo = self.dataArray[indx];
        if (OrderListInfo.isSel == YES)
        {
            [self.selectDataArray removeObject:OrderListInfo];
            self.allBtn.selected = NO;
        }else{
            [self.selectDataArray addObject:OrderListInfo];
        }
        OrderListInfo.isSel = !OrderListInfo.isSel;
        if ([self isAllYes]) {
            self.allBtn.selected = YES;
        }
        //同步显示
        [self syncPriceLabel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:indx];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL)isAllYes {
    for (OrderListInfo *OrderListInfo in _dataArray) {
        if (!OrderListInfo.isSel) {
            return NO;
        }
    }
    return YES;
}
//编辑
- (void)editIndex:(NSInteger)index{
    //高级定制
    OrderListInfo *collectInfo;
    if (index < self.dataArray.count)
    {
        collectInfo= self.dataArray[index];
    }
    NewEasyCusProDetailVC *easyVc = [NewEasyCusProDetailVC new];
    easyVc.proId = collectInfo.id;
    easyVc.isEdit = 1;
    easyVc.orderBack = ^(OrderListInfo *dict){
        [self detailOrderBack:dict andIdx:index];
    };
    [self.navigationController pushViewController:easyVc animated:YES];
}

- (void)detailOrderBack:(OrderListInfo *)dict andIdx:(NSInteger)index{
    OrderListInfo *collectInfo;
    if (index < self.dataArray.count)
    {
        collectInfo= self.dataArray[index];
    }
    if (![dict isKindOfClass:[OrderListInfo class]]) {
        return;
    }
    self.dataArray[index] = dict;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    self.allBtn.selected = NO;
    if ([self.selectDataArray containsObject:collectInfo]){
        [self.selectDataArray removeObject:collectInfo];
    }
    [self syncPriceLabel];
}
//删除
- (void)deleteIndex:(NSInteger)index{
    OrderListInfo *collectInfo;
    if (index < self.dataArray.count)
    {
        collectInfo= self.dataArray[index];
    }
    NSString *httpStr = @"OrderCurrentDeleteModelItemDo";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,httpStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"itemId"] = @(collectInfo.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
    [self.dataArray removeObjectAtIndex:index];
    if ([self.selectDataArray containsObject:collectInfo])
    {
        [self.selectDataArray removeObject:collectInfo];
    }
    [self syncPriceLabel];
    [self.tableView reloadData];
}
#pragma mark -- 底部的价格与按钮
//更新价格
- (void)syncPriceLabel{
    double value = 0.0;
    if (_selectDataArray.count){
        for (OrderListInfo *collectInfo in _selectDataArray)
        {
            value = value+collectInfo.price;
        }
    }
    NSString *price = [OrderNumTool strWithPrice:value];
    self.priceLab.text = [NSString stringWithFormat:@"参考总价:%@",price];
}
//底部按钮
- (IBAction)chooseClick:(UIButton *)sender {
    if (sender.selected == NO)
    {
        [self.selectDataArray removeAllObjects];
        [self.selectDataArray addObjectsFromArray:self.dataArray];
        for (OrderListInfo *collInfo in self.dataArray) {
            collInfo.isSel = YES;
        }
        sender.selected = YES;
    }else{
        for (OrderListInfo *collInfo in self.dataArray) {
            collInfo.isSel = NO;
        }
        sender.selected = NO;
        [self.selectDataArray removeAllObjects];
    }
    [self syncPriceLabel];
    [self.tableView reloadData];
}

- (IBAction)confirmClick:(id)sender {
    [self confirmOrder];
}
//提交订单
- (void)confirmOrder{
    if (!self.addressInfo) {
        [MBProgressHUD showError:@"请选择地址"];
        return;
    }
    if (!self.cusInfo.customerID) {
        [MBProgressHUD showError:@"请选择客户"];
        return;
    }
    if (!self.selectDataArray.count) {
        [MBProgressHUD showError:@"请选择商品"];
        return;
    }
    [self submitOrders];
}

- (void)submitOrders{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (OrderListInfo *collInfo in _selectDataArray) {
        [mutArr addObject:@(collInfo.id)];
    }
    NSString *url = [NSString stringWithFormat:@"%@OrderCurrentSubmitNowDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"itemId"] = [StrWithIntTool strWithIntArr:mutArr];
    params[@"addressId"] = @(self.addressInfo.id);
//    if (self.headView.noteFie.text.length>0) {
//        params[@"orderNote"] = _headView.noteFie.text;
//    }
    if (self.invoInfo.title.length>0) {
        params[@"invTitle"] = self.invoInfo.price;
        params[@"invType"] = @(self.invoInfo.id);
    }
    params[@"customerID"] = @(self.cusInfo.customerID);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"提交成功"];
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
            }
            [self gotoNextViewConter:response.data];
            [self.tableView.header beginRefreshing];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}
//是否需要付款 是否下单ERP
- (void)gotoNextViewConter:(id)dic{
    if ([dic[@"isNeetPay"]intValue]==1) {
        [MBProgressHUD showError:@"暂未开通支付"];
        return;
        PayViewController *payVc = [PayViewController new];
        payVc.orderId = dic[@"orderNum"];
        [self.navigationController pushViewController:payVc animated:YES];
    }else{
        if ([dic[@"isErpOrder"]intValue]==0) {
            ConfirmOrderVC *oDetailVc = [ConfirmOrderVC new];
            oDetailVc.editId = [dic[@"id"] intValue];
            [self.navigationController pushViewController:oDetailVc animated:YES];
        }else{
            ProductionOrderVC *proVc = [ProductionOrderVC new];
            proVc.orderNum = dic[@"orderNum"];
            [self.navigationController pushViewController:proVc animated:YES];
        }
    }
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:
                                       self.navigationController.viewControllers];
    NSInteger index = self.navigationController.viewControllers.count;
    [navigationArray removeObjectAtIndex: index-2];
    self.navigationController.viewControllers = navigationArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
