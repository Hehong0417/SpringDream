//
//  HHMyWalletVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyIntegralVC.h"
#import "HHMywalletCell.h"
#import "HHMyIntegralHead.h"
#import "HHIntegralRankVC.h"

@interface HHMyIntegralVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   HHMyIntegralHead *wallet_head;
@property (nonatomic, assign)   NSInteger isFooterRefresh;
@property (nonatomic, assign)   NSInteger isLoaded;

@end

@implementation HHMyIntegralVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:kWhiteColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAV_HEIGHT) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tabView];
    self.tabView.tableFooterView = [UIView new];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    XYQButton *rank_button = [XYQButton ButtonWithFrame:CGRectMake(0, 0, 60, 40) imgaeName:@"rank" titleName:@"排行榜" contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:kWhiteColor fontsize:WidthScaleSize_W(10)] tapAction:^(XYQButton *button) {
        
        [self rank_buttonAction];
    }];
    UIButton *CustomView = rank_button;
    [CustomView setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:CustomView];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.datas removeAllObjects];
    [self GetIntegralList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的积分";
    
    [self.tabView registerNib:[UINib nibWithNibName:@"HHMywalletCell" bundle:nil] forCellReuseIdentifier:@"HHMywalletCell"];
    self.wallet_head = [[HHMyIntegralHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(110))];
    self.wallet_head.nav = self.navigationController;
    self.wallet_head.backgroundColor = kWhiteColor;
    self.tabView.tableHeaderView = self.wallet_head;
    self.tabView.emptyDataSetSource = self;
    self.tabView.emptyDataSetDelegate = self;
    
    self.page = 1;
    
    [self addHeadRefresh];
    
}

- (void)GetIntegralList{
    
    [[[HHMineAPI GetIntegralListWithPage:@1 pageSize:@20] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.isLoaded = YES;
        if (!error) {
            if (api.State == 1) {
                
                NSNumber *points = api.Data[@"total"];
                self.wallet_head.vip_integral_label.text = [NSString stringWithFormat:@"%.2f分",points.floatValue];
                if (self.isFooterRefresh == YES) {
                    [self loadDataFinish:api.Data[@"list"]];
                }else{
                    [self addFootRefresh];
                    [self.datas removeAllObjects];
                    [self loadDataFinish:api.Data[@"list"]];
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
    return [UIImage imageNamed:self.isLoaded?@"no_integral":@""];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:self.isLoaded?@"你的积分还没有产生明细哦～":@"" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
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
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = NO;
        [self GetIntegralList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tabView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        [self GetIntegralList];
    }];
    self.tabView.mj_footer = refreshfooter;
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count == 0) {
        self.tabView.mj_footer.hidden = YES;
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
        
        [self.tabView.mj_footer setState:MJRefreshStateNoMoreData];
    }else{
        
        [self.tabView.mj_footer setState:MJRefreshStateIdle];
    }
    if (self.tabView.mj_header.isRefreshing) {
        [self.tabView.mj_header endRefreshing];
    }
    
    if (self.tabView.mj_footer.isRefreshing) {
        [self.tabView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.tabView reloadData];
    
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
    cell.integral_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 69, ScreenW, 1) backColor:KVCBackGroundColor];
    [cell.contentView addSubview:h_line];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[section]];
    UIView *Footer = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    UILabel *remark = [UILabel lh_labelWithFrame:CGRectMake(20, 0, ScreenW-40, 50) text:[NSString stringWithFormat:@"备注：%@",model.desc] textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [Footer addSubview:remark];
    return   Footer;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
- (void)rank_buttonAction{
    
    HHIntegralRankVC *vc = [HHIntegralRankVC new];
    [self.navigationController pushVC:vc];
    
}
@end
