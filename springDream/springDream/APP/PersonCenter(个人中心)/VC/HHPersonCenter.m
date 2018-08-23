//
//  HHPersonCenter.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenter.h"
#import "HHOrderStatusCell.h"
#import "HHServiceCell_one.h"
#import "HHServiceCell_two.h"
#import "HHPersonCenterHead.h"
#import "HHOrderVC.h"

@interface HHPersonCenter ()
@property(nonatomic,strong) HHPersonCenterHead *personHead;
@property(nonatomic,strong) UITableView *tabView;
@property(nonatomic,strong) HHMineModel  *mineModel;

@end

@implementation HHPersonCenter

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.personHead = [[HHPersonCenterHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 175) notice_title:@"重要通知重要通知重要通知重要通知重要通知重要通知！！！"];
    self.tabView.tableHeaderView = self.personHead;
    [self registerTableViewCell];

}
- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kClearColor];
    self.tabView = [UITableView lh_tableViewWithFrame:CGRectMake(0, -20, ScreenW, ScreenH-29) tableViewStyle:UITableViewStylePlain delegate:self dataSourec:self];
    self.tabView.backgroundColor = KVCBackGroundColor;
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tabView];
}
- (void)registerTableViewCell{
    
    [self.tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"title_cell"];
    [self.tabView registerClass:[HHOrderStatusCell class] forCellReuseIdentifier:@"HHOrderStatusCell"];
    [self.tabView registerClass:[HHServiceCell_one class] forCellReuseIdentifier:@"HHServiceCell_one"];
    [self.tabView registerClass:[HHServiceCell_two class] forCellReuseIdentifier:@"HHServiceCell_two"];

    
}
#pragma mark - 获取数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {

        if (!error) {
            if (api.State == 1) {
                self.mineModel = [HHMineModel mj_objectWithKeyValues:api.Data[@"user"]];
                self.personHead.name_label.text = self.mineModel.UserName;
                [self.personHead.icon_view sd_setImageWithURL:[NSURL URLWithString:self.mineModel.UserImage]];
                self.personHead.consumption_amount_label.text = self.mineModel.BuyTotal?[NSString stringWithFormat:@"消费金额:¥%.2f",self.mineModel.BuyTotal.floatValue]:@"0.00";

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
            cell.textLabel.text = @"我的订单";
            cell.textLabel.font = FONT(13);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            grideCell = cell;
        }else{
            HHOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderStatusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nav = self.navigationController;
            grideCell = cell;
        }
        
    }else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title_cell" ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *ad_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 75)];
        ad_imgV.image = [UIImage imageNamed:@"dream"];
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
            vc.sg_selectIndex = 1;
            [self.navigationController pushVC:vc];
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //我的服务
       
        }
    }
    
}
@end
