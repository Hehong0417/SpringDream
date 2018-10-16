//
//  HHCouponUnusedVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponListVC.h"
#import "HHCouponCell.h"

@interface HHCouponListVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong)   UITableView *tableV;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;

@end

@implementation HHCouponListVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    
    self.tableV  =  [UITableView lh_tableViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-50) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    [self.view addSubview:self.tableV];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableV registerNib:[UINib nibWithNibName:@"HHCouponCell" bundle:nil] forCellReuseIdentifier:@"HHCouponCell"];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"领取优惠券";
    
    self.page = 1;
    
    self.tableV.emptyDataSetDelegate = self;
    self.tableV.emptyDataSetSource = self;
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedRowHeight = 0;
    self.tableV.backgroundColor = KVCBackGroundColor;

    [self GetProductCoupon];
}
- (void)GetProductCoupon{
    
    [[[HHCategoryAPI GetProductCouponWithpid:self.pid] netWorkClient] getRequestInView:self.view finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            
            if (api.State == 1) {
                NSArray *data_arr = api.Data;
                self.datas = [HHMineModel mj_objectArrayWithKeyValuesArray:data_arr];
                
                [self.tableV reloadData];
            }
        }
        
    }];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"chosecopon_icon_no"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"你没有相关的优惠券喔" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//    return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
//
//}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 20;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCouponCell" forIndexPath:indexPath];
    cell.get_model = self.datas[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     HHMineModel *activity_model = self.datas[indexPath.section];
    [[[HHCategoryAPI postReceiveCouponWithcoupId:activity_model.cid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                [SVProgressHUD showSuccessWithStatus:@"领取成功,可在“我的优惠券”进行查看！"];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"领取失败！"];
        }
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return AdapationLabelFont(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
}
@end
