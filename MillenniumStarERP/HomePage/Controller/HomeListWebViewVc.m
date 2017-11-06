//
//  HomeListWebViewVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/5.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "HomeListWebViewVc.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface HomeListWebViewVc ()<UINavigationControllerDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HomeListWebViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动页";
    [SVProgressHUD show];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;

    NSURLRequest *urlRe = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:urlRe];
//    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    context[@"gotoProductClass"] = ^() {
//        NSArray *args = [JSContext currentArguments];
//        for (JSValue *jsVal in args){
//            NSString *str = [NSString stringWithFormat:@"%@",jsVal];
//            DetailWebViewVC *webVc = [DetailWebViewVC new];
//            webVc.webUrl = str;
//            [self.navigationController pushViewController:webVc animated:YES];
//            //通过categotyId打开列表页
//            NSLog(@"%@",str);
//        }
//    };
    self.navigationController.delegate = self;
    [self creatNaviBtn];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 54, 54);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)backClick{
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
