//
//  HHPersonCenter.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterSub2.h"
#import "HHDistributeStatusCell.h"
#import "HHDistributeServiceCell_one.h"
#import "HHvipInfoVC.h"
#import "HHMyServiceVC.h"
#import "HHDistributionGoodsVC.h"
#import "HHDistributionOrderVC.h"
#import "HHMydistributorsVC.h"
#import "HHJuniorMembersVC.h"
#import "HHDistributionCommissionVC.h"

@interface HHPersonCenterSub2 ()<HHDistributeStatusCellDelagete,HHDistributeServiceCell_one_delagete,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UITableView *tabView;
@property(nonatomic,strong) HHMineModel  *mineModel;
@property(nonatomic,strong) NSString  *userLevelName;
@property(nonatomic,strong) NSArray  *message_arr;
@property(nonatomic,strong) HHMineModel  *orderStatusCount_model;
@property (nonatomic, assign) BOOL isCanBack;

@end

@implementation HHPersonCenterSub2

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
    
    [self.tabView registerClass:[HHDistributeStatusCell class] forCellReuseIdentifier:@"HHDistributeStatusCell"];
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
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *grideCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"title_cell"];
            }
            cell.textLabel.text = @"分销佣金:";
            cell.textLabel.font = FONT(13);
            cell.textLabel.textColor = kDarkGrayColor;
            cell.detailTextLabel.font = FONT(13);
            HJUser *user = [HJUser sharedUser];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",user.usableComm];
            cell.detailTextLabel.textColor = APP_COMMON_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else{
            HHDistributeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDistributeStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.btn_image_arr = @[@"distribute_01",@"distribute_02",@"distribute_03",@"distribute_04"];
            cell.btn_title_arr = @[@"分销商品",@"分销商",@"分销订单",@"下级会员"];
            cell.delegate = self;
            grideCell = cell;
        }
        
    }else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell" ];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title_cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *ad_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 75)];
        ad_imgV.contentMode = UIViewContentModeScaleToFill;
        ad_imgV.image = [UIImage imageNamed:@"mrs_bg"];
        [cell.contentView addSubview:ad_imgV];
        grideCell = cell;
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title_cell"];
            }
            cell.textLabel.text = @"我的服务";
            cell.textLabel.font = FONT(13);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else if (indexPath.row == 1) {
            HHDistributeServiceCell_one *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDistributeServiceCell_one" ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
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
            //分销佣金
            HHDistributionCommissionVC *vc = [HHDistributionCommissionVC new];
            vc.title_str = @"分销佣金";
            [self.navigationController pushVC:vc];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //我的服务
        }
    }
    
}
#pragma mark - HHDistributeStatusCellDelagete

- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex StatusCell:(HHDistributeStatusCell *)cell{
    
    NSLog(@"buttonIndex:%ld",buttonIndex);
    if (buttonIndex == 0) {
        //分销商品
        HHDistributionGoodsVC *vc = [HHDistributionGoodsVC new];
        vc.title_str = @"分销商品";
        [self.navigationController pushVC:vc];
        
    }else if (buttonIndex == 1){
        //分销商
        HHMydistributorsVC *vc = [HHMydistributorsVC new];
        vc.title_str = @"我的分销商";
        [self.navigationController pushVC:vc];
        
    }else if (buttonIndex == 2){
        //分销订单
        HHDistributionOrderVC *vc = [HHDistributionOrderVC new];
        [self.navigationController pushVC:vc];

    }else if (buttonIndex == 3){
        //下级会员
        HHJuniorMembersVC *vc = [HHJuniorMembersVC new];
        [self.navigationController pushVC:vc];
        
    }
    
}
#pragma mark - HHDistributeServiceCell_one_delagete

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell{
    

    
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
