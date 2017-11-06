//
//  CustomDrListiTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/30.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomDrListiTableCell.h"
#import "DetailStoneInfo.h"
@interface CustomDrListiTableCell()
@property (weak,  nonatomic) IBOutlet UIScrollView *dirScroll;
@property (nonatomic,strong)NSMutableArray *mutA;
@end
@implementation CustomDrListiTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"driListCell";
    CustomDrListiTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[CustomDrListiTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomDrListiTableCell" owner:nil options:nil][0];
        self.mutA = @[].mutableCopy;
    }
    return self;
}

- (void)setListArr:(NSArray *)listArr{
    if (listArr) {
        _listArr = listArr;
        [self creatBaseView:_listArr];
    }
}

- (void)creatBaseView:(NSArray *)arr{
    CGFloat space = 10;
    CGFloat height = 30;
    CGFloat width = 60;
    CGFloat vW = 0;
    for (int i=0; i<arr.count; i++) {
        DetailStoneInfo *info = arr[i];
        UIButton *btn = [self creatBtn];
        btn.frame = CGRectMake((space+width)*i, space, width, height);
        btn.tag = i;
        btn.enabled = !info.isSel;
        [btn setTitle:info.title forState:UIControlStateNormal];
        vW = CGRectGetMaxX(btn.frame)+15;
    }
    self.dirScroll.contentSize = CGSizeMake(vW, 0);
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:DefaultColor]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR]
                   forState:UIControlStateDisabled];
    [btn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    [btn addTarget:self action:@selector(btnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.dirScroll addSubview:btn];
    [self.mutA addObject:btn];
    return btn;
}

- (void)btnClick:(UIButton *)sender{
    for (int i=0; i<self.mutA.count; i++) {
        UIButton *sBtn = self.mutA[i];
        DetailStoneInfo *info = self.listArr[i];
        if (i!=(int)sender.tag) {
            sBtn.enabled = YES;
            info.isSel = NO;
        }
    }
    DetailStoneInfo *info = self.listArr[sender.tag];
    sender.enabled = !sender.enabled;
    info.isSel = !sender.enabled;
    if (self.stoneBack) {
        self.stoneBack(YES);
    }
}

@end
