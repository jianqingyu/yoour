//
//  NakedDriSeaTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedDriSeaListInfo.h"
typedef void (^NakedDriSeaBack)(BOOL isSel);
@interface NakedDriSeaTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)NakedDriSeaListInfo *seaInfo;
@property (nonatomic,  copy)NakedDriSeaBack back;
@end
