//
//  NewEasyCusProDetailVC.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
#import "NakedDriSeaListInfo.h"
typedef void (^NewEasyEditBack)(id orderInfo);
@interface NewEasyCusProDetailVC : BaseViewController
@property (nonatomic,assign)int proId;
@property (nonatomic,assign)int isEdit;
@property (nonatomic,  copy)NewEasyEditBack orderBack;
@property (nonatomic,strong)NakedDriSeaListInfo *seaInfo;
@end
