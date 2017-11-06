//
//  NewChooseDriDetailVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/25.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewChooseDriDetailVc.h"
#import "NakedDriLibCustomView.h"
@interface NewChooseDriDetailVc ()

@end

@implementation NewChooseDriDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择裸钻";
    [self creatNakedDriView];
}

- (void)creatNakedDriView{
    NakedDriLibCustomView *NakedDriView = [NakedDriLibCustomView creatCustomView];
    NakedDriView.isSel = YES;
    NakedDriView.chooseWei = self.chooseWei;
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
