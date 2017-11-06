//
//  CusTomLoginView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/3.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CusTomLoginView.h"
#import "ZBButten.h"
#import "NetworkDetermineTool.h"
@interface CusTomLoginView()<UITextFieldDelegate>
@property (weak, nonatomic) UITextField *codeField;
@property (weak, nonatomic) UIView *loginView;
@property (weak, nonatomic) UIButton *loginBtn;
@property (weak, nonatomic) ZBButten *codeBtn;
@property (weak, nonatomic) UIImageView *backImg;
@property (weak, nonatomic) UIView *logView;
@property (weak, nonatomic) UIButton *noBtn;
@property (weak, nonatomic) UIButton *xBtn;
@property (copy, nonatomic) NSString *code;
@end

@implementation CusTomLoginView

+ (CusTomLoginView *)createLoginView{
    static CusTomLoginView *_loginView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loginView = [[CusTomLoginView alloc]init];
    });
    return _loginView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR(241, 241, 241);
        [self creatBaseView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!IsPhone) {
        return;
    }
    if (SDevWidth>SDevHeight) {
        CGFloat mar = 10;
        if (SDevHeight>320) {
            mar = SDevHeight*0.1;
        }
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(mar);
        }];
    }else{
        CGFloat mar = SDevHeight*0.20;
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(mar);
        }];
    }
}

- (void)setNoLogin:(BOOL)noLogin{
    self.noBtn.hidden = noLogin;
    self.xBtn.hidden = !noLogin;
}

- (void)creatBaseView{
    CGFloat wid = MIN(SDevWidth, SDevHeight)*0.5;
    CGFloat loWid = MIN(SDevWidth, SDevHeight)*0.7;
    if (!IsPhone) {
        wid = MIN(SDevWidth, SDevHeight)*0.3;
        loWid = MIN(SDevWidth, SDevHeight)*0.4;
    }
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_03"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(MIN(SDevWidth, SDevHeight)*0.25);
        make.centerX.mas_equalTo(self.centerX);
        make.size.mas_equalTo(CGSizeMake(wid, wid/3));
    }];
    self.backImg = imageV;
    
    UILabel *lab = [UILabel new];
    lab.textColor = CUSTOM_COLOR(40, 40, 40);
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = appVer;
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
    }];
    
    UIButton *TouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    TouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [TouBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TouBtn setTitle:@"游客模式" forState:UIControlStateNormal];
    [TouBtn addTarget:self action:@selector(touClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [TouBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    [self addSubview:TouBtn];
    [TouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).with.offset(5);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 26));
    }];
    self.noBtn = TouBtn;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setBackgroundImage:[UIImage imageNamed:@"icon_close"]
                                                 forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(canClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(30);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.xBtn = cancel;
    //底部登录页面
    UIView *loginV = [[UIView alloc]init];
    loginV.backgroundColor = [UIColor clearColor];
    [self addSubview:loginV];
    [loginV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).with.offset(MIN(SDevWidth, SDevHeight)*0.15);
        make.centerX.mas_equalTo(self.centerX);
        make.width.mas_equalTo(loWid);
        make.bottom.equalTo(self).offset(0);
    }];
    self.logView = loginV;
    
    [self creatListView:loginV isC:1];
    [self creatListView:loginV isC:2];
    UIView *listView3 = [self creatListView:loginV isC:3];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.backgroundColor = MAIN_COLOR;
    [loginBtn setTitle:@"登  陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:)
                               forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    [loginV addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listView3.mas_bottom).with.offset(25);
        make.left.equalTo(loginV).offset(0);
        make.right.equalTo(loginV).offset(0);
        make.height.mas_equalTo(@35);
    }];
    
    UIButton *restBtn = [self creatBtnWith:@"注册账号" andV:loginV];
    restBtn.tag = 2;
    [restBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginV).offset(-10);
        make.left.equalTo(loginV).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UIButton *eidtBtn = [self creatBtnWith:@"忘记密码" andV:loginV];
    eidtBtn.tag = 3;
    [eidtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginV).offset(-10);
        make.right.equalTo(loginV).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    NSString *name = [AccountTool account].userName;
    NSString *password = [AccountTool account].password;
    _nameFie.text = name;
    _passWordFie.text = password;
}

