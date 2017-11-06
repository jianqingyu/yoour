//
//  NewEasyCusProDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewEasyCusProDetailVC.h"
#import "NewEasyConfirmOrderVc.h"
#import "DetailStoneInfo.h"
#import "CustomFirstCell.h"
#import "NewCustomProCell.h"
#import "CustomLastCell.h"
#import "MWPhotoBrowser.h"
#import "DetailTypeInfo.h"
#import "DetailModel.h"
#import "DetailTypeInfo.h"
#import "OrderListInfo.h"
#import "DetailHeadInfo.h"
#import "StrWithIntTool.h"
#import "CommonUtils.h"
#import "CustomJewelInfo.h"
#import "CustomPickView.h"
#import "CustomDriFirstCell.h"
#import "CustomDriWordCell.h"
#import "CustomShowView.h"
#import "HYBLoopScrollView.h"
#import "NakedDriSeaListInfo.h"
#import "NewChooseDriDetailVc.h"
#import "CustomDrListiTableCell.h"
@interface NewEasyCusProDetailVC ()<UINavigationControllerDelegate,UITableViewDelegate,
UITableViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic,  weak) UITableView *tableView;
@property (nonatomic,  weak) IBOutlet UIButton *lookBtn;
@property (nonatomic,  weak) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *allLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic,assign)int cou;
@property (nonatomic,assign)float wid;
@property (nonatomic,assign)float proPrice;
@property (nonatomic,  copy)NSString*proNum;
@property (nonatomic,  copy)NSString*handStr;
@property (nonatomic,  copy)NSString*lastMess;
@property (nonatomic,  copy)NSString *driCode;
@property (nonatomic,  copy)NSString *driPrice;
@property (nonatomic,  copy)NSString *driId;
@property (nonatomic,  copy)NSString *driWord;
@property (nonatomic,  copy)NSString *driWei;
@property (nonatomic,  copy)NSString *ModeSeqno;

@property (nonatomic,  copy)NSArray *stoneArr;
@property (nonatomic,  copy)NSArray *typeArr;
@property (nonatomic,  copy)NSArray *typeTArr;
@property (nonatomic,  copy)NSArray *typeSArr;
@property (nonatomic,  copy)NSArray*detailArr;
@property (nonatomic,  copy)NSArray*remakeArr;
@property (nonatomic,  copy)NSArray*IDarray;
@property (nonatomic,  copy)NSArray*headImg;
@property (nonatomic,  copy)NSArray*photos;
@property (nonatomic,  copy)NSArray *puritys;
@property (nonatomic,  copy)NSArray *handArr;
@property (nonatomic,  copy)NSArray *numArr;
@property (nonatomic,  copy)NSArray *chooseArr;

@property (nonatomic,  strong)NSMutableArray*mutArr;
@property (nonatomic,  strong)NSMutableArray*bools;
@property (nonatomic,  strong)DetailTypeInfo *colorInfo;
@property (nonatomic,  strong)UIView *hView;
@property (nonatomic,  strong)DetailModel *modelInfo;
@property (nonatomic,  strong)CustomPickView *pickView;
@property (nonatomic,  weak) CustomShowView *wordView;
@end

@implementation NewEasyCusProDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.wid = IsPhone?0.5:0.65;
    self.cou = 3;
    [self loadBaseCustomView];
}

