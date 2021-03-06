//
//  HHMyWalletVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyStoreVC.h"
#import "HHMystoreCell.h"

@interface HHMyStoreVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger isLoaded;
@end

@implementation HHMyStoreVC

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
    
    self.tabView.emptyDataSetDelegate = self;
    self.tabView.emptyDataSetSource = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的门店";
    [self.tabView registerNib:[UINib nibWithNibName:@"HHMystoreCell" bundle:nil] forCellReuseIdentifier:@"HHMystoreCell"];
    
    [self getDatas];
}
- (void)getDatas{
    
    [[[HHMineAPI GetUserStore] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.isLoaded = YES;
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
                self.datas = arr.mutableCopy;
                [self.tabView reloadData];
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
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:self.isLoaded?@"record_icon_no":@""];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:self.isLoaded?@"你还没有相关的记录喔":@"" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
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
    
    HHMystoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMystoreCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.store_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   HHMineModel *store_model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
 
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectRowWithstoreModel:)]) {
        [self.delegate didSelectRowWithstoreModel:store_model];
        [self.navigationController popVC];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
@end
