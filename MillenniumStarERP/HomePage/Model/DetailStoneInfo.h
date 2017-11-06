//
//  DetailStoneInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailStoneInfo : NSObject
@property (nonatomic,  copy)NSString *title;
@property (nonatomic,  copy)NSString *minweight;
@property (nonatomic,  copy)NSString *maxweight;
@property (nonatomic,  copy)NSString *ModeSeqno;
@property (nonatomic,assign)float TrayModelPrice;
@property (nonatomic,  copy)NSString *TrayModelWeight;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,strong)NSDictionary *stone;
@property (nonatomic,strong)NSDictionary *stoneA;
@property (nonatomic,strong)NSDictionary *stoneB;
@property (nonatomic,strong)NSDictionary *stoneC;
@end
