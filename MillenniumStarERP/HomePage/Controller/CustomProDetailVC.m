//
//  CustomProDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/13.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomProDetailVC.h"
#import "ConfirmOrderVC.h"
#import "CustomFirstCell.h"
#import "CustomProCell.h"
#import "CustomEditTableCell.h"
#import "CustomLastCell.h"
#import "CusDetailHeadView.h"
#import "DetailTextCustomView.h"
#import "MWPhotoBrowser.h"
#import "ETFoursquareImages.h"
#import "DetailTypeInfo.h"
#import "DetailModel.h"
#import "DetailTypeInfo.h"
#import "OrderListInfo.h"
#import "DetailHeadInfo.h"
#import "StrWithIntTool.h"
#import "CommonUtils.h"
#import "CustomJewelInfo.h"
#import "CustomPickView.h"
#import "HYBLoopScrollView.h"
#import "NakedDriSeaListInfo.h"
#import "NakedDriLibViewController.h"
@interface CustomProDetailVC ()<UINavigationControllerDelegate,UITableViewDelegate,
                   UITableViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic,  weak) UITableView *tableView;
@property (nonatomic,  weak) IBOutlet UIButton *lookBtn;
@property (nonatomic,  weak) IBOutlet UIButton *addBtn;
@property (nonatomic,  weak) IBOutlet UILabel *numLab;
@property (nonatomic,assign)float wid;
@property (nonatomic,  copy)NSArray *typeArr;
@property (nonatomic,  copy)NSArray *typeTArr;
@property (nonatomic,  copy)NSArray *typeSArr;
@property (nonatomic,  copy)NSArray*chooseArr;
@property (nonatomic,  copy)NSArray*detailArr;
@property (nonatomic,  copy)NSString*proNum;
@property (nonatomic,  copy)NSString*handStr;
@property (nonatomic,  copy)NSArray*remakeArr;
@property (nonatomic,  copy)NSArray*IDarray;
@property (nonatomic,  copy)NSArray*headImg;
@property (nonatomic,  copy)NSArray*photos;
@property (nonatomic,  copy)NSArray*specTitles;
@property (nonatomic,  copy)NSString*lastMess;
@property (nonatomic,  copy)NSArray *handArr;
@property (nonatomic,  copy)NSArray *numArr;
@property (nonatomic,  strong)NSMutableArray*mutArr;
@property (nonatomic,  strong)NSMutableArray*nums;
@property (nonatomic,  strong)NSMutableArray*bools;
@property (nonatomic,    copy)NSString *driCode;
@property (nonatomic,    copy)NSString *driPrice;
@property (nonatomic,    copy)NSString *driId;
@property (nonatomic,  strong)DetailModel *modelInfo;
@property (nonatomic,  strong)CustomPickView *pickView;
@property (nonatomic,  strong)DetailTextCustomView *textCView;
@property (nonatomic,  strong)UIView *hView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *allLab;
@end

@implementation CustomProDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.wid = IsPhone?0.5:0.65;
    [self loadBaseCustomView];
}

