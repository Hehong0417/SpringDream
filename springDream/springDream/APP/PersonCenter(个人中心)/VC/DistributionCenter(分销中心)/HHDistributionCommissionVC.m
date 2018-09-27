//
//  HHMyWalletVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDistributionCommissionVC.h"
#import "HHMywalletCell.h"
#import "HHDistributionCommissionHead.h"
#import "HHCommissionDetailVC.h"

@interface HHDistributionCommissionVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   HHDistributionCommissionHead *distributionCommissionHead;
@property (nonatomic, strong)   UIButton *all_button;

@end

@implementation HHDistributionCommissionVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:kWhiteColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAV_HEIGHT-40) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tabView];
    self.tabView.tableFooterView = [UIView new];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.title_str;
    
    [self.tabView registerNib:[UINib nibWithNibName:@"HHMywalletCell" bundle:nil] forCellReuseIdentifier:@"HHMywalletCell"];
    self.distributionCommissionHead = [[[NSBundle mainBundle] loadNibNamed:@"HHDistributionCommissionHead" owner:self options:nil] firstObject];
    self.distributionCommissionHead.backgroundColor = kWhiteColor;
    self.tabView.tableHeaderView = self.distributionCommissionHead;
    self.tabView.emptyDataSetSource = self;
    self.tabView.emptyDataSetDelegate = self;
    
    self.page = 1;

    
    if ([self.title_str isEqualToString:@"分销佣金"]) {
        self.distributionCommissionHead.commission_title_label.text = @"当前分销总金额";
        [self getDistributionCommissionData];
        
    }else if ([self.title_str isEqualToString:@"代理佣金"]){
        self.distributionCommissionHead.commission_title_label.text = @"当前代理总金额";
        [self getDelegateCommissionData];
    }
    
    self.all_button = [UIButton lh_buttonWithFrame:CGRectMake(0, ScreenH-40-STATUS_NAV_HEIGHT, ScreenW, 40) target:self action:@selector(all_buttonAction:) image:nil title:@"查看全部" titleColor:kDarkGrayColor font:FONT(13)];
    [self.all_button setBackgroundColor:kWhiteColor];
    [self.view addSubview:self.all_button];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - 分销佣金

- (void)getDistributionCommissionData{
    
    [self GetUserTotalCommission];
    [self GetFansSale];
    
}
- (void)GetUserTotalCommission{
    
    [[[HHMineAPI GetUserTotalCommission] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.Data];
                
                self.distributionCommissionHead.commission_price_label.text = model.TotalComm;
                self.distributionCommissionHead.yestoday_commission_label.text = [NSString stringWithFormat:@"昨日佣金  +%@",model.YestodayComm?model.YestodayComm:@"0"];
                self.distributionCommissionHead.history_commission_label.text = [NSString stringWithFormat:@"历史总佣金  %@",model.HistoryCommission?model.HistoryCommission:@"0"];
    
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
- (void)GetFansSale{
    
    [[[HHMineAPI GetFansSaleWithpage:@(self.page) pageSize:@10] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data[@"List"];
                self.datas = arr.mutableCopy;
                if (self.datas.count<10) {
                    self.all_button.hidden = YES;
                }
                [self.tabView reloadData];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}
#pragma mark - 代理佣金

- (void)getDelegateCommissionData{
    
    [[[HHMineAPI GetBonusWithpage:@(self.page)  pageSize:@10] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.Data];
                self.distributionCommissionHead.commission_price_label.text = model.remain_bonus;
                self.distributionCommissionHead.yestoday_commission_label.text = [NSString stringWithFormat:@"昨日佣金  %@",model.yesterday_bonus?model.yesterday_bonus:@"0"];
                self.distributionCommissionHead.history_commission_label.text = [NSString stringWithFormat:@"历史总佣金  %@",model.history_total_bonus?model.history_total_bonus:@"0"];;
                NSArray *arr = api.Data[@"list"];
                self.datas = arr.mutableCopy;
                [self.tabView reloadData];
                if (self.datas.count<10) {
                    self.all_button.hidden = YES;
                }
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
    return [UIImage imageNamed:@"record_icon_no"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"你还没有相关的记录喔" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
    
    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
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
    
    HHMywalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMywalletCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.title_str isEqualToString:@"分销佣金"]) {
        cell.commission_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    }else if ([self.title_str isEqualToString:@"代理佣金"]) {
        cell.delegate_commission_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
- (void)all_buttonAction:(UIButton *)button{
    
    HHCommissionDetailVC *vc = [HHCommissionDetailVC new];
    if ([self.title_str isEqualToString:@"分销佣金"]) {
        vc.isDelegate_commission = NO;
    }else if ([self.title_str isEqualToString:@"代理佣金"]){
        vc.isDelegate_commission = YES;
    }
    [self.navigationController pushVC:vc];
    
}
@end
