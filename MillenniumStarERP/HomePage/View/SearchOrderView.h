//
//  SearchOrderView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/24.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SeaDateBack)(id dateInfo);
@interface SearchOrderView : UIView
@property (nonatomic,copy)NSArray *arr;
- (id)initWithFrame:(CGRect)frame withDic:(NSArray *)btnArr;
@property (nonatomic,copy)SeaDateBack dateBack;
@property (nonatomic,assign)CGFloat viewWid;
- (void)setAllBtnSele;
@end