- (void)loadBaseCustomView{
    self.proNum = @"1";
    [self.lookBtn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [self.addBtn setLayerWithW:5 andColor:BordColor andBackW:0.001];
    self.priceLab.hidden = [[AccountTool account].isNoShow intValue];
    self.allLab.hidden = [[AccountTool account].isNoShow intValue];
    [self.priceLab setAdjustsFontSizeToFitWidth:YES];
    self.lookBtn.hidden = !self.isEdit;
    self.bools = @[@NO,@NO,@NO,@NO].mutableCopy;
    self.typeArr = @[@"主   石",@"副石A",@"副石B",@"副石C"];
    self.typeSArr = @[@"stone",@"stoneA",@"stoneB",@"stoneC"];
    if (self.isEdit) {
        [self.addBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    self.mutArr = @[].mutableCopy;
    [self setBaseTableView];
    [self setupDetailData];
    [self setupPopView];
    [self creatNaviBtn];
    [self creatNearNetView:^(BOOL isWifi) {
        [self setupDetailData];
    }];
    [self setHandSize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNakedDri:)
                                                name:NotificationDriName object:nil];
}

- (void)changeNakedDri:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    [self setNakedDriDetailInfo:listInfo];
}
//改变裸石
- (void)setNakedDriDetailInfo:(NakedDriSeaListInfo *)listInfo{
    NSArray *infoArr = @[@"钻石",listInfo.Weight,[self modelWith:2 and:listInfo.Shape],
                         [self modelWith:3 and:listInfo.Color],[self modelWith:4 and:listInfo.Purity]];
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
    for (DetailStoneInfo *info in self.stoneArr) {
        info.isSel = NO;
    }
    for (DetailStoneInfo *info in self.stoneArr) {
        if ([listInfo.Weight floatValue]>=[info.minweight floatValue]&&
            [listInfo.Weight floatValue]<=[info.maxweight floatValue]) {
            info.isSel = YES;
            self.ModeSeqno = info.ModeSeqno;
            self.driWei = info.TrayModelWeight;
            self.proPrice = info.TrayModelPrice;
        }
    }
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
    [self changeTableHeadView];
    [self.tableView reloadData];
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
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:
                                      CGRectMake(0, 0, SDevWidth, 10)];
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
            [self changeCusProData:response.data];
            if (self.seaInfo) {
                [self setNakedDriDetailInfo:self.seaInfo];
                return ;
            }
            [self.tableView reloadData];
        }
    } requestURL:regiUrl params:params];
}
#pragma mark -- 赋值相关数据
- (void)changeCusProData:(NSDictionary *)data{
    if ([YQObjectBool boolForObject:data[@"jewelStone"]]) {
        [self addStoneWithDic:data[@"jewelStone"]];
    }
    if ([YQObjectBool boolForObject:data[@"modelPuritys"]]) {
        self.puritys = data[@"modelPuritys"];
        if (self.puritys.count==1) {
            self.colorInfo = [DetailTypeInfo objectWithKeyValues:self.puritys[0]];
        }
    }
    if ([YQObjectBool boolForObject:data[@"model"]]) {
        DetailModel *modelIn = [DetailModel objectWithKeyValues:data[@"model"]];
        self.proPrice = modelIn.price;
        [self setupBaseListData:modelIn];
        [self creatCusTomHeadView];
        [self setupModelPur:data[@"model"]];
    }
    if ([YQObjectBool boolForObject:data[@"stoneType"]]) {
        self.chooseArr = @[data[@"stoneType"],
                           data[@"stoneColor"],
                           data[@"stoneShape"],
                           data[@"stoneColor"],
                           data[@"stonePurity"]];
    }
    if ([YQObjectBool boolForObject:data[@"stoneSepData"]]) {
        self.cou = 4;
        self.stoneArr = [DetailStoneInfo objectArrayWithKeyValuesArray:data[@"stoneSepData"]];
        for (DetailStoneInfo *info in self.stoneArr) {
            if ([info.ModeSeqno isEqualToString:self.modelInfo.ModeSeqno]) {
                info.isSel = YES;
            }
            self.ModeSeqno = self.modelInfo.ModeSeqno;
        }
    }
    if ([YQObjectBool boolForObject:data[@"handSizeData"]]) {
        NSMutableArray *mutA = [NSMutableArray new];
        for (NSString *title in data[@"handSizeData"]) {
            [mutA addObject:@{@"title":title}];
        }
        self.handArr = mutA.copy;
    }
    if ([YQObjectBool boolForObject:data[@"remarks"]]) {
        self.remakeArr = data[@"remarks"];
    }
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
    self.detailArr  = @[[self arrWithDict:modelIn.stone],
                        [self arrWithDict:modelIn.stoneA],
                        [self arrWithDict:modelIn.stoneB],
                        [self arrWithDict:modelIn.stoneC]];
    [self setBaseMutArr];
}