- (void)loadBaseCustomView{
    self.proNum = @"1";
    [self.numLab setLayerWithW:8 andColor:BordColor andBackW:0.001];
    [self.lookBtn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [self.addBtn setLayerWithW:5 andColor:BordColor andBackW:0.001];
    self.priceLab.hidden = [[AccountTool account].isNoShow intValue];
    self.allLab.hidden = [[AccountTool account].isNoShow intValue];
    [self.priceLab setAdjustsFontSizeToFitWidth:YES];
    [self.numLab setAdjustsFontSizeToFitWidth:YES];
    if (self.isEdit) {
        [self.lookBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.addBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    self.typeArr = @[@"主   石",@"副石A",@"副石B",@"副石C"];
    self.typeSArr = @[@"stone",@"stoneA",@"stoneB",@"stoneC"];
    self.mutArr = @[].mutableCopy;
    self.nums = @[@"",@"",@"",@""].mutableCopy;
    self.bools = @[@YES,@NO,@NO,@NO].mutableCopy;
    [self setBaseTableView];
    [self setupPopView];
    [self setupTextView];
    [self setupDetailData];
    [self creatNaviBtn];
    [self creatNearNetView:^(BOOL isWifi) {
        [self setupDetailData];
    }];
    [self setHandSize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDri:)
                                           name:NotificationDriName object:nil];
}
//改变裸石
- (void)changeDri:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    NSArray *infoArr = @[@"钻石",listInfo.Weight,[self modelWith:2 and:listInfo.Shape],[self modelWith:3 and:listInfo.Color],[self modelWith:4 and:listInfo.Purity]];
    NSArray *arr = self.mutArr[0];
    for (int i=0; i<arr.count; i++) {
        DetailTypeInfo *info = arr[i];
        info.id = 1;
        info.title = infoArr[i];
    }
    self.driCode = listInfo.CertCode;
    self.driPrice = listInfo.Price;
    self.driId = listInfo.id;
    self.proNum = @"1";
    [self.bools setObject:@NO atIndexedSubscript:0];
    [self.tableView reloadData];
}

- (void)setBaseNakedDriSeaInfo{
    if (!self.seaInfo) {
        return;
    }
    NakedDriSeaListInfo *listInfo = self.seaInfo;
    NSArray *infoArr = @[@"钻石",listInfo.Weight,[self modelWith:2 and:listInfo.Shape],[self modelWith:3 and:listInfo.Color],[self modelWith:4 and:listInfo.Purity]];
    if (self.mutArr.count==0) {
        NSMutableArray *mutA = [NSMutableArray new];
        for (int i=0; i<5; i++) {
            DetailTypeInfo *info = [DetailTypeInfo new];
            info.id = 1;
            info.title = infoArr[i];
            [mutA addObject:info];
        }
        [self.mutArr addObject:mutA];
    }else{
        NSArray *arr = self.mutArr[0];
        for (int i=0; i<arr.count; i++) {
            DetailTypeInfo *info = arr[i];
            info.id = 1;
            info.title = infoArr[i];
        }
    }
    self.driCode = listInfo.CertCode;
    self.driPrice = listInfo.Price;
    self.driId = listInfo.id;
    self.proNum = @"1";
    [self.tableView reloadData];
}

- (void)addStoneWithDic:(NSDictionary *)data{
    CustomJewelInfo *CusInfo = [CustomJewelInfo objectWithKeyValues:data];
    NSArray *infoArr = @[@"钻石",CusInfo.jewelStoneWeight,[self modelWith:2 and:CusInfo.jewelStoneShape],[self modelWith:3 and:CusInfo.jewelStoneColor],[self modelWith:4 and:CusInfo.jewelStonePurity]];
    NSMutableArray *mutA = [NSMutableArray new];
    for (int i=0; i<5; i++) {
        DetailTypeInfo *info = [DetailTypeInfo new];
        info.id = 1;
        info.title = infoArr[i];
        [mutA addObject:info];
    }
    self.driCode = CusInfo.jewelStoneCode;
    self.driPrice = CusInfo.jewelStonePrice;
    self.driId = CusInfo.jewelStoneId;
    self.proNum = @"1";
    [self.mutArr addObject:mutA];
    [self.bools setObject:@NO atIndexedSubscript:0];
    [self.tableView reloadData];
}

- (NSString *)modelWith:(int)idx and:(NSString *)obj{
    NSString *str = obj;
    if (idx>self.chooseArr.count) {
        return str;
    }
    if (![YQObjectBool boolForObject:obj]) {
        DetailTypeInfo *info = self.chooseArr[idx][0];
        str = info.title;
    }
    return str;
}

- (void)orientChange:(NSNotification *)notification{
    self.textCView.frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    [self changeTableHeadView];
}

- (void)changeTableHeadView{
    if (SDevHeight>SDevWidth) {
        [self.hView removeFromSuperview];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
        }];
        [self setupHeadView:self.headImg and:YES];
    }else{
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SDevWidth*self.wid);
        }];
        [self setupHeadView:self.headImg and:NO];
    }
}

