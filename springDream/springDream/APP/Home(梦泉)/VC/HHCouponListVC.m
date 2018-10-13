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
@end

@implementation HHCouponListVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    
    self.tableV  =  [UITableView lh_tableViewWithFrame:CGRectMake(0, 20, ScreenW, ScreenH-50) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
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
    self.tableV.backgroundColor = KVCBackGroundColor;

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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCouponCell" forIndexPath:indexPath];
    cell.activity_model = self.datas[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *image_arr = @[@"unused1",@"unused2",@"unused3"];
    cell.bg_imagV.image = [UIImage imageNamed:image_arr[indexPath.row%3]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     MeetActivityModel *activity_model = self.datas[indexPath.row];
    [[[HHCategoryAPI postReceiveCouponWithcoupId:activity_model.CouponId] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                [SVProgressHUD showSuccessWithStatus:@"领取成功！"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"领取失败！"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"领取失败！"];
        }
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return WidthScaleSize_H(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
@end