- (void)setupModelPur:(NSDictionary *)dic{
    if (dic[@"modelPurityTitle"]) {
        DetailTypeInfo *info = [DetailTypeInfo new];
        info.title = dic[@"modelPurityTitle"];
        info.id = [dic[@"modelPurityId"]intValue];
        self.colorInfo = info;
    }
    if (dic[@"word"]) {
        self.driWord = dic[@"word"];
    }
}
//选择自带钻石
- (void)chooseStone{
    for (DetailStoneInfo *info in self.stoneArr) {
        if (info.isSel) {
            self.driPrice = @"";
            self.driCode = @"";
            self.driId = @"";
            self.ModeSeqno = info.ModeSeqno;
            self.driWei = info.TrayModelWeight;
            self.proPrice = info.TrayModelPrice;
            [self.mutArr removeAllObjects];
            self.detailArr = @[[self arrWithDict:info.stone],
                               [self arrWithDict:info.stoneA],
                               [self arrWithDict:info.stoneB],
                               [self arrWithDict:info.stoneC]];
            [self setBaseMutArr];
            [self.tableView reloadData];
        }
    }
}

- (void)setBaseMutArr{
    int i=0;
    for (NSArray *arr in self.detailArr) {
        if (i==0&&self.mutArr.count==0) {
            [self setMutAWith:arr];
        }else{
            if (![self boolWithNoArr:arr]) {
                [self setMutAWith:arr];
            }
        }
        i++;
    }
}

- (void)setMutAWith:(NSArray *)arr{
    NSMutableArray *mut = [NSMutableArray new];
    for (DetailTypeInfo *new in arr) {
        [mut addObject:[new newInfo]];
    }
    [self.mutArr addObject:mut];
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
        NSString *str = [self strWithNSUTF8:dict[@"pic"]];
        if (str.length>0) {
            [pic addObject:str];
        }
        NSString *strm = [self strWithNSUTF8:dict[@"picm"]];
        if (strm.length>0) {
            [mPic addObject:strm];
        }
        NSString *strb = [self strWithNSUTF8:dict[@"picb"]];
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

- (NSString *)strWithNSUTF8:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    //预览视图
    CustomShowView *show = [[CustomShowView alloc]init];
    [headView addSubview:show];
    [show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 75));
    }];
    show.hidden = YES;
    self.wordView = show;
    
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
        DetailTypeInfo *info = [dict allValues][0];
        if (staue==1) {
            self.colorInfo = info;
        }else if (staue==2){
            self.handStr = info.title;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self updateBottomPrice];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.mutArr.count+self.cou;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CustomDriFirstCell *firstCell = [CustomDriFirstCell cellWithTableView:tableView];
        firstCell.MessBack = ^(BOOL isSel,NSString *messArr){
            if (isSel) {
                if ([messArr isEqualToString:@"成色"]) {
                    [self openNumberAndhandSize:1 and:indexPath];
                }else{
                    self.proNum = messArr;
                    [self updateBottomPrice];
                }
            }else{
                [self openNumberAndhandSize:2 and:indexPath];
            }
        };
        if (self.driCode) {
            firstCell.certCode = self.driCode;
        }
        firstCell.colur = self.colorInfo.title;
        firstCell.modelInfo = self.modelInfo;
        firstCell.messArr = self.proNum;
        firstCell.handSize = self.handStr;
        if (_driWei.length>0) {
            firstCell.driWei = _driWei;
        }
        return firstCell;
    }else if (indexPath.row==self.mutArr.count+_cou-1){
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
        NSInteger index = indexPath.row-_cou+1;
        if (indexPath.row==1) {
            CustomDriWordCell *driCell = [CustomDriWordCell cellWithTableView:tableView];
            driCell.word = self.driWord;
            driCell.back = ^(BOOL isSel,NSString *word){
                if (isSel) {
                    self.driWord = word;
                }else{
                    self.wordView.wordLab.text = self.driWord;
                    self.wordView.hidden = NO;
                }
            };
            return driCell;
        }else if (indexPath.row==2&&self.cou==4){
            CustomDrListiTableCell *listCell = [CustomDrListiTableCell cellWithTableView:tableView];
            listCell.listArr = self.stoneArr;
            listCell.stoneBack = ^(BOOL isSel){
                //选择自带裸钻
                if (isSel) {
                    [self chooseStone];
                }
            };
            return listCell;
        }else{
            NewCustomProCell *proCell = [NewCustomProCell cellWithTableView:tableView];
            proCell.isSelSto = _modelInfo.isCanSelectStone;
            proCell.titleStr = self.typeArr[index];
            proCell.list = self.mutArr[index];
            if (self.driCode) {
                proCell.certCode = self.driCode;
            }
            proCell.isSel = [self.bools[index]boolValue];
            proCell.back = ^(BOOL isSel){
                [self.bools setObject:@(isSel) atIndexedSubscript:index];
            };
            return proCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==_cou-1) {
        [self gotoNakedDriLib];
    }
}

