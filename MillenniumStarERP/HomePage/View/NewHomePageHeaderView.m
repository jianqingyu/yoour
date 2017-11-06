//
//  NewHomePageHeaderView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewHomePageHeaderView.h"
#import "NewHomeShopInfo.h"
#import "HYBLoopScrollView.h"
@interface NewHomePageHeaderView()
@property (nonatomic,strong)NSMutableArray *arr;
@end
@implementation NewHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加头(尾)视图中的控件
    }
    return self;
}

- (void)setLoopScrollView:(NSArray *)arr{
    [UIView animateWithDuration:0.1 animations:^{
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               CGRectMake(0, 0, SDevWidth, SDevWidth/1.56) imageUrls:arr];
    loop.timeInterval = 3.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self addSubview:loop];
}

- (void)setInfoArr:(NSArray *)infoArr{
    if (infoArr) {
        _infoArr = infoArr;
        NSMutableArray *mutA = [NSMutableArray new];
        for (NewHomeShopInfo *info in _infoArr) {
            [mutA addObject:info.pic];
        }
        [self setLoopScrollView:mutA];
    }
}

@end
