//
//  CustomDrListiTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/30.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^StoneDriBack)(BOOL isSel);
@interface CustomDrListiTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)NSArray *listArr;
@property (nonatomic, copy)StoneDriBack stoneBack;
@end
