//
//  HelpMenuVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HelpMenuVC.h"

@interface HelpMenuVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *helpTable;
@property (nonatomic, copy) NSArray *helpArr;
@property (nonatomic, copy) NSArray *dictArr;
@end

@implementation HelpMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.helpArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"helpCell";
    UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    addCell.textLabel.text = self.helpArr[indexPath.row];
    return addCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dictArr[indexPath.row];
}

@end