- (void)setBaseTableView{
    UITableView *table = [[UITableView alloc]init];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = UITableViewAutomaticDimension;
    table.estimatedRowHeight = 125;
    [self.view addSubview:table];
    CGFloat headF = 0;
    if (!IsPhone){
        headF = 20;
    }
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(headF);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.tableView = table;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 10)];
}

- (void)setHandSize{
    self.typeTArr = @[@"类型",@"规格",@"形状",@"颜色",@"净度"];
    self.numArr = @[@{@"title":@"1"},@{@"title":@"2"},@{@"title":@"3"},
                  @{@"title":@"4"}, @{@"title":@"5"},@{@"title":@"6"},
                  @{@"title":@"7"},@{@"title":@"8"},@{@"title":@"9"},
                  @{@"title":@"10"},@{@"title":@"11"},@{@"title":@"12"},
                  @{@"title":@"13"},@{@"title":@"14"},@{@"title":@"15"},
                  @{@"title":@"16"},@{@"title":@"17"},@{@"title":@"18"}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    App;
    [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 54, 54);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES]; 
}

#pragma mark -- loadData 初始化数据
- (void)setupDetailData{
    [SVProgressHUD show];
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"ModelDetailPageForCurrentOrderEditPage";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckModelDetailPageForCurrentOrderEditPage";
    }else{
        detail = @"ModelDetailPage";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"id";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *tokenKey = [AccountTool account].tokenKey;;
    if (tokenKey.length>0) {
        params[@"tokenKey"] = tokenKey;
    }else{
        params[@"tokenKey"] = [SaveCustomData save].guest;
    }
    params[proId] = @(_proId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"jewelStone"]]) {
                [self addStoneWithDic:response.data[@"jewelStone"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"model"]]) {
                DetailModel *modelIn = [DetailModel objectWithKeyValues:
                                                       response.data[@"model"]];
                [self setupBaseListData:modelIn];
                [self creatCusTomHeadView];
                [self.tableView reloadData];
            }
            if ([YQObjectBool boolForObject:response.data[@"stoneType"]]) {
                self.chooseArr = @[response.data[@"stoneType"],
                                   response.data[@"stoneColor"],
                                   response.data[@"stoneShape"],
                                   response.data[@"stoneColor"],
                                   response.data[@"stonePurity"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"handSizeData"]]) {
                NSMutableArray *mutA = [NSMutableArray new];
                for (NSString *title in response.data[@"handSizeData"]) {
                    [mutA addObject:@{@"title":title}];
                }
                self.handArr = mutA.copy;
            }
            if ([YQObjectBool boolForObject:response.data[@"remarks"]]) {
                self.remakeArr = response.data[@"remarks"];
            }
            [self setBaseNakedDriSeaInfo];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)setupBaseListData:(DetailModel *)modelIn{
    self.modelInfo = modelIn;
    self.lastMess = modelIn.remark;
    if (self.isEdit) {
        self.proNum = modelIn.number;
        if (![modelIn.handSize isEqualToString:@"0"]) {
            self.handStr = modelIn.handSize;
        }
    }
    [self setupNumbers:@[modelIn.stone,modelIn.stoneA,
                         modelIn.stoneB,modelIn.stoneC]];
    self.detailArr  = @[[self arrWithDict:modelIn.stone],
                        [self arrWithDict:modelIn.stoneA],
                        [self arrWithDict:modelIn.stoneB],
                        [self arrWithDict:modelIn.stoneC]];
    [self setBaseMutArr];
    self.specTitles = @[[self arrWithTitle:modelIn.stone],
                        [self arrWithTitle:modelIn.stoneA],
                        [self arrWithTitle:modelIn.stoneB],
                        [self arrWithTitle:modelIn.stoneC]];
    [self.bools setObject:@(modelIn.isSelfStone) atIndexedSubscript:0];
    [self.bools setObject:[self boolWithStone:modelIn.stoneA] atIndexedSubscript:1];
    [self.bools setObject:[self boolWithStone:modelIn.stoneB] atIndexedSubscript:2];
    [self.bools setObject:[self boolWithStone:modelIn.stoneC] atIndexedSubscript:3];
}

