//
//  LoginViewController.m
//  CityHousekeeper
//
//  Created by yjq on 15/11/18.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import "LoginViewController.h"
#import "CusTomLoginView.h"
#import "IQKeyboardManager.h"
#import "MainNavViewController.h"
#import "MainTabViewController.h"
#import "RegisterViewController.h"
#import "PassWordViewController.h"
//#import <LocalAuthentication/LocalAuthentication.h>
@interface LoginViewController ()
@property (nonatomic,  weak)CusTomLoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHomeView];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *name = [AccountTool account].userName;
    NSString *password = [AccountTool account].password;
    self.loginView.nameFie.text = name;
    self.loginView.passWordFie.text = password;
    if (_noLogin) {
        return;
    }
}
#pragma mark -- 加载登录页面
- (void)createHomeView{
    CusTomLoginView *loginV = [CusTomLoginView createLoginView];
    loginV.noLogin = _noLogin;
    [self.view addSubview:loginV];
    self.loginView = loginV;
    loginV.btnBack = ^(int staue){
        if (staue==1) {
            if (_noLogin) {
                [self dismissViewControllerAnimated:YES completion:nil];
                if (self.back) {
                    self.back(YES);
                }
                return;
            }
            [self changeHomeView];
        }else if (staue==2){
            [self registerClick];
        }else if (staue==3){
            [self forgotKeyClick];
        }else{
            [self changeHomeView];
        }
    };
    [loginV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

//#pragma mark -- 加载登录页数据
//- (void)loadNewVersion{
//    NSString *url = @"http://appapi2.fanerweb.com/api/Public/getUpdateVersionForYoour";
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"version"] = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
//    params[@"device"]  = @"ios";
//    [BaseApi getNewVerData:^(BaseResponse *response, NSError *error) {
//        if ([YQObjectBool boolForObject:response.data]&&[response.error intValue]==0) {
//            if ([response.data[@"value"]intValue]==0) {
//                NSString *token = [AccountTool account].tokenKey;
//                if (token.length>0&&!_noLogin) {
//                    static dispatch_once_t onceToken;
//                    dispatch_once(&onceToken, ^{
//                            //指纹验证
//                        [self authenticateUser];
//                    });
//                }
//            }else{
//                self.versionDic = response.data;
//                [self loadAlertView:response.data];
//            }
//        }
//    } requestURL:url params:params];
//}
//
//- (void)loadAlertView:(NSDictionary *)dic{
//    BOOL isYes = [dic[@"value"]intValue]==1;
//    self.isVer = [dic[@"value"]intValue]==2;
//    [NewUIAlertTool show:dic[@"message"] okBack:^{
//        [self btnShowClick];
//    } andView:self.view yes:isYes];
//}
//
//
//- (void)authenticateUser{
//    //初始化上下文对象
//    LAContext* context = [[LAContext alloc]init];
//    //错误对象
//    NSError* error = nil;
//    NSString* result = @"通过验证指纹解锁应用";
//    //首先使用canEvaluatePolicy 判断设备支持状态
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
//        //支持指纹验证
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result
//                          reply:^(BOOL success, NSError *error) {
//              if (success) {
//                  //验证成功，主线程处理UI
//                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                      [self changeHomeView];
//                  }];
//                  return;
//              }
//        }];
//    }else{
//        //不支持指纹识别，LOG出错误详情
//    }
//}

- (void)changeHomeView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[MainTabViewController alloc]init];
}
#pragma mark -- 注册与忘记密码操作
- (void)registerClick{
    RegisterViewController *regiVC = [[RegisterViewController alloc]init];
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:regiVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (void)forgotKeyClick{
    PassWordViewController *passVc = [[PassWordViewController alloc]init];
    passVc.title = @"忘记密码";
    passVc.isForgot = YES;
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:passVc];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

@end
