//
//  MainTabViewController.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/7.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "MainTabViewController.h"
#import "MainNavViewController.h"
#import "ProductListVC.h"
#import "EditUserInfoVC.h"
#import "HelpMenuVC.h"
#import "HomePageVC.h"
#import "NewHomePageVC.h"
#import "InformationVC.h"
#import "NetworkDetermineTool.h"
#import "UserCenterViewController.h"
#import "NakedDriLibViewController.h"
@interface MainTabViewController ()<UITabBarControllerDelegate>

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    NewHomePageVC *newPage = [[NewHomePageVC alloc]init];
    [self addChildVcWithVC:newPage Title:@"首页"imageName:@"icon_ho"
            selectImage:@"icon_ho2-1"];
    
    ProductListVC *listVc = [[ProductListVC alloc]init];
    [self addChildVcWithVC:listVc Title:@"产品"imageName:@"icon_cps1"
               selectImage:@"icon_cps_2-1"];
    
    NakedDriLibViewController *libVc = [[NakedDriLibViewController alloc]init];
    [self addChildVcWithVC:libVc Title:@"裸石库" imageName:@"icon_dm"
               selectImage:@"icon_dm_2-1"];
    
    InformationVC *infoVc = [[InformationVC alloc]init];
    [self addChildVcWithVC:infoVc Title:@"设计师" imageName:@"icon_index_s"
               selectImage:@"icon_index-1"];
    
    EditUserInfoVC *userVC = [[EditUserInfoVC alloc]init];
    [self addChildVcWithVC:userVC Title:@"我的" imageName:@"icon_set"
               selectImage:@"icon_set2-1"];
     UIImage *backImg = [CommonUtils createImageWithColor:BarColor];
     [self.tabBar setBackgroundImage:backImg];
}

- (void)addChildVcWithVC:(UIViewController *)vc Title:(NSString *)title
            imageName:(NSString *)imageName selectImage:(NSString *)selectImage{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:
        UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
    selectDict[NSForegroundColorAttributeName] = MAIN_COLOR;
    selectDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [vc.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
    
    NSMutableDictionary *norDict = [NSMutableDictionary dictionary];
    norDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    norDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [vc.tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    MainNavViewController *nav = [[MainNavViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context{
//    if([keyPath isEqualToString:@"tabCount"]){
//        if (homePage.tabCount!=0){
//            infoVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",homePage.tabCount];
//        }else{
//            infoVC.tabBarItem.badgeValue = nil;
//        }
//    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
                 shouldSelectViewController:(UIViewController *)viewController{
    if (![NetworkDetermineTool isExistenceNet]) {
        [NetworkDetermineTool changeSupNaviWithNav:(MainNavViewController *)viewController];
    }
    return YES;
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
