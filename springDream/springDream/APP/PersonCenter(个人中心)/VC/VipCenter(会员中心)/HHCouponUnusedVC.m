//
//  HHCouponUnusedVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponUnusedVC.h"
#import "HHCouponCell.h"

@interface HHCouponUnusedVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong)   UITableView *tableV;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, assign)   NSInteger isFooterRefresh;
@property (nonatomic, assign)   NSInteger isLoaded;

@end

@implementation HHCouponUnusedVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    
    self.tableV  =  [UITableView lh_tableViewWithFrame:CGRectMake(0, 50, ScreenW, ScreenH-50) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    [self.view addSubview:self.tableV];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableV registerNib:[UINib nibWithNibName:@"HHCouponCell" bundle:nil] forCellReuseIdentifier:@"HHCouponCell"];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.page = 1;
    [self getDatas];
    self.tableV.estimatedRowHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.emptyDataSetDelegate = self;
    self.tableV.emptyDataSetSource = self;
    self.tableV.backgroundColor = KVCBackGroundColor;

    [self addHeadRefresh];
}
#pragma mark - 加载数据
- (void)getDatas{
    
[[[HHMineAPI GetMyCouponListWithPage:@(self.page) status:@(0)] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
    self.isLoaded = YES;
    if (!error) {
        if (api.State == 1) {
            if (self.isFooterRefresh == YES) {
                [self loadDataFinish:api.Data];
            }else{
                self.page = 1;
                [self.datas removeAllObjects];
                [self loadDataFinish:api.Data];
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
    return [UIImage imageNamed: self.isLoaded?@"no_coupon":@""];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:self.isLoaded?@"你没有相关的优惠券喔":@"" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
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
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = NO;
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableV.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        [self getDatas];
    }];
    self.tableV.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count == 0) {
        self.tableV.mj_footer.hidden = YES;
    }
    
    if (arr.count < 10) {
        
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
        
        [self.tableV.mj_footer setState:MJRefreshStateNoMoreData];
    }else{
        
        [self.tableV.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.tableV.mj_header.isRefreshing) {
        [self.tableV.mj_header endRefreshing];
    }
    
    if (self.tableV.mj_footer.isRefreshing) {
        [self.tableV.mj_footer endRefreshing];
    }
    //刷新界面
    [self.tableV reloadData];
    
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
    cell.model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
