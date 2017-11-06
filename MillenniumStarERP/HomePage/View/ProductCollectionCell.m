//
//  ProductCollectionCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/9.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ProductCollectionCell.h"
@interface ProductCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *modeLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (nonatomic,assign)BOOL isSel;
@end
@implementation ProductCollectionCell
//数据更新
- (void)setProInfo:(ProductInfo *)proInfo{
    if (proInfo) {
        if (!self.isSel) {
            [self setLayerWithW:0.001 andColor:BordColor andBackW:0.5];
        }
        _proInfo = proInfo;
        self.bottomV.hidden = YES;
        self.titleLab.text = _proInfo.title;
        self.modeLab.text = _proInfo.modelNum;
        self.desLab.text = _proInfo.describe;
        NSString *image = _proInfo.pic;
        if (!IsPhone) {
            image = _proInfo.picm;
        }
        [self.headView sd_setImageWithURL:[NSURL URLWithString:image]
                         placeholderImage:DefaultImage];
        self.priceLab.text = [OrderNumTool strWithPrice:_proInfo.price];
        self.isSel = YES;
    }
}

@end
