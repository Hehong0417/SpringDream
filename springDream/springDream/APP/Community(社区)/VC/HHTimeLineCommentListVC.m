//
//  HHMyWalletVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHTimeLineCommentListVC.h"
#import "HHTimeLineCommentCell.h"
#import "SDTimeLineModel.h"
#import "SDTimeLineAPI.h"

@interface HHTimeLineCommentListVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property(nonatomic,assign)   BOOL  isFooterRefresh;

@end

@implementation HHTimeLineCommentListVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAV_HEIGHT) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tabView];
    self.tabView.tableFooterView = [UIView new];
    
    self.tabView.emptyDataSetDelegate = self;
    self.tabView.emptyDataSetSource = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    self.title = @"评论列表";
    [self.tabView registerClass:[HHTimeLineCommentCell class] forCellReuseIdentifier:@"HHTimeLineCommentCell"];
    
    [self addHeadRefresh];
    [self addFootRefresh];

    
    [self getDatas];
}
- (void)getDatas{
    
    [[[SDTimeLineAPI GetCommentsWithPage:@(self.page) pageSize:@20 subjectId:self.subjectId] netWorkClient] getRequestInView:self.view finishedBlock:^(SDTimeLineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data[@"List"];
                NSArray *commentItem_arr = [SDTimeLineCellCommentItemModel mj_objectArrayWithKeyValuesArray:arr];
                [self addFootRefresh];
                [self loadDataFinish:commentItem_arr];
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
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.datas removeAllObjects];
        self.isFooterRefresh = NO;
        self.page = 1;
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tabView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        [self getDatas];
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
    
    HHTimeLineCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHTimeLineCommentCell"];
    cell.model = self.datas[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SDTimeLineCellCommentItemModel *model = self.datas[indexPath.row];
    return [self.tabView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHTimeLineCommentCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
@end
