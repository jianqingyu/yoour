//
//  LauchimageCus/Users/yjq/Desktop/MillFactory/MillenniumStarERPtomVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "LauchimageCustomVC.h"
#import "MainTabViewController.h"
#import "LoginViewController.h"
@interface LauchimageCustomVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *home1;
@property (weak, nonatomic) IBOutlet UIImageView *home2;
@property (weak,  nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,  weak) NSTimer *timer;
@property (nonatomic,assign) int i;
@end

@implementation LauchimageCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.i = 5;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeClick:) userInfo:nil repeats:YES];
    [UIView animateWithDuration:5 animations:^{
        self.home1.alpha = 0;
        self.home2.alpha = 1;
    }];
}

- (void)timeClick:(id)user{
    if (self.i==1) {
        [self changeLoginView];
    }
    self.i--;
    [self.btn setTitle:[NSString stringWithFormat:@"跳过 %d",self.i] forState:UIControlStateNormal];
}

- (IBAction)openClick:(id)sender {
    [self changeLoginView];
}

- (void)changeLoginView{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = [[MainTabViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
    [_timer invalidate];
    _timer = nil;
}

@end
