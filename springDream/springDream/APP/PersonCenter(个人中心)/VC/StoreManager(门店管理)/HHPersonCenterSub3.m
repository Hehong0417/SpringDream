//
//  HHPersonCenter.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterSub3.h"
#import "HHStoreStatusCell.h"
#import "HHPersonCenterHead.h"
#import "HHOrderVC.h"
#import "HHvipInfoVC.h"
#import "HHMyServiceVC.h"
#import "HHDistributeServiceCell_one.h"
#import "HHMyStoreVC.h"
#import "HHStoreProductsVC.h"
#import "HHStoreOrderVC.h"
#import "HHStoreEarningsVC.h"

@interface HHPersonCenterSub3 ()<HHStoreStatusCellDelagete,HHDistributeServiceCell_one_delagete>

@property(nonatomic,strong) HHPersonCenterHead *personHead;
@property(nonatomic,strong) UITableView *tabView;
@property(nonatomic,strong) HHMineModel  *mineModel;
@property(nonatomic,strong) NSString  *userLevelName;
@property(nonatomic,strong) NSArray  *message_arr;
@property(nonatomic,strong) HHMineModel  *orderStatusCount_model;
@property(nonatomic,strong) HHMineModel  *store_model;

@end

@implementation HHPersonCenterSub3

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
    [self.tabView registerClass:[HHStoreStatusCell class] forCellReuseIdentifier:@"HHStoreStatusCell"];
    
    
}
#pragma mark - 获取数据
- (void)getDatas{
    
    //未完成订单数
    [self GetOrderStatusCount];
    
    [self getStoreDatas];
}
- (void)GetOrderStatusCount{
    
    [[[HHMineAPI GetOrderStatusCount] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (self.tabView.mj_header.isRefreshing) {
            [self.tabView.mj_header endRefreshing];
        }
        if (!error) {
            if (api.State == 1) {
                self.orderStatusCount_model = [HHMineModel mj_objectWithKeyValues:api.Data];
                [self.tabView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
    
}

- (void)getStoreDatas{
    
    [[[HHMineAPI GetUserStore] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
                if (arr.count>0) {
                    self.store_model = [HHMineModel mj_objectWithKeyValues:arr[0]];
                }
            }
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
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
            cell.textLabel.text = @"门店中心";
            cell.textLabel.font = FONT(13);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else{
            HHStoreStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHStoreStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.btn_image_arr = @[@"store_01",@"store_02",@"store_03",@"store_04"];
            cell.btn_title_arr = @[@"门店商品",@"门店订单",@"我的门店",@"门店收益"];
            cell.delegate = self;
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
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
    
        }
    }
}
#pragma mark - HHDistributeStatusCellDelagete

- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex StatusCell:(HHStoreStatusCell *)cell{
    
    NSLog(@"buttonIndex:%ld",buttonIndex);
    if (buttonIndex == 0) {
        HHStoreProductsVC *vc = [HHStoreProductsVC new];
        vc.store_model = self.store_model;
        [self.navigationController pushVC:vc];
    }else if (buttonIndex == 1) {
        HHStoreOrderVC *vc = [HHStoreOrderVC new];
        [self.navigationController pushVC:vc];
        
    }else if (buttonIndex == 2) {
        
        HHMyStoreVC *vc = [HHMyStoreVC new];
        [self.navigationController pushVC:vc];

    }else if (buttonIndex == 3) {
        
        HHStoreEarningsVC *vc = [HHStoreEarningsVC new];
        [self.navigationController pushVC:vc];
    }
    
}
#pragma mark - HHDistributeServiceCell_one_delagete

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell{
    
    
}


@end
