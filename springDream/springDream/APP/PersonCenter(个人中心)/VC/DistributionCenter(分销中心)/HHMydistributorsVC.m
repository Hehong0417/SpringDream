//
//  HHMydistributorsVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMydistributorsVC.h"
#import "HHMyMembersCell.h"

@interface HHMydistributorsVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation HHMydistributorsVC

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.title_str;
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMyMembersCell" bundle:nil] forCellReuseIdentifier:@"HHMyMembersCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.page = 1;
    if ([self.title_str isEqualToString:@"我的分销商"]) {
        [self getDistributionBusiness];
    }else if ([self.title_str isEqualToString:@"我的代理"]) {
        [self getDelegateBusiness];
    }else if ([self.title_str isEqualToString:@"下级会员"]) {
        [self getUserFewFans];
    }else if ([self.title_str isEqualToString:@"我的会员"]) {
        [self GetSubUsers];
    }
    [self addHeadRefresh];
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.datas removeAllObjects];
        self.page = 1;
        if ([self.title_str isEqualToString:@"我的分销商"]) {
            [self getDistributionBusiness];
        }else if ([self.title_str isEqualToString:@"我的代理"]) {
            [self getDelegateBusiness];
        }else if ([self.title_str isEqualToString:@"下级会员"]) {
            [self getUserFewFans];
        }else if ([self.title_str isEqualToString:@"我的会员"]) {
            [self GetSubUsers];
        }
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        if ([self.title_str isEqualToString:@"我的分销商"]) {
            [self getDistributionBusiness];
        }else if ([self.title_str isEqualToString:@"我的代理"]) {
            [self getDelegateBusiness];
        }else if ([self.title_str isEqualToString:@"下级会员"]) {
            [self getUserFewFans];
        }else if ([self.title_str isEqualToString:@"我的会员"]) {
            [self GetSubUsers];
        }
    }];
    self.tableView.mj_footer = refreshfooter;
    
}
//分销商
- (void)getDistributionBusiness{
    
    [[[HHMineAPI GetDistributionBusinessWithpage:@(self.page) pageSize:@20] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self addFootRefresh];
                [self loadDataFinish:api.Data];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
//代理商
- (void)getDelegateBusiness{
    
    [[ [HHMineAPI GetSubAgentsWithPage:@(self.page) pageSize:@20] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self addFootRefresh];
                [self loadDataFinish:api.Data];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}
//下级会员
- (void)getUserFewFans{
    
    [[[HHMineAPI GetUserFewFansWithFew:self.few page:@(self.page) pageSize:@20] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self addFootRefresh];
                [self loadDataFinish:api.Data];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
   
}
//我的会员
- (void)GetSubUsers{
    
    [[ [HHMineAPI GetSubUsersWithPage:@(self.page)  pageSize:@20]netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                [self addFootRefresh];
                [self loadDataFinish:api.Data];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    }
    if (arr.count < 20) {
        
        [self endRefreshing:YES];
        
    }else{
        [self endRefreshing:NO];
    }
    
}

/**
 *  结束刷新
 */
- (void)endRefreshing:(BOOL)noMoreData {
    // 取消刷新
    
    if (noMoreData) {
        
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else{
        
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.tableView reloadData];
    

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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMyMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMyMembersCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title_str = self.title_str;
    if ([self.title_str isEqualToString:@"我的分销商"]) {
        cell.business_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    }else if ([self.title_str isEqualToString:@"我的代理"]) {
        cell.delegate_business_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    }else if ([self.title_str isEqualToString:@"下级会员"]) {
        cell.business_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    }else if([self.title_str isEqualToString:@"我的会员"]){
        cell.delegate_business_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
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
    
    return 0.01;
}
@end
