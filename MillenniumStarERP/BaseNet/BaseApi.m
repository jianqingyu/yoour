//
//  BaseApi.m
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "BaseApi.h"
#import "RequestClient.h"
#import "LoginViewController.h"
#import "ShowLoginViewTool.h"
#define version @"1.7"
@implementation BaseApi

+ (void)getNoLogGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = version;
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
//更新数据接口
+ (void)upData:(REQUEST_CALLBACK)callback URL:(NSString*)URL params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = version;
    [[RequestClient sharedClient] GET:URL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*通用GET接口弹出登录
 */
+ (void)getGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                             params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = version;
//    [OrderNumTool NSLoginWithStr:requestURL andDic:params];
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([responseObject[@"error"] intValue]==2) {
            [MBProgressHUD showError:@"需要登录"];
            [self gotoLoginView:callback requestURL:requestURL params:params];
            [SVProgressHUD dismiss];
            return ;
        }
        BaseResponse*result = [self resultWithDic:responseObject];
        if(callback){
            callback(result,nil);
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}

+ (void)gotoLoginView:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
               params:(NSMutableDictionary*)params{
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    LoginViewController *login = [LoginViewController new];
    login.noLogin = YES;
    login.back = ^(BOOL isYes){
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        [self getNoLogGeneralData:^(BaseResponse *response, NSError *error) {
            callback(response,nil);
        } requestURL:requestURL params:params];
    };
    [vc presentViewController:login animated:YES completion:nil];
}
/*通用POST接口
 */
+ (void)postGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                            params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = version;
    [[RequestClient sharedClient] POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*版本检查接口
 */
+ (void)getNewVerData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
               params:(NSMutableDictionary*)params{
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}

+ (BaseResponse *)resultWithDic:(NSDictionary *)dic{
    BaseResponse*result = [[BaseResponse alloc]init];
    result.error = dic[@"error"];
    result.data = dic[@"data"];
    result.message = dic[@"message"];
    return result;
}

//清楚队列
+ (void)cancelAllOperation{
    [[RequestClient sharedClient].operationQueue cancelAllOperations];
}

@end
