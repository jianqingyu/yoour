//
//  ProductListVC.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
#import "NakedDriSeaListInfo.h"
@interface ProductListVC : BaseViewController
@property (nonatomic, strong) NSMutableDictionary *backDict;
@property (nonatomic, strong)NakedDriSeaListInfo *driInfo;
@end