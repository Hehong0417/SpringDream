//
//  HHPersonCenter.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterSub4.h"
#import "HHDelegateStatusCell.h"
#import "HHPersonCenterHead.h"
#import "HHOrderVC.h"
#import "HHvipInfoVC.h"
#import "HHMyServiceVC.h"
#import "HHMydistributorsVC.h"
#import "HHDelegateOrderVC.h"
#import "HHDistributionGoodsVC.h"
#import "HHDistributionCommissionVC.h"
#import "HHDistributeServiceCell_one.h"

@interface HHPersonCenterSub4 ()<HHDelegateStatusCellDelagete,HHDistributeServiceCell_one_delagete>
@property(nonatomic,strong) HHPersonCenterHead *personHead;
@property(nonatomic,strong) UITableView *tabView;
@property(nonatomic,strong) HHMineModel  *mineModel;
@property(nonatomic,strong) NSString  *userLevelName;
@property(nonatomic,strong) NSArray  *message_arr;
@property(nonatomic,strong) HHMineModel  *orderStatusCount_model;

@end

@implementation HHPersonCenterSub4

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
    [self.tabView registerClass:[HHDelegateStatusCell class] forCellReuseIdentifier:@"HHDelegateStatusCell"];
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
                [self.tabView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
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
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *grideCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell"];
            cell.textLabel.text = @"代理中心";
            cell.textLabel.font = FONT(13);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }
        if (indexPath.row == 1){
            HHDelegateStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDelegateStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.btn_image_arr = @[@"delegate_01",@"distribute_02",@"distribute_04",@"distribute_03"];
            cell.btn_title_arr = @[@"代理商品",@"分销商",@"会员",@"代理订单"];
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
            cell.delegate = self;
            cell.btn_image_arr = @[@"sub_service_01",@"sub_service_02",@"",@""];
            cell.btn_title_arr = @[@"代理佣金",@"我的代理",@"",@""];
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
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark - HHDistributeStatusCellDelagete

- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex StatusCell:(HHDelegateStatusCell *)cell{
    
    NSIndexPath *indexPath = [self.tabView indexPathForCell:cell];
    
    if (indexPath.row == 1) {
        if (buttonIndex == 0) {
            
            HHDistributionGoodsVC *vc = [HHDistributionGoodsVC new];
            vc.title_str = @"代理商品";
            [self.navigationController pushVC:vc];
        }
        if (buttonIndex == 1) {
            HHMydistributorsVC *vc = [HHMydistributorsVC new];
            vc.title_str = @"我的分销商";
            [self.navigationController pushVC:vc];
        }
        if (buttonIndex == 2) {
            HHMydistributorsVC *vc = [HHMydistributorsVC new];
            vc.title_str = @"我的会员";
            [self.navigationController pushVC:vc];
        }
        if (buttonIndex == 3) {
            HHDelegateOrderVC *vc = [HHDelegateOrderVC new];
            [self.navigationController pushVC:vc];
        }
    }
    
}
#pragma mark - HHDistributeServiceCell_one_delagete

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell{
    
    if (buttonIndex == 0) {
        
        HHDistributionCommissionVC *vc = [HHDistributionCommissionVC new];
        vc.title_str = @"代理佣金";
        [self.navigationController pushVC:vc];
    }
    if (buttonIndex == 1) {
        HHMydistributorsVC *vc = [HHMydistributorsVC new];
        vc.title_str = @"我的代理";
        [self.navigationController pushVC:vc];
    }
    
}
@end
