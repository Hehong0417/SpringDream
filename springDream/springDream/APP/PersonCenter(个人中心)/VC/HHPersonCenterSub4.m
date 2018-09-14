//
//  HHPersonCenter.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterSub4.h"
#import "HHDistributeStatusCell.h"
#import "HHServiceCell_one.h"
#import "HHServiceCell_two.h"
#import "HHPersonCenterHead.h"
#import "HHOrderVC.h"
#import "HHvipInfoVC.h"


@interface HHPersonCenterSub4 ()
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
    [self.tabView registerClass:[HHDistributeStatusCell class] forCellReuseIdentifier:@"HHDistributeStatusCell"];
    [self.tabView registerClass:[HHServiceCell_one class] forCellReuseIdentifier:@"HHServiceCell_one"];
    [self.tabView registerClass:[HHServiceCell_two class] forCellReuseIdentifier:@"HHServiceCell_two"];
    
    
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
        if (indexPath.row == 0){
            HHDistributeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDistributeStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nav = self.navigationController;
            cell.message_arr = self.message_arr;
            cell.btn_image_arr = @[@"order_01",@"order_02",@"order_03",@"order_04"];
            cell.btn_title_arr = @[@"代理产品",@"分销商",@"会员",@"团队订单"];
            grideCell = cell;
        }else{
            HHDistributeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDistributeStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nav = self.navigationController;
            cell.message_arr = @[@"0",@"0",@"0",@"0"];
            cell.btn_image_arr = @[@"order_01",@"",@"",@""];
            cell.btn_title_arr = @[@"我的佣金",@"",@"",@""];
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else if (indexPath.row == 1) {
            HHServiceCell_one *cell = [tableView dequeueReusableCellWithIdentifier:@"HHServiceCell_one" ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nav = self.navigationController;
            grideCell = cell;
        }else if(indexPath.row == 2){
            HHServiceCell_two *cell = [tableView dequeueReusableCellWithIdentifier:@"HHServiceCell_two" ];
            cell.nav = self.navigationController;
            [cell setUserIcon:self.mineModel.UserImage setAccount:self.mineModel.CellPhone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

        return 70;
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
    if (indexPath.section == 0) {
  
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //我的服务
            
        }
    }
    
}
@end
