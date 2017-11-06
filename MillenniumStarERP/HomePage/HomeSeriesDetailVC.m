//
//  HomeSeriesDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/23.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "HomeSeriesDetailVC.h"
#import "ProductInfo.h"
#import "NewHomePageCollCell.h"
#import "HomeSeriesHeadView.h"
#import "CustomProDetailVC.h"
#import "NewEasyCusProDetailVC.h"
#import "ProductCollectionCell.h"
#import "NewCustomProDetailVC.h"
@interface HomeSeriesDetailVC ()<UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property(nonatomic,   copy)NSString *photos;
@property (nonatomic,assign)int idxPage;
@property (nonatomic,  weak)UILabel *numLab;
@property (nonatomic,assign)BOOL isShowPrice;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (strong,nonatomic)UICollectionView *homeCollection;
@end

@implementation HomeSeriesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self setCollectionView];
    [self setupHeaderRefresh];
    [self creatNaviBtn];
    self.isShowPrice = ![[AccountTool account].isNoShow intValue];
    self.view.backgroundColor = DefaultColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    [self.homeCollection reloadData];
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

#pragma mark -- 网络请求
- (void)setupHeaderRefresh{
    // 刷新功能
    MJRefreshStateHeader*header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    [header setTitle:@"用力往下拉我!!!" forState:MJRefreshStateIdle];
    [header setTitle:@"快放开我!!!" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    _homeCollection.header = header;
    [self.homeCollection.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _homeCollection.footer = footer;
}
#pragma mark - MJRefresh
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
    }
    [self loadNewHomeData];
}

- (void)loadNewHomeData{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@modelListPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"category"] = _deInfo.key;
    params[@"cpage"] = @(curPage);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.homeCollection.header endRefreshing];
        [self.homeCollection.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]) {
                [self setupListDataWithDict:response.data];
                [self.homeCollection reloadData];
            }
        }
    } requestURL:url params:params];
}

//初始化列表数据
- (void)setupListDataWithDict:(NSDictionary *)data{
    if([YQObjectBool boolForObject:data[@"model"][@"modelList"]]){
        self.homeCollection.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [data[@"model"][@"list_count"]intValue];
        NSArray *seaArr = [ProductInfo objectArrayWithKeyValuesArray:data[@"model"][@"modelList"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.homeCollection.footer;
            [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            self.homeCollection.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.homeCollection.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        self.homeCollection.footer.state = MJRefreshStateNoMoreData;
    }
}

- (void)setCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5.0f;//左右间隔
    flowLayout.minimumLineSpacing = 5.0f;//上下间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(5,0,0,0);//边距距
    self.homeCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.homeCollection.backgroundColor = [UIColor whiteColor];
    self.homeCollection.delegate = self;
    self.homeCollection.dataSource = self;
    [self.view addSubview:_homeCollection];
    [_homeCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    if (@available(iOS 11.0, *)) {
        _homeCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _homeCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _homeCollection.scrollIndicatorInsets = _homeCollection.contentInset;
    }
    //设置当数据小于一屏幕时也能滚动
    self.homeCollection.alwaysBounceVertical = YES;
    UINib *nib = [UINib nibWithNibName:@"ProductCollectionCell" bundle:nil];
    [self.homeCollection registerNib:nib
           forCellWithReuseIdentifier:@"ProductCollectionCell"];
    //注册头视图
    [self.homeCollection registerClass:[HomeSeriesHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    UILabel *lab = [UILabel new];
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setLayerWithW:10 andColor:BordColor andBackW:0.0001];
    lab.hidden = YES;
    lab.backgroundColor = CUSTOM_COLOR_ALPHA(80, 80, 80, 0.5);
    [self.view addSubview:lab];
    [self.view bringSubviewToFront:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 24));
        make.bottom.equalTo(self.view).offset(-20);
    }];
    self.numLab = lab;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (totalCount==0) {
        return;
    }
    // 得到每页高度
    CGFloat pageWidth = sender.frame.size.height;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((sender.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
    //    NSLog(@"%d",currentPage);
    int toPage = totalCount%12==0?totalCount/12:totalCount/12+1;
    if (self.idxPage!=currentPage&&totalCount!=0) {
        self.idxPage = currentPage;
        self.numLab.text = [NSString stringWithFormat:@"%d/%d",self.idxPage/2+1,toPage];
        if(self.numLab.hidden){
            self.numLab.hidden = NO;
        }
    }
}

#pragma mark--CollectionView-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCollectionCell" forIndexPath:indexPath];
    collcell.isShow = !self.isShowPrice;
    ProductInfo *proInfo;
    if (indexPath.row<self.dataArray.count) {
        proInfo = self.dataArray[indexPath.row];
    }
    collcell.proInfo = proInfo;
    return collcell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat rowH = self.isShowPrice?80:51;
    int num = SDevWidth>SDevHeight?4:2;
    CGFloat width = (SDevWidth-(num-1)*5)/num;
    return CGSizeMake(width, width);
}
//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HomeSeriesHeadView *headV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        [headV.image sd_setImageWithURL:[NSURL URLWithString:_deInfo.pic] placeholderImage:DefaultImage];
        reusableView = headV;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGSizeMake(SDevWidth,SDevWidth*0.628);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //高级定制
    ProductInfo *info;
    if (indexPath.row<self.dataArray.count) {
        info = self.dataArray[indexPath.row];
    }
    if ([[AccountTool account].isNorm intValue]==0) {
        NewEasyCusProDetailVC *easyVc = [NewEasyCusProDetailVC new];
        easyVc.proId = info.id;
        [self.navigationController pushViewController:easyVc animated:YES];
    }else{
        NewCustomProDetailVC *newVc = [NewCustomProDetailVC new];
        newVc.proId = info.id;
        [self.navigationController pushViewController:newVc animated:YES];
//        CustomProDetailVC *customDeVC = [CustomProDetailVC new];
//        customDeVC.proId = info.id;
//        [self.navigationController pushViewController:customDeVC animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
