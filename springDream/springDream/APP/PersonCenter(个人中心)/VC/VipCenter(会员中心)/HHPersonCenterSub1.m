//
//  HHPersonCenter.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterSub1.h"
#import "HHOrderStatusCell.h"
#import "HHPersonCenterHead.h"
#import "HHOrderVC.h"
#import "HHvipInfoVC.h"
#import "HHDistributeServiceCell_one.h"
#import "HHCouponSuperVC.h"
#import "HHMyCollectionVC.h"
#import "HHMyWalletVC.h"
#import "HHMyIntegralVC.h"
#import "HHShippingAddressVC.h"
#import "HHMyServiceVC.h"
#import "HHMyCodeVC.h"
#import "HHSendIntegralVC.h"
#import "HHMyActivityWebVC.h"
#import "HHMySaleGroupWebVC.h"

@interface HHPersonCenterSub1 ()<HHDistributeServiceCell_one_delagete,UIGestureRecognizerDelegate>
@property(nonatomic,strong) HHPersonCenterHead *personHead;
@property(nonatomic,strong) UITableView *tabView;
@property(nonatomic,strong) NSString  *userLevelName;
@property(nonatomic,strong) NSArray  *message_arr;
@property(nonatomic,strong) HHMineModel  *orderStatusCount_model;
@property (nonatomic, assign) BOOL isCanBack;

@end

@implementation HHPersonCenterSub1

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self registerTableViewCell];
    
    [self getDatas];

}
- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kClearColor];
    self.tabView = [UITableView lh_tableViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) tableViewStyle:UITableViewStylePlain delegate:self dataSourec:self];
    self.tabView.backgroundColor = KVCBackGroundColor;
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.scrollEnabled = NO;

    [self.view addSubview:self.tabView];
}
- (void)registerTableViewCell{
    
    [self.tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"title_cell"];
    [self.tabView registerClass:[HHOrderStatusCell class] forCellReuseIdentifier:@"HHOrderStatusCell"];
    [self.tabView registerClass:[HHDistributeServiceCell_one class] forCellReuseIdentifier:@"HHDistributeServiceCell_one"];

}
#pragma mark - 获取数据
- (void)getDatas{
    
    //未完成订单数
    [self GetOrderStatusCount];
    
}
- (void)GetOrderStatusCount{
    
    [[[HHMineAPI GetOrderStatusCount] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (self.tabView.mj_header.isRefreshing) {
            [self.tabView.mj_header endRefreshing];
        }
        if (!error) {
            if (api.State == 1) {
                self.orderStatusCount_model = [HHMineModel mj_objectWithKeyValues:api.Data];
                self.message_arr = @[self.orderStatusCount_model.wait_pay_count,self.orderStatusCount_model.wait_send_count,self.orderStatusCount_model.already_shipped_count,self.orderStatusCount_model.un_evaluate_count,self.orderStatusCount_model.afte_ervice_count];
                [self.tabView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *grideCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell"];
            cell.textLabel.text = @"全部订单";
            cell.textLabel.font = FONT(14);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else{
            HHOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nav = self.navigationController;
            cell.message_arr = self.message_arr;
            grideCell = cell;
        }
        
    }else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell" ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *ad_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 75)];
        ad_imgV.contentMode = UIViewContentModeScaleToFill;
        ad_imgV.image = [UIImage imageNamed:@"mrs_bg"];
        [cell.contentView addSubview:ad_imgV];
        grideCell = cell;
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell"];
            cell.textLabel.text = @"我的服务";
            cell.textLabel.font = FONT(13);
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else if (indexPath.row == 1) {
            HHDistributeServiceCell_one *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDistributeServiceCell_one" ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate= self;
            cell.btn_image_arr = @[@"service_01",@"service_02",@"service_03",@"service_04"];
            cell.btn_title_arr = @[@"我的钱包",@"我的优惠券",@"我的积分",@"我的收藏"];
            grideCell = cell;
        }else if(indexPath.row == 2){
            HHDistributeServiceCell_one *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDistributeServiceCell_one" ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate= self;
            cell.btn_image_arr = @[@"sub1_service11",@"sub1_service12",@"service_10",@""];
            cell.btn_title_arr = @[@"拼团活动",@"降价团活动",@"分享名片",@""];
            grideCell = cell;
        }
    }
    return grideCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50;
        }else{
            return 70;
        }
    }else if (indexPath.section == 1){
        return 75;
    }else{

        if (indexPath.row == 0) {
            return 50;
        }else{
            return 95;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //我的订单
            HHOrderVC *vc = [HHOrderVC new];
            vc.sg_selectIndex = 0;
            vc.button_tag = 0;
            [self.navigationController pushVC:vc];
        }
    }
    if (indexPath.section == 2){
        
    }
}
#pragma mark - HHDistributeServiceCell_one_delagete

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell{
    
    NSIndexPath *indexPath = [self.tabView indexPathForCell:cell];
    
    if (indexPath.row == 1) {
        if (buttonIndex == 0) {
            //我的钱包
            HHMyWalletVC *vc = [HHMyWalletVC new];
            [self.navigationController pushVC:vc];
            
        }else if (buttonIndex == 1){
            //优惠券
            HHCouponSuperVC *vc = [HHCouponSuperVC new];
            [self.navigationController pushVC:vc];
            
        }else if (buttonIndex == 2){
            //我的积分
            HHMyIntegralVC *vc = [HHMyIntegralVC new];
            
            [self.navigationController pushVC:vc];
            
        }else if (buttonIndex == 3){
            // 我的收藏
            HHMyCollectionVC *vc = [HHMyCollectionVC new];
            [self.navigationController pushVC:vc];
        }
    }
    if (indexPath.row == 2) {
        if(buttonIndex == 0){
            //拼团
            HHMyActivityWebVC *vc = [HHMyActivityWebVC new];
            [self.navigationController pushVC:vc];
        }
        
        if(buttonIndex == 1){
            //降价团
            HHMySaleGroupWebVC *vc = [HHMySaleGroupWebVC new];
            [self.navigationController pushVC:vc];
        }
           if (buttonIndex == 2){
            //分享邀请码
            HHMyCodeVC *vc = [HHMyCodeVC new];
            [self.navigationController pushVC:vc];
            
           }
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack{
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}
@end
