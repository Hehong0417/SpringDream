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

static CGFloat _bottomToolBarH = 120;

@interface HHDistributionCommissionVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UITextFieldDelegate>
{
    CGFloat _totalKeybordHeight;
}
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   HHDistributionCommissionHead *distributionCommissionHead;
@property (nonatomic, strong)   UIButton *all_button;

@property (nonatomic, strong) UIView *bottomToolBar;

@property (nonatomic, strong) UITextField *textField;
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
    
    [self setupTextField];

    
    [self.tabView registerNib:[UINib nibWithNibName:@"HHMywalletCell" bundle:nil] forCellReuseIdentifier:@"HHMywalletCell"];
    self.distributionCommissionHead = [[[NSBundle mainBundle] loadNibNamed:@"HHDistributionCommissionHead" owner:self options:nil] firstObject];
    self.distributionCommissionHead.vc = self;
    self.distributionCommissionHead.backgroundColor = kWhiteColor;
    [self.distributionCommissionHead.commission_balance_button addTarget:self action:@selector(commission_balance_buttonAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    _textField.frame = CGRectMake(40,55, [UIScreen mainScreen].bounds.size.width-80, 40);
    _textField.backgroundColor = [UIColor whiteColor];
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _textField.leftView = left_view;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_bottomToolBar addSubview:_textField];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomToolBar];
    
}
- (void)commit_btnAction{
    
    [_textField resignFirstResponder];
    
    if ([self.title_str isEqualToString:@"分销佣金"]) {
        [self BonusToBalanceWithbonusType:@0];
    }else if ([self.title_str isEqualToString:@"代理佣金"]){
        [self BonusToBalanceWithbonusType:@1];
    }
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
                if ([self.title_str isEqualToString:@"分销佣金"]) {
                    [self getDistributionCommissionData];
                    
                }else if ([self.title_str isEqualToString:@"代理佣金"]){
                    [self getDelegateCommissionData];
                }
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
