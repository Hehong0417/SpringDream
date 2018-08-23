//
//  HHGoodDetailVC.m
//  springDream
//
//  Created by User on 2018/8/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodDetailVC.h"
#import <WebKit/WebKit.h>
#import "HHNotWlanView.h"
#import "HHAddCartTool.h"
#import "HHShoppingVC.h"
#import "HHSubmitOrdersVC.h"
#import "HHNotWlanView.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListVC.h"
#import "HHAddAdressVC.h"
#import "CZCountDownView.h"
#import "HHDetailGoodReferralCell.h"
#import "HHActivityModel.h"
#import "MLMenuView.h"
#import "HHFeatureSelectionViewCell.h"

//#import "DCFeatureChoseTopCell.h"
// Vendors
#import "UIViewController+XWTransition.h"
#import "HHdiscountPackageViewTabCell.h"
//#import "HHdiscountPackageVC.h"

@interface HHGoodDetailVC ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,SDCycleScrollViewDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong)   SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)   HHAddCartTool *addCartTool;
@property (nonatomic, strong)   NSMutableArray *discribeArr;
@property (nonatomic, strong)   UILabel *tableFooter;
@property (nonatomic, strong)  NSMutableArray *datas;
@property (nonatomic, strong)  NSMutableArray *evaluations;
@property (nonatomic, strong)  HHgooodDetailModel *gooodDetailModel;
@property (nonatomic, assign)   BOOL status;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *headTitle;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSMutableArray *alert_Arr;
@property (nonatomic, strong) NSMutableArray *guess_you_like_arr;
@property (nonatomic, strong) NSNumber *Mode;
@property (nonatomic, strong) UIView *countTimeView;
@property (nonatomic, strong) UIView *tableHeader;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) CZCountDownView *countDown;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, assign) CGFloat collectionHeight;


@end

static NSString *HHDetailGoodReferralCellID = @"HHDetailGoodReferralCell";//商品信息
static NSString *HHFeatureSelectionViewCellID = @"HHFeatureSelectionViewCell";//商品属性
static NSString *HHdiscountPackageViewTabCellID = @"HHdiscountPackageViewTabCell";

//cell
static NSString *lastNum_;
static NSArray *lastSeleArray_;
static NSArray *lastSele_IdArray_;

@implementation HHGoodDetailVC

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-49-20) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    
    [self.view addSubview:self.tabView];
     self.tabView.tableFooterView = [UIView new];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化
    [self setUpInit];
    //注册cell
    [self regsterTableCell];
    
    //获取数据
    [self getDatas];
    
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - regsterTableCell

