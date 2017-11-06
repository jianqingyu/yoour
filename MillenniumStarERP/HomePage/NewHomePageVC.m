//
//  NewHomePageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewHomePageVC.h"
#import "NewHomeShopInfo.h"
#import "HomeSeriesDetailVC.h"
#import "NewHomePageCollCell.h"
#import "NewHomePageHeaderView.h"
#import "HomeListWebViewVc.h"
@interface NewHomePageVC ()<UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) NSArray *list;
@property(nonatomic,strong) NSArray *photos;
@property(strong,nonatomic) UICollectionView *homeCollection;
@property(nonatomic,strong) NewHomePageHeaderView *headerView;
@end

@implementation NewHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    [self loadNewHomeData];
//    self.picUrl = @"http://appapi2.fanerweb.com/html/pages/xl/banner.jpg";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)
        name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
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

- (void)loadNewHomeData{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@IndexPageForYoour",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]) {
                SaveCustomData *data = [SaveCustomData save];
                data.guest = response.data[@"tokenKey"];
                self.photos = [NewHomeShopInfo objectArrayWithKeyValuesArray:response.data[@"scrollAd"]];
                NSArray *arr = [NewHomeShopInfo objectArrayWithKeyValuesArray:response.data[@"classAd_1"]];
                NSArray *arr1 = [NewHomeShopInfo objectArrayWithKeyValuesArray:response.data[@"classAd_2"]];
                self.list = @[arr,arr1];
                [self.homeCollection reloadData];
            }
        }
    } requestURL:url params:params];
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
    UINib *nib = [UINib nibWithNibName:@"NewHomePageCollCell" bundle:nil];
    [self.homeCollection registerNib:nib
           forCellWithReuseIdentifier:@"NewHomePageCollCell"];
    
    [self.homeCollection registerClass:[NewHomePageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];             //注册头视图
}

#pragma mark--CollectionView-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = self.list[section];
    return arr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = (SDevWidth-5)*0.5;
    CGSize size = CGSizeMake(width, width/1.60);
    if (indexPath.section%2==1) {
        width = SDevWidth;
        size = CGSizeMake(width, width*0.41);
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {       //头视图
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        _headerView.infoArr = self.photos;
        reusableView = _headerView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGSizeMake(SDevWidth,SDevWidth/1.56);
    }
    return CGSizeZero;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(SDevWidth, SDevHeight/3);

//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewHomePageCollCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewHomePageCollCell" forIndexPath:indexPath];
    NSArray *arr = self.list[indexPath.section];
    NewHomeShopInfo *info = arr[indexPath.row];
    [collcell.itemImage sd_setImageWithURL:[NSURL URLWithString:info.pic] placeholderImage:DefaultImage];
    return collcell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tArr =@[@"http://appapi2.fanerweb.com/html/wyshow.html",
                     @"http://appapi2.fanerweb.com/html/ppwh.html"];
    NSArray *arr = self.list[indexPath.section];
    NewHomeShopInfo *info = arr[indexPath.row];
    if (indexPath.section%2==0) {
        HomeSeriesDetailVC *detailVc = [HomeSeriesDetailVC new];
        detailVc.deInfo = info;
        [self.navigationController pushViewController:detailVc animated:YES];
    }else{
        HomeListWebViewVc *webVc = [HomeListWebViewVc new];
        webVc.url = tArr[indexPath.row];
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
