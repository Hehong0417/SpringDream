//
//  HHBandCardVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBandCardVC.h"
#import "HHTextfieldcell.h"

@interface HHBandCardVC ()

@end

@implementation HHBandCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定银行卡";
    
    self.view.backgroundColor = KVCBackGroundColor;
    
    UIView *tableHeaderView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(50)) backColor:KVCBackGroundColor];
    UILabel *bankInfo_title_label = [UILabel lh_labelWithFrame:CGRectMake(20, 0, ScreenW-40, WidthScaleSize_H(50)) text:@"银行卡信息" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [tableHeaderView addSubview:bankInfo_title_label];
    self.tableView.tableHeaderView = tableHeaderView;

    
     UIButton  *commit_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20),WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(commit_buttonAction:) title:@"提交" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [commit_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    self.tableView.tableFooterView = commit_button;

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *title_arr = @[@"银行卡号",@"开户行",@"开户名"];
    NSArray *placeholder_arr = @[@"请输入银行卡号",@"请选择开户行",@"请输入开户名"];

    HHTextfieldcell  *cell = [[HHTextfieldcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    cell.titleLabel.text = title_arr[indexPath.row];
    cell.inputTextField.placeholder = placeholder_arr[indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return WidthScaleSize_H(50);
}
- (void)commit_buttonAction:(UIButton *)button{
    
    
    
}
@end
