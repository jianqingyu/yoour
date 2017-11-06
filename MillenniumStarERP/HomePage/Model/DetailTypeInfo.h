//
//  DetailTypeInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/9.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailTypeInfo : NSObject
@property (nonatomic,assign)int id;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *price;
- (DetailTypeInfo *)newInfo;
@end
