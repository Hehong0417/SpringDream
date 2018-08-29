//
//  HHNewApplyRefundVC.m
//  springDream
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHNewApplyRefundVC.h"
#import "HHNewApplyFundHeadView.h"
#import "HHNewApplyFundCell.h"

@interface HHNewApplyRefundVC ()

@property (strong, nonatomic)  NSArray *order_detail_arr;
@property (strong, nonatomic)  NSArray *section_title_arr;
@property (nonatomic, strong) UITableView *tabView;

@end

@implementation HHNewApplyRefundVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20-50) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    
    [self.view addSubview:self.tabView];
    self.tabView.tableFooterView = [UIView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.title_str;
    
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedRowHeight = 0;
    
    self.section_title_arr =  @[@"商品详情",@"订单详情",@""];
    
    self.order_detail_arr = @[[NSString stringWithFormat:@"订单号：%@",self.order_id],[NSString stringWithFormat:@"下单时间：00:00:00"],[NSString stringWithFormat:@"支付方式；在线支付"]];
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, 45) target:self action:@selector(commitAction:) backgroundImage:nil title:@"提  交"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tabView.tableFooterView = footView;
    
    
    HHNewApplyFundHeadView *headView  = [[HHNewApplyFundHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 110)];
    headView.backgroundColor = kWhiteColor;
    headView.currentSelectBtn_index = 0;
    self.tabView.tableHeaderView = headView;

    [self.tabView registerNib:[UINib nibWithNibName:@"HHNewApplyFundCell" bundle:nil] forCellReuseIdentifier:@"HHNewApplyFundCell"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell  *grideCell=nil;
    if (indexPath.section == 0) {
        HHNewApplyFundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHNewApplyFundCell"];
        cell.item_model = self.item_model;
        grideCell = cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.order_detail_arr[indexPath.row];
        cell.textLabel.font = FONT(13);
        cell.textLabel.textColor = KTitleLabelColor;
        grideCell = cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"退款申请处理中";
        cell.textLabel.font = FONT(14);
        grideCell = cell;
    }
    grideCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return grideCell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
        
    }else if (indexPath.section == 1){
        return 44;
    }else{
        return 50;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
        
    }else if (section == 1){
        return 3;
    }else{
        return 1;
    }
      return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        return [UIView new];
    }
    UIView *head = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    UILabel *section_label = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 50) text:self.section_title_arr[section] textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [head addSubview:section_label];
      return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 0.01;
    }
    return 50;
}
- (void)commitAction:(UIButton *)btn{
    
    [[[HHMineAPI postConfirmOrderWithorderid:self.order_id orderItemId:self.item_model.product_item_id quantity:@"1" comments:@""] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (api.State == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(backActionWithBtn:)]) {
                [self.navigationController popVC];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
@end
