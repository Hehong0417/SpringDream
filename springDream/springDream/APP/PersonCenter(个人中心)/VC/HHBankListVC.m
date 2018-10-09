//
//  HHCouponUsedVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBankListVC.h"
#import "HHBankListCell.h"
#import "HHBandCardVC.h"

@interface HHBankListVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong)   UITableView *tableV;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@end

@implementation HHBankListVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    
    self.tableV  =  [UITableView lh_tableViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    
    [self.view addSubview:self.tableV];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getDatas];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableV registerNib:[UINib nibWithNibName:@"HHBankListCell" bundle:nil] forCellReuseIdentifier:@"HHBankListCell"];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.emptyDataSetDelegate = self;
    self.tableV.emptyDataSetSource = self;
    self.tableV.estimatedRowHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.backgroundColor = KVCBackGroundColor;
    
    self.title = @"我的银行卡";
    
    UIView *footerView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 100) backColor:KVCBackGroundColor];
    UIView *btn_view = [UIView lh_viewWithFrame:CGRectMake(15, 0, ScreenW-30, 44) backColor:APP_NAV_COLOR];
    [footerView addSubview:btn_view];
    UIImageView *imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(30, 0, 44, 44) image:[UIImage imageNamed:@"add_01"]];
    imagV.contentMode = UIViewContentModeCenter;
    [btn_view addSubview:imagV];
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(imagV.frame), 0, btn_view.mj_w - CGRectGetMaxX(imagV.frame) , 44) text:@"添加银行卡" textColor:kWhiteColor font:FONT(18) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [btn_view addSubview:lab];
    
    self.tableV.tableFooterView = footerView;
    
    footerView.userInteractionEnabled = YES;
    
    [footerView setTapActionWithBlock:^{
       
        HHBandCardVC *vc = [HHBandCardVC new];
        [self.navigationController pushVC:vc];
    }];
    
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserBankAccountList] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
                self.datas = arr.mutableCopy;
                
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"chosecopon_icon_no"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"你还没有银行卡喔" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}
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
    
    HHBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHBankListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return WidthScaleSize_H(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

@end
