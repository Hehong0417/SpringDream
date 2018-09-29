//
//  HHMyWalletVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHStoreEarningsVC.h"
#import "HHMywalletCell.h"
#import "HHMyIntegralHead.h"
#import "HHIntegralRankVC.h"
#import "HHDistributionCommissionHead.h"

static CGFloat _bottomToolBarH = 120;

@interface HHStoreEarningsVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UITextFieldDelegate>
{
    CGFloat _totalKeybordHeight;
}
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   HHDistributionCommissionHead *distributionCommissionHead;
@property (nonatomic, strong) UIView *bottomToolBar;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HHStoreEarningsVC

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
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"门店收益";
    
    self.distributionCommissionHead = [[[NSBundle mainBundle] loadNibNamed:@"HHDistributionCommissionHead" owner:self options:nil] firstObject];
    self.distributionCommissionHead.commissionDetail_label.text = @"收益明细";
    self.distributionCommissionHead.commission_title_label.text = @"当前收益";
    self.distributionCommissionHead.vc = self;
    self.distributionCommissionHead.backgroundColor = kWhiteColor;
    [self.distributionCommissionHead.commission_balance_button addTarget:self action:@selector(commission_balance_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.tabView.tableHeaderView = self.distributionCommissionHead;
    
    [self.tabView registerNib:[UINib nibWithNibName:@"HHMywalletCell" bundle:nil] forCellReuseIdentifier:@"HHMywalletCell"];

    self.tabView.emptyDataSetSource = self;
    self.tabView.emptyDataSetDelegate = self;
    self.page = 1;
    
    [self addHeadRefresh];
    [self addFootRefresh];
    
    [self GetUserStoreCommissionStatictis];
    [self GetUserStoreCommission];
}
- (void)GetUserStoreCommissionStatictis{
    
    [[[HHMineAPI GetUserStoreCommissionStatictis] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.Data];
                self.distributionCommissionHead.commission_price_label.text = model.total_comm;
                self.distributionCommissionHead.yestoday_commission_label.text = [NSString stringWithFormat:@"昨日佣金  +%@",model.yestoday_comm?model.yestoday_comm:@"0"];
                self.distributionCommissionHead.history_commission_label.text = [NSString stringWithFormat:@"历史总佣金  %@",model.history_commission?model.history_commission:@"0"];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
//门店收益
- (void)GetUserStoreCommission{

    [[[HHMineAPI GetUserStoreCommissionWithPage:@(self.page) pageSize:@20] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self loadDataFinish:api.Data];
                
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
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.datas removeAllObjects];
        self.page = 1;
        [self GetUserStoreCommission];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        
        [self GetUserStoreCommission];
    }];
    self.tableView.mj_footer = refreshfooter;
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
    cell.store_commission_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 69, ScreenW, 1) backColor:KVCBackGroundColor];
    [cell.contentView addSubview:h_line];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[section]];
    
    UIView *Footer = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    
    
    UILabel *remark = [UILabel lh_labelWithFrame:CGRectMake(20, 0, ScreenW/2, 50) text:[NSString stringWithFormat:@"门店奖励：%@",model.store_reward] textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [Footer addSubview:remark];
    UILabel *remark2 = [UILabel lh_labelWithFrame:CGRectMake(ScreenW/2+50, 0, ScreenW/2-45, 50) text:[NSString stringWithFormat:@"门店返利：%@",model.store_rebate] textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [Footer addSubview:remark2];
    UIView *v_line = [UIView lh_viewWithFrame:CGRectMake(ScreenW/2, 0, 1, 50) backColor:KVCBackGroundColor];
    [Footer addSubview:v_line];

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
//佣金转余额
- (void)commission_balance_buttonAction{
    
    [_textField becomeFirstResponder];
}

- (void)setupTextField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _bottomToolBar = [UIView lh_viewWithFrame:CGRectMake(0, ScreenH, ScreenW, _bottomToolBarH) backColor:KVCBackGroundColor];
    
    UILabel *title_label = [UILabel lh_labelAdaptionWithFrame:CGRectMake(35, 20, ScreenW-70, 30) text:@"转账金额" textColor:kDarkGrayColor font:FONT(14) textAlignment:NSTextAlignmentLeft];
    [_bottomToolBar addSubview:title_label];
    
    UIButton *commit_btn = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW-60, 20, 50, 30) target:self action:@selector(commit_btnAction) image:nil title:@"确定" titleColor:kDarkGrayColor font:FONT(14)];
    [_bottomToolBar addSubview:commit_btn];
    
    
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.delegate = self;
    [_textField lh_setCornerRadius:5 borderWidth:1 borderColor:KDCLabelColor];
    _textField.placeholder = @"";
    _textField.font = FONT(14);
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    
    _textField.frame = CGRectMake(40,50, [UIScreen mainScreen].bounds.size.width-80, 40);
    _textField.backgroundColor = [UIColor whiteColor];
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _textField.leftView = left_view;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_bottomToolBar addSubview:_textField];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomToolBar];
    
}
- (void)commit_btnAction{
    
    [_textField resignFirstResponder];
    
    [self BonusToBalanceWithbonusType:@2];
}
- (void)BonusToBalanceWithbonusType:(NSNumber *)bonusType{
    if (_textField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请输入转账金额！"];
    }else{
        
        [[[HHMineAPI postBonusToBalanceWithmoney:_textField.text bonusType:bonusType] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showSuccessWithStatus:@"转账成功！"];
                    [self.datas removeAllObjects];
                    self.page = 1;
                    [self GetUserStoreCommission];

                }else{

                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }

        }];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)all_buttonAction:(UIButton *)button{
    
//    HHCommissionDetailVC *vc = [HHCommissionDetailVC new];
//    if ([self.title_str isEqualToString:@"分销佣金"]) {
//        vc.isDelegate_commission = NO;
//    }else if ([self.title_str isEqualToString:@"代理佣金"]){
//        vc.isDelegate_commission = YES;
//    }
//    [self.navigationController pushVC:vc];
    
}
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - _bottomToolBarH, rect.size.width, _bottomToolBarH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _bottomToolBar.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + _bottomToolBarH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
    }
}
@end
