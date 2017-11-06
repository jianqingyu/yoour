//
//  CustomPickView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTypeInfo.h"
typedef void (^CustomBtmPickBack)(int staue,id model);
@interface CustomPickView : UIView
@property (nonatomic,  copy)NSArray *typeList;
@property (nonatomic,strong)NSIndexPath *section;
@property (nonatomic,  copy)NSString *titleStr;
@property (nonatomic,assign)int staue;
@property (nonatomic,  copy)CustomBtmPickBack popBack;
@property (nonatomic,strong)DetailTypeInfo *selInfo;
@property (nonatomic,  copy)NSString *selTitle;
@end
