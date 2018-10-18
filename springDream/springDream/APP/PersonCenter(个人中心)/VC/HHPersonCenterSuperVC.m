//
//  HHPersonCenterSuperVC.m
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterSuperVC.h"
#import "HHPersonCenterHead.h"
#import "HHvipInfoVC.h"
#import "HHPersonCenterSub1.h"
#import "HHPersonCenterSub2.h"
#import "HHPersonCenterSub3.h"
#import "HHPersonCenterSub4.h"

@interface HHPersonCenterSuperVC ()<UIScrollViewDelegate,SGSegmentedControlDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    UIView *tab_head;
}
@property(nonatomic,strong)   SGSegmentedControl *SG;
@property (nonatomic, strong)   UIScrollView *mainScrollView;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property(nonatomic,strong) HHMineModel  *mineModel;
@property(nonatomic,strong) HHPersonCenterHead *personHead;
@property(nonatomic,strong) UITableView *tabView;
@property(nonatomic,strong) NSString  *userLevelName;
@property(nonatomic,strong) NSArray  *message_arr;
@property(nonatomic,strong) HHMineModel  *orderStatusCount_model;
@property (nonatomic, assign) BOOL isCanBack;

@end

@implementation HHPersonCenterSuperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.title_arr addObject:@"会员中心"];
    
    self.personHead = [[HHPersonCenterHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 175) notice_title:@"重要通知重要通知重要通知重要通知重要通知重要通知！！！"];
    self.personHead.nav = self.navigationController;
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    [self setupSegmentedControl];

    [self getDatas];

    [self addHeadRefresh];
}
- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kClearColor];
    self.tabView = [UITableView lh_tableViewWithFrame:CGRectMake(0, -Status_HEIGHT, ScreenW, ScreenH-29) tableViewStyle:UITableViewStylePlain delegate:self dataSourec:self];
    self.tabView.backgroundColor = KVCBackGroundColor;
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tabView];
    
}
- (NSMutableArray *)title_arr {
    
    if (!_title_arr) {
        _title_arr = [NSMutableArray array];
    }
    return _title_arr;
}
#pragma mark - 刷新控件
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.title_arr removeAllObjects];
        [self.title_arr addObject:@"会员中心"];
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tabView.mj_header = refreshHeader;
}
#pragma mark - 获取数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if ([self.tabView.mj_header isRefreshing]) {
            [self.tabView.mj_header endRefreshing];
        }
        if (!error) {
            if (api.State == 1) {
                
                self.mineModel = [HHMineModel mj_objectWithKeyValues:api.Data[@"user"]];
                HJUser *user = [HJUser sharedUser];
                user.mineModel = self.mineModel;
                user.usableComm = [NSString stringWithFormat:@"%@",api.Data[@"usableComm"]];
                [user write];
                
                HHMineModel *data_model = [HHMineModel mj_objectWithKeyValues:api.Data];
                if ([data_model.isUserDistribution isEqual:@1]) {
                    [self.title_arr addObject:@"分销中心"];
                    if ([data_model.isUserAgent isEqual:@1]) {
                        [self.title_arr addObject:@"代理中心"];
                        if ([data_model.isHasStore isEqual:@1]) {
                            [self.title_arr insertObject:@"门店管理" atIndex:2];
                        }
                    }else{

                    }
                }
                // 1.添加所有子控制器
                [self setupChildViewController];
                [self setupSegmentedControl];
                
                self.personHead.name_label.text = self.mineModel.UserName;
                [self.personHead.icon_view sd_setImageWithURL:[NSURL URLWithString:self.mineModel.UserImage] placeholderImage:[UIImage imageNamed:@"user_Icon"]];
                
                self.userLevelName = api.Data[@"userLevelName"];
                self.personHead.vip_label.text = self.userLevelName;
                NSString *protocolStr = [NSString stringWithFormat:@"%.2f",self.mineModel.Points?self.mineModel.Points.doubleValue:0.00];
                NSString *content = [NSString stringWithFormat:@"积分:%.2f",self.mineModel.Points?self.mineModel.Points.doubleValue:0.00];
                self.personHead.consumption_amount_label.attributedText = [NSString lh_attriStrWithprotocolStr:protocolStr content:content protocolStrColor:APP_COMMON_COLOR contentColor:RGB(102, 102, 102) commonFont:FONT(14)];
                [self.tabView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
    }];
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"cell"];
    
    return cell;
}
- (void)setupSegmentedControl {
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.scrollEnabled = NO;
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-230);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.title_arr.count, 0);
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.scrollEnabled = NO;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
//    [self.view addSubview:_mainScrollView];
    self.tabView.tableFooterView = self.mainScrollView;
    
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 175, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 175, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    
    self.SG.titleColorStateNormal = kDarkGrayColor;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(14);
    self.SG.backgroundColorNormal = RGB(250, 217, 218);
    self.SG.backgroundColorSelected = RGB(252, 195, 198);
    self.SG.indicatorColor = kClearColor;
    self.SG.line_color = RGB(255, 196, 198);
    self.SG.delegate = self;
    [self.view addSubview:self.SG];
    
    if (self.title_arr.count>1) {
        tab_head = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 230) backColor:KVCBackGroundColor];
        self.SG.hidden = NO;
    }else{
        tab_head = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 175) backColor:KVCBackGroundColor];
        self.SG.hidden = YES;
    }
    tab_head.userInteractionEnabled = YES;
    [tab_head addSubview:self.personHead];
    
    [tab_head addSubview:self.SG];
    
    self.tabView.tableHeaderView = tab_head;
    
    
    WEAK_SELF();
    [self.personHead.icon_view setTapActionWithBlock:^{
        HHvipInfoVC *vc = [HHvipInfoVC new];
        vc.userId = weakSelf.mineModel.Id;
        vc.mineModel = weakSelf.mineModel;
        vc.userLevelName = weakSelf.userLevelName;
        [weakSelf.navigationController pushVC:vc];
    }];
    
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX,0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}
// 添加所有子控制器
- (void)setupChildViewController {
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromParentViewController];
        
    }];
    if (self.title_arr.count <=3) {
        HHPersonCenterSub1 *vc1 = [HHPersonCenterSub1 new];
        [self addChildViewController:vc1];
        
        HHPersonCenterSub2 *vc2 = [HHPersonCenterSub2 new];
        [self addChildViewController:vc2];
        
        HHPersonCenterSub4 *vc4 = [HHPersonCenterSub4 new];
        [self addChildViewController:vc4];
        
    }else {
    HHPersonCenterSub1 *vc1 = [HHPersonCenterSub1 new];
    [self addChildViewController:vc1];
    
    HHPersonCenterSub2 *vc2 = [HHPersonCenterSub2 new];
    [self addChildViewController:vc2];
    
    HHPersonCenterSub3 *vc3 = [HHPersonCenterSub3 new];
    [self addChildViewController:vc3];
    
    HHPersonCenterSub4 *vc4 = [HHPersonCenterSub4 new];
    [self addChildViewController:vc4];
}
    
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    //    if (vc.isViewLoaded) return;
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack{
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}
@end