- (void)openNumberAndhandSize:(int)staue and:(NSIndexPath *)index{
    if (staue==2) {
        self.pickView.typeList = self.handArr;
        NSString *title = self.handStr?self.handStr:@"12";
        self.pickView.titleStr = @"手寸";
        self.pickView.selTitle = title;
    }else{
        self.pickView.titleStr = @"成色";
        self.pickView.typeList = self.puritys;
        self.pickView.selTitle = self.colorInfo.title;
    }
    self.pickView.section = index;
    self.pickView.staue = staue;
    [self showCustomPopView];
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

- (void)showCustomPopView{
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

- (void)gotoNakedDriLib{
    if (!_modelInfo.isCanSelectStone) {
        [MBProgressHUD showError:@"该产品不能选主石"];
        return;
    }
    NSString *str;
    for (DetailStoneInfo *info in self.stoneArr) {
        if (info.isSel) {
            if (info.minweight.length>0||info.maxweight.length>0) {
                str = [NSString stringWithFormat:@"%@,%@",info.minweight,info.maxweight];
            }
        }
    }
    NewChooseDriDetailVc *libVc = [NewChooseDriDetailVc new];
    if (str.length>0) {
        libVc.chooseWei = str;
    }
    [self.navigationController pushViewController:libVc animated:YES];
}

- (IBAction)lookOrder:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 提交订单
- (IBAction)addOrder:(id)sender {
    if (!_modelInfo.isCanSelectStone&&_driId.length>0) {
        [MBProgressHUD showError:@"该产品不能选裸钻"];
        return;
    }
    if (self.colorInfo.title.length==0) {
        [MBProgressHUD showError:@"请选择成色"];
        return;
    }
    if ([self.proNum length]==0) {
        [MBProgressHUD showError:@"请选择件数"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (int i=0; i<self.mutArr.count; i++) {
        if ([self.bools[i]boolValue]) {
            params[self.typeSArr[i]] = @"||||||1";
            continue;
        }
        NSMutableArray *arr = self.mutArr[i];
        if ([self boolWithNoArr:arr]) {
            continue;
        }
        [self paramsWithArr:arr andI:i andD:params];
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
    [mutA addObject:@"1"];
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
        detail = @"OrderCurrentEditModelItemForDefaultNowDo";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckOrderCurrentEditModelItemForDefaultDo";
    }else{
        detail = @"OrderCurrentDoModelItemForDefaultNowDo";
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
    if (self.ModeSeqno.length>0) {
        params[@"ModeSeqno"] = self.ModeSeqno;
    }
    if (!self.isEdit) {
        params[@"categoryId"] = @(self.modelInfo.categoryId);
    }
    if (self.lastMess.length>0) {
        params[@"remarks"] = self.lastMess;
    }
    params[@"productId"] = @(self.proId);
    params[@"modelQualityId"] = @1;
    if (self.driWord.length>0) {
        params[@"word"] = self.driWord;
    }
    params[@"modelPurityId"] = @(self.colorInfo.id);
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
            [MBProgressHUD showSuccess:@"添加订单成功"];
            NewEasyConfirmOrderVc *conVc = [NewEasyConfirmOrderVc new];
            [self.navigationController pushViewController:conVc animated:YES];
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
    float price = _proPrice*[self.proNum intValue];
    if (self.driPrice.length>0) {
        price = price + [self.driPrice floatValue];
    }
    self.priceLab.text = [NSString stringWithFormat:@"￥%0.0f",price];
}

@end