- (void)setBaseMutArr{
    for (NSArray *arr in self.detailArr) {
        if (![self boolWithNoArr:arr]) {
            [self setMutAWith:arr];
        }
    }
}

- (void)setMutAWith:(NSArray *)arr{
    NSMutableArray *mut = [NSMutableArray new];
    for (DetailTypeInfo *new in arr) {
        [mut addObject:[new newInfo]];
    }
    [self.mutArr addObject:mut];
}

- (void)setupNumbers:(NSArray *)stoneArr{
    for (int i=0; i<stoneArr.count; i++) {
        NSDictionary *dict = stoneArr[i];
        if ([YQObjectBool boolForObject:dict[@"number"]]) {
            NSString *numStr = [dict[@"number"] description];
            [self.nums setObject:numStr atIndexedSubscript:i];
        }
    }
}

- (id)boolWithStone:(NSDictionary *)dict{
    id isStone = @NO;
    if ([YQObjectBool boolForObject:dict[@"stoneOut"]]) {
        isStone = dict[@"stoneOut"];
    }
    return isStone;
}

- (NSString *)arrWithTitle:(NSDictionary *)dict{
    NSString *str;
    if ([YQObjectBool boolForObject:dict[@"specSelectTitle"]]) {
        str = dict[@"specSelectTitle"];
    }
    return str;
}

