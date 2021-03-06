//
//  StrWithIntTool.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/19.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "StrWithIntTool.h"

@implementation StrWithIntTool
/**
 *  把数组转成字符串
 */
+ (NSString *)strWithIntArr:(NSArray *)array{
    NSMutableString *spidStr = [NSMutableString string];
    int proId;
    if (array.count > 0)
    {
        for (int i = 0; i < array.count; ++i)
        {
            proId = [array[i]intValue];
            
            if (proId == 0)
            {
                continue;
            }
            
            if (i == array.count-1)
            {
                [spidStr appendString:[NSString stringWithFormat:@"%d",proId]];
            }
            else
            {
                [spidStr appendString:[NSString stringWithFormat:@"%d|",proId]];
            }
        }
    }
    return [spidStr copy];
}

+ (NSString *)strWithArr:(NSArray *)array{
    NSMutableString *spidStr = [NSMutableString string];
    NSString *proId;
    if (array.count > 0)
    {
        for (int i = 0; i < array.count; ++i)
        {
            proId = array[i];
            
            if (proId.length == 0)
            {
                continue;
            }
            
            if (i == array.count-1)
            {
                [spidStr appendString:[NSString stringWithFormat:@"%@",proId]];
            }
            else
            {
                [spidStr appendString:[NSString stringWithFormat:@"%@|",proId]];
            }
        }
    }
    return [spidStr copy];
}

+ (NSString *)strWithArr:(NSArray *)array With:(NSString *)str{
    return [self strWithArr:array and:str];
}

+ (NSString *)strWithArr:(NSArray *)array and:(NSString *)str{
    NSMutableString *spidStr = [NSMutableString string];
    if (array.count > 0){
        for (int i = 0; i < array.count; ++i){
            id proId = array[i];
            if (i == array.count-1){
                [spidStr appendString:[NSString stringWithFormat:@"%@",proId]];
            }else{
                [spidStr appendString:[NSString stringWithFormat:@"%@%@",proId,str]];
            }
        }
    }
    return [spidStr copy];
}

+ (NSString *)strWithIntOrStrArr:(NSArray *)array{
    NSMutableString *spidStr = [NSMutableString string];
    if (array.count > 0){
        for (int i = 0; i < array.count; ++i)
        {
            id proId = array[i];
            if (i == array.count-1)
            {
                [spidStr appendString:[NSString stringWithFormat:@"%@",proId]];
            }
            else
            {
                [spidStr appendString:[NSString stringWithFormat:@"%@|",proId]];
            }
        }
    }
    return [spidStr copy];
}

+ (NSData *)dataWithData:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image,1);
    if (data.length/1000>20) {
        return data;
    }else{
        CGFloat a = 20/data.length/1000;
        return UIImageJPEGRepresentation(image,a);
    }
}

@end