- (void)regsterTableCell{
    
    [self.tabView registerNib:[UINib nibWithNibName:HHDetailGoodReferralCellID bundle:nil] forCellReuseIdentifier:HHDetailGoodReferralCellID];
    [self.tabView registerClass:[HHFeatureSelectionViewCell class] forCellReuseIdentifier:HHFeatureSelectionViewCellID];
    [self.tabView registerClass:[HHdiscountPackageViewTabCell class] forCellReuseIdentifier:HHdiscountPackageViewTabCellID];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *gridcell = nil;

    if (indexPath.section == 0) {
        HHDetailGoodReferralCell *cell = [tableView dequeueReusableCellWithIdentifier:HHDetailGoodReferralCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.gooodDetailModel = self.gooodDetailModel;
        gridcell = cell;
    }
    if (indexPath.section == 1) {
        HHFeatureSelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HHFeatureSelectionViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gooodDetailModel = self.gooodDetailModel;
        cell.product_sku_value_arr = self.gooodDetailModel.SKUValues;
        cell.lastNum = lastNum_;
        cell.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
        cell.lastSele_IdArray = [NSMutableArray arrayWithArray:lastSele_IdArray_];
        cell.product_sku_arr = self.gooodDetailModel.SKUList;
        cell.product_id = self.gooodDetailModel.Id;
        [cell.collectionView reloadData];
        [cell.collectionView layoutIfNeeded];
        self.collectionHeight = cell.collectionView.contentSize.height;
        gridcell = cell;
        
    }
    if (indexPath.section == 2) {
        HHdiscountPackageViewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:HHdiscountPackageViewTabCellID];
        cell.packages_model = self.gooodDetailModel.Packages[indexPath.row];
        cell.indexPath = indexPath;
        cell.nav = self.navigationController;
        gridcell = cell;
    }
    if (indexPath.section == 3) {

    }
    if (indexPath.section == 4) {

    }
    
    return gridcell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 150;
//    }
    if (indexPath.section == 1) {
        
        return   self.collectionHeight;

    }
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark -加载数据

- (void)getDatas{
    
    UIView *hudView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    [self.tableView addSubview:hudView];
    
    HHNotWlanView *notAlanView = [[HHNotWlanView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [hudView addSubview:notAlanView];
    notAlanView.hidden = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    self.activityIndicator.frame= CGRectMake(0, 0, 30, 30);
    self.activityIndicator.center = self.tableView.center;
    self.activityIndicator.color = KACLabelColor;
    self.activityIndicator.hidesWhenStopped = YES;
    [hudView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    self.addCartTool.userInteractionEnabled = NO;
    
    //商品详情
    [[[HHHomeAPI GetProductDetailWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.gooodDetailModel = nil;
                self.gooodDetailModel = [HHgooodDetailModel mj_objectWithKeyValues:api.Data];
                
                self.cycleScrollView.imageURLStringsGroup = self.gooodDetailModel.ImageUrls;
                self.discribeArr =  self.gooodDetailModel.AttributeValueList.mutableCopy;
                
                [self.tabView reloadData];
                
                [self.activityIndicator stopAnimating];
                [hudView removeFromSuperview];
                self.addCartTool.userInteractionEnabled = YES;
                
                [self.activityIndicator removeFromSuperview];
                [self tableView:self.tabView viewForHeaderInSection:1];
                
//                [self setUpGoodsWKWebView];
                
                
                //拼团
                HHActivityModel *GroupBy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuy];
                //降价团
                HHActivityModel *CutGroupBuy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutGroupBuy];
                //送礼
                HHActivityModel *SendGift_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SendGift];
                //砍价
                HHActivityModel *CutPrice_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutPrice];
                
                if ([GroupBy_m.IsJoin isEqual:@1]) {
                    
                    [self.alert_Arr addObject:GroupBy_m];
                }
                if ([CutGroupBuy_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutGroupBuy_m];
                }
                if ([SendGift_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:SendGift_m];
                }
                if ([CutPrice_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutPrice_m];
                }
                
                if (self.alert_Arr.count >0) {
                    self.addCartTool.buyBtn.hidden = NO;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3;
                }else{
                    self.addCartTool.buyBtn.hidden = YES;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3*2;
                }
//                // 秒杀
//                HHActivityModel *SecKill_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SecKill];
//                if ([SecKill_m.IsSecKill isEqual:@1]) {
//                    self.cycleScrollView.frame = CGRectMake(0, 50, ScreenW, 350);
//                    self.tableHeader.frame = CGRectMake(0, 0, ScreenW, 350);
//                    if (SecKill_m.StartSecond.integerValue>0) {
//                        self.titleLabel.text = @"距离活动开始";
//                        self.countDown.timestamp = SecKill_m.StartSecond.integerValue;
//                    }else{
//                        self.titleLabel.text = @"距离活动结束";
//                        self.countDown.timestamp = SecKill_m.EndSecond.integerValue;
//                    }
//                }else{
//                    self.cycleScrollView.frame = CGRectMake(0, 0, ScreenW, ScreenW);
//                    self.tableHeader.frame = CGRectMake(0, 0, ScreenW, 300);
//                }
//                self.tabView.tableHeaderView = self.tableHeader;
                
            }else{
                [self.activityIndicator stopAnimating];
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [self.activityIndicator stopAnimating];
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]||[error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
                notAlanView.hidden = NO;
            }else{
                notAlanView.hidden = YES;
                [hudView removeFromSuperview];
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }
    }];
    
    
}
#pragma mark -网络监测

- (void)setMonitor{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if(status == 1 || status == 2)
        {
            self.status = NO;
            NSLog(@"有网");
        }else
        {
            NSLog(@"没有网");
            self.status = YES;
            [self.tabView reloadData];
            
        }
    }];
    
}
#pragma mark - initialize

- (void)setUpInit
{
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    
    //tableHeaderView
//    _tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    
//    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 50)];
//    bg_view.backgroundColor = [UIColor blackColor];
//    self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
//    self.title_label.textColor = kWhiteColor;
//    self.title_label.textAlignment = NSTextAlignmentRight;
//    self.title_label.text = @"距离活动结束";
//    self.countDown = [CZCountDownView new];
//    self.countDown.frame = CGRectMake(CGRectGetMaxX(_title_label.frame),0, 200, 50);
//    self.countDown.backgroundImageName = @"";
//    self.countDown.timerStopBlock = ^{
//        NSLog(@"时间停止");
//    };
//    [bg_view addSubview:_title_label];
//    [bg_view addSubview:self.countDown];
//    [self.countTimeView addSubview:bg_view];
//    [_tableHeader addSubview:self.countTimeView];
//    bg_view.centerX = self.countTimeView.centerX;
//    [_tableHeader addSubview:self.cycleScrollView];
    self.tabView.tableHeaderView = self.cycleScrollView;
}
#pragma mark - 懒加载

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
//头部
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageNamesGroup:@[@""]];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadImag_default"];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
//        [_cycleScrollView setPlaceholderImage:[UIImage imageWithColor:kWhiteColor]];
        
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}


@end
