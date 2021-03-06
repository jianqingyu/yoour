//
//  ConfirmEditHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/18.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ConfirmEditHeadView.h"
@interface ConfirmEditHeadView()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *orderStaue;
@property (weak, nonatomic) IBOutlet UILabel *orderKing;
@end

@implementation ConfirmEditHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ConfirmEditHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"ConfirmEditHeadView" owner:nil options:nil][0];
}

- (void)setStaueInfo:(OrderNewInfo *)staueInfo{
    if (staueInfo) {
        _staueInfo = staueInfo;
        self.orderNum.text = _staueInfo.orderNum;
        self.orderStaue.text = _staueInfo.orderStatus;
        self.orderDate.text = _staueInfo.orderDate;
        self.orderKing.text = [OrderNumTool strWithPrice:_staueInfo.goldPrice];
    }
}

@end
