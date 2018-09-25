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
    
    UIButton *rank_button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 45, 40) target:self action:@selector(rank_buttonAction) image:nil title:@"积分排行榜" titleColor:kWhiteColor font:FONT(14)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rank_button];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的积分";
    
    [self.tabView registerNib:[UINib nibWithNibName:@"HHMywalletCell" bundle:nil] forCellReuseIdentifier:@"HHMywalletCell"];
    HHMyIntegralHead *wallet_head = [[HHMyIntegralHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(110))];
    wallet_head.backgroundColor = kWhiteColor;
    self.tabView.tableHeaderView = wallet_head;
    self.tabView.emptyDataSetSource = self;
    self.tabView.emptyDataSetDelegate = self;
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
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMywalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMywalletCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 69, ScreenW, 1) backColor:KVCBackGroundColor];
    [cell.contentView addSubview:h_line];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *Footer = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    UILabel *remark = [UILabel lh_labelWithFrame:CGRectMake(20, 0, ScreenW-40, 50) text:@"备注：易碎物品" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
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
