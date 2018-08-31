//
//  HHMyWalletVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHmyEarningsVC.h"
#import "HHMywalletCell.h"
#import "HHmyEarningsHead.h"

@interface HHmyEarningsVC ()

@property (nonatomic, strong) UITableView *tabView;

@end

@implementation HHmyEarningsVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAV_HEIGHT) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    
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
    
    self.title = @"我的收益";
    
    [self.tabView registerClass:[HHMywalletCell class] forCellReuseIdentifier:@"HHMywalletCell"];
    HHmyEarningsHead *wallet_head = [[HHmyEarningsHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 180)];
    self.tabView.tableHeaderView = wallet_head;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMywalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMywalletCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
@end
