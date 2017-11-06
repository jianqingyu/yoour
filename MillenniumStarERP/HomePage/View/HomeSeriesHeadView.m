//
//  HomeSeriesHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/23.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "HomeSeriesHeadView.h"

@implementation HomeSeriesHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加头(尾)视图中的控件
        [self creatImageView];
    }
    return self;
}

- (void)creatImageView{
    UIImageView *img = [UIImageView new];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    self.image = img;
}

@end