- (NSMutableArray *)arrWithDict:(NSDictionary *)dict{
    DetailTypeInfo *in1 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"typeTitle"]]) {
        in1.id = [dict[@"typeId"]intValue];
        in1.title = dict[@"typeTitle"];
    }
    DetailTypeInfo *in2 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"specTitle"]]) {
        in2.title = dict[@"specTitle"];
    }
    DetailTypeInfo *in3 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"shapeTitle"]]) {
        in3.id = [dict[@"shapeId"]intValue];
        in3.title = dict[@"shapeTitle"];
    }
    DetailTypeInfo *in4 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"colorTitle"]]) {
        in4.id = [dict[@"colorId"]intValue];
        in4.title = dict[@"colorTitle"];
    }
    DetailTypeInfo *in5 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"purityTitle"]]) {
        in5.id = [dict[@"purityId"]intValue];
        in5.title = dict[@"purityTitle"];
    }
    return @[in1,in2,in3,in4,in5].mutableCopy;
}
#pragma mark - 初始化图片
- (void)creatCusTomHeadView{
    NSMutableArray *pic  = @[].mutableCopy;
    NSMutableArray *mPic = @[].mutableCopy;
    NSMutableArray *bPic = @[].mutableCopy;
    for (NSDictionary*dict in self.modelInfo.pics) {
        NSString *str = [dict[@"pic"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (str.length>0) {
            [pic addObject:str];
        }
        NSString *strm = [dict[@"picm"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (strm.length>0) {
            [mPic addObject:strm];
        }
        NSString *strb = [dict[@"picb"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (strb.length>0) {
            [bPic addObject:strb];
        }
    }
    NSArray *headArr;
    if (mPic.count==0) {
        mPic = @[@"pic"].mutableCopy;
    }
    if (IsPhone) {
        headArr = mPic.copy;
    }else{
        headArr = bPic.copy;
    }
    self.headImg = headArr;
    self.IDarray = [bPic copy];
    [self changeTableHeadView];
}

- (void)setupHeadView:(NSArray *)headArr and:(BOOL)isHead{
    CGRect headF = CGRectMake(0, 0, SDevWidth*self.wid, SDevHeight-60);
    if (!IsPhone){
        headF = CGRectMake(0, 20, SDevWidth*self.wid, SDevHeight-80);
    }
    if (isHead) {
        headF = CGRectMake(0, 0, SDevWidth, SDevWidth);
    }
    UIView *headView = [[UIView alloc]initWithFrame:headF];
    CGFloat wid = headView.width;
    CGFloat height = headView.height;
    CGRect frame = CGRectMake(0, 0, wid, height);
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               frame imageUrls:headArr];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        [self didImageWithIndex:atIndex];
    };
    loop.alignment = kPageControlAlignRight;
    [headView addSubview:loop];
    self.hView = headView;
    if (isHead) {
        self.tableView.tableHeaderView = self.hView;
    }else{
        [self.view addSubview:self.hView];
        [self.view sendSubviewToBack:self.hView];
    }
}

- (void)didImageWithIndex:(NSInteger)index{
    //网络图片展示
    if (self.IDarray.count==0) {
        [MBProgressHUD showError:@"暂无图片"];
        return;
    }
    [self networkImageShow:index];
}

- (void)networkImageShow:(NSUInteger)index{
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *str in self.IDarray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [photos addObject:photo];
    }
    self.photos = [photos copy];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count){
        return [_photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark -- CustomPopView
- (void)setupPopView{
    CustomPickView *popV = [[CustomPickView alloc]init];
    popV.popBack = ^(int staue,id dict){
        NSIndexPath *path = [dict allKeys][0];
        DetailTypeInfo *info = [dict allValues][0];
        if (staue==1) {
            [self chooseType:dict];
        }else if (staue==2){
            self.handStr = info.title;
        }else if (staue==3){
            [self.nums setObject:info.title atIndexedSubscript:path.section];
        }else if (staue==4){
            self.lastMess = [NSString stringWithFormat:@"%@%@",self.lastMess,info.title];
        }
        [self.tableView reloadData];
        [self dismissCustomPopView];
    };
    [self.view addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.pickView = popV;
    [self dismissCustomPopView];
}

#pragma mark -- CustomPopView
- (void)setupTextView{
    DetailTextCustomView *popV = [[DetailTextCustomView alloc]initWithFrame:
                           CGRectMake(0, 0, SDevWidth, SDevHeight)];
    popV.textBack = ^(id dict){
        [self chooseType:dict];
    };
    self.textCView = popV;
}
//选择石头
- (void)chooseType:(NSDictionary *)dict{
    NSIndexPath *path = [dict allKeys][0];
    DetailTypeInfo *info = [dict allValues][0];
    NSMutableArray *arr = self.mutArr[path.section];
    [arr setObject:info atIndexedSubscript:path.row];
    if (path.section!=0) {
        [self.bools setObject:@NO atIndexedSubscript:path.section];
    }
}
//一个石头里面的数据齐全
- (BOOL)boolWithArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length==0) {
            return NO;
        }
    }
    return YES;
}
//一个石头里面的数据都是空的
- (BOOL)boolWithNoArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length>0) {
            return NO;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
    [self.textCView removeFromSuperview];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self updateBottomPrice];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
                         numberOfRowsInSection:(NSInteger)section{
    return self.mutArr.count+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CustomFirstCell *firstCell = [CustomFirstCell cellWithTableView:tableView];
        firstCell.MessBack = ^(BOOL isSel,NSString *messArr){
            if (isSel) {
                self.proNum = messArr;
            }else{
                [self openNumberAndhandSize:2 and:indexPath];
            }
        };
        if (self.driCode) {
            firstCell.certCode = self.driCode;
        }
        firstCell.modelInfo = self.modelInfo;
        firstCell.messArr = self.proNum;
        firstCell.handSize = self.handStr;
        return firstCell;
    }else if (indexPath.row==self.mutArr.count+1){
        CustomEditTableCell *editCell = [CustomEditTableCell cellWithTableView:tableView];
        editCell.back = ^(id staue){
            [self editStoneWith:staue];
        };
        return editCell;
    }else if (indexPath.row==self.mutArr.count+2){
        CustomLastCell *lastCell = [CustomLastCell cellWithTableView:tableView];
        [lastCell.btn addTarget:self action:@selector(openRemark:)
                                  forControlEvents:UIControlEventTouchUpInside];
        lastCell.messBack = ^(id message){
            if ([message isKindOfClass:[NSString class]]) {
                self.lastMess = message;
            }
        };
        lastCell.message = self.lastMess;
        return lastCell;
    }else{
        CustomProCell *proCell = [CustomProCell cellWithTableView:tableView];
        NSString *str = self.typeArr[indexPath.row-1];
        proCell.number = self.nums[indexPath.row-1];
        proCell.titleStr = str;
        proCell.isSel = [self.bools[indexPath.row-1]boolValue];
        proCell.list = self.mutArr[indexPath.row-1];
        if (self.driPrice) {
            proCell.driP = self.driPrice;
        }
        proCell.tableBack = ^(id index){
            BOOL isYes = NO;
            if ([index isKindOfClass:[NSNumber class]]) {
                int row = [index intValue];
                if (row==10) {
                    isYes = YES;
                }
            }
            if (self.driCode.length&&!isYes&&[str isEqualToString:@"主   石"]) {
                [MBProgressHUD showError:@"不可选择"];
                return;
            }
            if ([index isKindOfClass:[NSString class]]) {
                NSIndexPath *inPath = [NSIndexPath indexPathForRow:0
                                                         inSection:indexPath.row-1];
                [self openNumberAndhandSize:3 and:inPath];
            }else if ([index isKindOfClass:[NSDictionary class]]){
                BOOL ishave = [index[@"主石"] boolValue];
                [self.bools setObject:@(ishave) atIndexedSubscript:indexPath.row-1];
            }else{
                int row = [index intValue];
                if (row==10) {
                    [self gotoNakedDriLib];
                }else{
                    NSIndexPath *inPath = [NSIndexPath indexPathForRow:row
                                                             inSection:indexPath.row-1];
                    [self openPopTableWithInPath:inPath];
                }
            }
        };
        return proCell;
    }
}

- (void)showCustomPopView{
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

- (void)gotoNakedDriLib{
    NakedDriLibViewController *libVc = [NakedDriLibViewController new];
    libVc.isSel = YES;
    [self.navigationController pushViewController:libVc animated:YES];
}

- (void)openNumberAndhandSize:(int)staue and:(NSIndexPath *)index{
    if (staue==2) {
        self.pickView.typeList = self.handArr;
        NSString *title = self.handStr?self.handStr:@"12";
        self.pickView.titleStr = @"手寸";
        self.pickView.selTitle = title;
    }else{
        self.pickView.typeList = self.numArr;
        self.pickView.titleStr = @"数量";
        self.pickView.selTitle = self.nums[index.section];
    }
    self.pickView.section = index;
    self.pickView.staue = staue;
    [self showCustomPopView];
}

- (void)editStoneWith:(id)number{
    int num = [number intValue];
    switch (num) {
        case 1:{
            if (self.mutArr.count==0) {
                [MBProgressHUD showError:@"没有石头"];
                return;
            }
            if (self.mutArr.count==1) {
                self.driPrice = @"";
                self.driCode = @"";
                self.driId = @"";
            }
            NSArray *arr = _detailArr[self.mutArr.count-1];
            [self.mutArr removeLastObject];
            [self setMutAWith:arr];
            [self.tableView reloadData];
        }
            break;
        case 2:
            if (self.mutArr.count==0) {
                [MBProgressHUD showError:@"没有石头"];
                return;
            }
            if (self.mutArr.count==1) {
                self.driPrice = @"";
                self.driCode = @"";
                self.driId = @"";
            }
            [self.mutArr removeLastObject];
            [self.tableView reloadData];
            break;
        case 3:{
            if (self.mutArr.count==4) {
                [MBProgressHUD showError:@"不能添加石头了"];
                return;
            }
            NSArray *arr = _detailArr[self.mutArr.count];
            [self setMutAWith:arr];
            [self.tableView reloadData];
            }
            break;
        default:
            break;
    }
}

- (void)openPopTableWithInPath:(NSIndexPath *)inPath{
    if (inPath.row==1) {
        NSString *titleStr = self.specTitles[inPath.section];
        self.textCView.section = inPath;
        self.textCView.topLab.text = titleStr;
        [self.view addSubview:self.textCView];
    }else{
        NSArray *dictArr = self.chooseArr[inPath.row];
        NSArray *list = self.mutArr[inPath.section];
        DetailTypeInfo *info = list[inPath.row];
        self.pickView.typeList = dictArr;
        self.pickView.section = inPath;
        self.pickView.titleStr = self.typeTArr[inPath.row];
        self.pickView.selTitle = info.title;
        self.pickView.staue = 1;
        [self showCustomPopView];
    }
}

- (void)openRemark:(id)sender{
    if (self.remakeArr.count==0) {
        [MBProgressHUD showError:@"没有备注可选"];
        return;
    }
    self.pickView.typeList = self.remakeArr;
    self.pickView.section = [NSIndexPath indexPathForRow:0 inSection:0];
    self.pickView.titleStr = @"备注";
    self.pickView.staue = 4;
    [self showCustomPopView];
}

- (IBAction)lookOrder:(id)sender {
    if (self.isEdit) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark -- 提交订单
- (IBAction)addOrder:(id)sender {
    if ([self.proNum length]==0) {
        [MBProgressHUD showError:@"请选择件数"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (int i=0; i<self.mutArr.count; i++) {
        NSMutableArray *arr = self.mutArr[i];
        BOOL isAdd = [self boolWithArr:arr]&&[self.nums[i] length]>0;
        BOOL isNoAdd = [self boolWithNoArr:arr]&&[self.nums[i] length]==0;
        BOOL isYes = [self.bools[0] boolValue];
        if (i==0&&isYes) {
            [self paramsWithArr:arr andI:i andD:params];
        }else{
            if (isYes) {
                params[self.typeSArr[i]] = @"||||||1";
                continue;
            }
            if (isAdd) {
                [self paramsWithArr:arr andI:i andD:params];
            }else if (!isNoAdd){
                NSString *str = @"请填写红框";
                [MBProgressHUD showError:str];
                return;
            }
        }
    }
    [self addOrderWithDict:params];
}

- (void)paramsWithArr:(NSArray *)arr andI:(int)i andD:(NSMutableDictionary *)params{
    NSMutableArray *mutA = @[].mutableCopy;
    for (DetailTypeInfo *info in arr) {
        if (info.id) {
            [mutA addObject:@(info.id)];
        }else{
            if (info.title) {
                [mutA addObject:info.title];
            }else{
                [mutA addObject:@""];
            }
        }
    }
    [mutA addObject:self.nums[i]];
    NSString *str = [StrWithIntTool strWithIntOrStrArr:mutA];
    NSString *key = self.typeSArr[i];
    if (![key isEqualToString:@"stone"]) {
        str = [NSString stringWithFormat:@"%@|0",str];
    }
    params[self.typeSArr[i]] = str;
}

- (void)addOrderWithDict:(NSMutableDictionary *)params{
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"OrderCurrentEditModelItemDo";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckOrderCurrentEditModelItemDo";
    }else{
        detail = @"OrderDoCurrentModelItemDo";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"productId";
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[proId] = @(self.proId);
    params[@"number"] = self.proNum;
    if ([self.handStr length]>0) {
        params[@"handSize"] = self.handStr;
    }
    if (self.driId.length>0) {
        params[@"jewelStoneId"] = self.driId;
        params[@"stone"] = @"";
    }
    params[@"isSelfStone"] = self.bools[0];
    if (!self.isEdit) {
        params[@"categoryId"] = @(self.modelInfo.categoryId);
    }
    if (_qualityId&&_colorId) {
        params[@"qualityId"] = @(_qualityId);
        params[@"purityId"] = @(_colorId);
    }
    if (self.lastMess.length>0) {
        params[@"remarks"] = self.lastMess;
    }
    [self addOrderData:params andUrl:regiUrl];
}

- (void)addOrderData:(NSMutableDictionary *)params andUrl:(NSString *)netUrl{
    [SVProgressHUD show];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (self.isEdit) {
                [self loadEditType:response.data];
                return;
            }
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
                [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
            }
            [MBProgressHUD showSuccess:@"添加订单成功"];
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:netUrl params:params];
}

- (void)loadEditType:(NSDictionary *)data{
    OrderListInfo *listI = [OrderListInfo objectWithKeyValues:data];
    if (self.orderBack) {
        self.orderBack(listI);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBottomPrice{
    float price = _modelInfo.price;
    if (self.driPrice.length>0) {
       price = price + [self.driPrice floatValue];
    }
    self.priceLab.text = [NSString stringWithFormat:@"￥%0.0f",price];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