- (UIButton *)creatBtnWith:(NSString *)title andV:(UIView *)subV{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editBtn setTitle:title forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(bottomClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [subV addSubview:editBtn];
    return editBtn;
}

- (UIView *)creatListView:(UIView *)loginV isC:(int)staue{
    CGFloat heightMar = 5;
    CGFloat fieH = 20;
    CGFloat viewH = (staue-1)*(0.8+39);
    UIView *view = [[UIView alloc]init];
    [loginV addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginV).offset(viewH);
        make.left.equalTo(loginV).offset(0);
        make.right.equalTo(loginV).offset(0);
        make.height.mas_equalTo((fieH+heightMar+0.8));
    }];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_07"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(heightMar);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(fieH, fieH));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = BordColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(heightMar+2);
        make.left.equalTo(image.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(0.8, fieH-4));
    }];
    
    UITextField *fie = [[UITextField alloc]init];
    fie.textColor = [UIColor blackColor];
    fie.font = [UIFont systemFontOfSize:12];
    [view addSubview:fie];
    [fie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(heightMar);
        make.left.equalTo(line.mas_right).with.offset(5);
        make.right.equalTo(view).offset(0);
        make.height.mas_equalTo(fieH);
    }];
    switch (staue) {
        case 1:
            fie.placeholder = @"用户名/手机号码";
            self.nameFie = fie;
            break;
        case 2:
            fie.placeholder = @"请输入密码";
            self.passWordFie = fie;
            fie.secureTextEntry = YES;
            image.image = [UIImage imageNamed:@"ic_11"];
            break;
        default:{
            fie.placeholder = @"请输入验证码";
            image.image = [UIImage imageNamed:@"ic_15"];
            fie.keyboardType = UIKeyboardTypeNumberPad;
            self.codeField = fie;
            ZBButten *btn = [ZBButten buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = BordColor;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [btn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
            [btn addTarget:self action:@selector(getCode:)
                                  forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(heightMar);
                make.right.equalTo(view).offset(0);
                make.size.mas_equalTo(CGSizeMake(100, 24));
            }];
            self.codeBtn = btn;
        }
            break;
    }
    UIView *line2 = [self creatLineChange:view];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fie.mas_bottom).with.offset(heightMar);
        make.left.equalTo(view).offset(fieH);
        make.right.equalTo(view).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    return fie;
}

- (UIView *)creatLineChange:(UIView *)view{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = BordColor;
    [view addSubview:line];
    return line;
}

- (void)getCode:(UIButton *)btn {
    [self resignViewResponder];
    [self requestCheckWord];
}

- (void)requestCheckWord{
    if (self.nameFie.text.length==0||self.passWordFie.text==0){
        [self.codeBtn resetBtn];
        [NewUIAlertTool show:@"请输入用户名和密码" okBack:nil andView:self yes:NO];
        return;
    }
    NSString *codeUrl = [NSString stringWithFormat:@"%@GetLoginVerifyCodeDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.nameFie.text;
    params[@"password"] = self.passWordFie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
        }else{
            [self.codeBtn resetBtn];
            SHOWALERTVIEW(response.message);
        }
    } requestURL:codeUrl params:params];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignViewResponder];
}

- (void)resignViewResponder{
    [self.nameFie resignFirstResponder];
    [self.codeField resignFirstResponder];
    [self.passWordFie resignFirstResponder];
}

- (void)touClick:(UIButton *)sender{
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showError:@"网络断开、请联网"];
        return;
    }
    [self setAccountData];
    if (self.btnBack) {
        self.btnBack(1);
    }
}

- (void)canClick:(UIButton *)sender{
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showError:@"网络断开、请联网"];
        return;
    }
    [self setAccountData];
    if (self.btnBack) {
        self.btnBack(5);
    }
}

- (void)setAccountData{
    [self resignViewResponder];
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userName"] = [AccountTool account].userName;
    params[@"password"] = [AccountTool account].password;
    params[@"phone"] = [AccountTool account].phone;
    Account *account = [Account accountWithDict:params];
    //自定义类型存储用NSKeyedArchiver
    [AccountTool saveAccount:account];
}

- (void)loginClick:(UIButton *)sender {
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showError:@"网络断开、请联网"];
        return;
    }
    [SVProgressHUD show];
    [self resignViewResponder];
    sender.enabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.nameFie.text;
    params[@"password"] = self.passWordFie.text;
    params[@"phoneCode"] = self.codeField.text;
    NSString *logUrl = [NSString stringWithFormat:@"%@userLoginDo",baseUrl];
    [BaseApi getNoLogGeneralData:^(BaseResponse *response, NSError *error) {
        if (response !=nil&&[response.error intValue]==0) {
            params[@"tokenKey"] = response.data[@"tokenKey"];
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            self.codeField.text = @"";
            if (self.btnBack) {
                self.btnBack(1);
            }
        }else{
            NSString *str = response.message?response.message:@"登录失败";
            SHOWALERTVIEW(str);
        }
        sender.enabled = YES;
    } requestURL:logUrl params:params];
}

- (void)bottomClick:(UIButton *)btn{
    [self resignViewResponder];
    if (self.btnBack) {
        self.btnBack((int)btn.tag);
    }
}

@end
