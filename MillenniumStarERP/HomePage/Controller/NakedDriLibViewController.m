//
//  NakedDriLibViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibViewController.h"
#import "NakedDriListOrderVc.h"
#import "NakedDriLibCustomView.h"
@interface NakedDriLibViewController ()
@end

@implementation NakedDriLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裸钻库";
    [self creatNakedDriView];
}

- (void)setRightNaviBar{
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 80, 30);
    [bar setTitle:@"我的订单" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:16];
    [bar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
}

- (void)btnClick:(id)sender{
    NakedDriListOrderVc *listVc = [NakedDriListOrderVc new];
    [self.navigationController pushViewController:listVc animated:YES];
}

- (void)creatNakedDriView{
    NakedDriLibCustomView *NakedDriView = [NakedDriLibCustomView creatCustomView];
    NakedDriView.isSel = self.isSel;
    NakedDriView.supNav = self.navigationController;
    [self.view addSubview:NakedDriView];
    [NakedDriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

@end
