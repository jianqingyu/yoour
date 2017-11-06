//
//  SaveCustomData.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/10/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SaveCustomData.h"

@implementation SaveCustomData
//单例
+ (instancetype)save
{
    static dispatch_once_t once = 0;
    static SaveCustomData *data;
    dispatch_once(&once, ^{
        data = [[SaveCustomData alloc]init];
    });
    return data;
}
@end
