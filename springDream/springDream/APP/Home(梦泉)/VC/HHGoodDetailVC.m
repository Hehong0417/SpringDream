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
#import "HHGoodDetailFoot.h"
#import "HHSeckillCustomView.h"
#import "HHSpellGroupCell.h"
#import "HHpreferentialModelCell.h"
#import "HHpreferModel.h"
#import "HHpreferIntegralCell.h"


@interface HHGoodDetailVC ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,SDCycleScrollViewDelegate,HHFeatureSelectionViewCellDelegate>
{
    HXCommonPickView *_pickView;
}
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong)   SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)   HHAddCartTool *addCartTool;
@property (nonatomic, strong)   NSMutableArray *discribeArr;
@property (nonatomic, strong)   UILabel *tableFooter;
@property (nonatomic, strong)  NSMutableArray *datas;
@property (nonatomic, strong)  NSMutableArray *evaluations;
@property (nonatomic, strong)  NSMutableArray *JoinActivity_arr;
@property (nonatomic, strong)  HHgooodDetailModel *gooodDetailModel;
@property (nonatomic, assign)   BOOL status;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *headTitle;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSMutableArray *alert_Arr;
@property (nonatomic, strong) NSNumber *Mode;
@property (nonatomic, strong) UIView *countTimeView;
@property (nonatomic, strong) UIView *tableHeader;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) CZCountDownView *countDown;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, assign) CGFloat collectionHeight;
@property (nonatomic, strong) HHSeckillCustomView *seckill_view;
@property (nonatomic, strong) HHGoodDetailFoot *foot;

@property (nonatomic, strong) NSMutableArray *productStores_names;
@property (nonatomic, strong) NSMutableArray *productStores_ids;

@property (nonatomic, strong) HHpreferModel *preferModel;

//优惠数组
@property (nonatomic, strong) NSMutableArray *preferentialArr;

@property (nonatomic, strong) NSString *store_id;
@property (nonatomic, strong) UILabel *detailText_lab;

@property (nonatomic, assign) BOOL IsSecKill;


@end

static NSString *HHDetailGoodReferralCellID = @"HHDetailGoodReferralCell";//商品信息
static NSString *HHFeatureSelectionViewCellID = @"HHFeatureSelectionViewCell";//商品属性
static NSString *HHdiscountPackageViewTabCellID = @"HHdiscountPackageViewTabCell";//推荐商品
static NSString *HHEvaluationListCellID = @"HHEvaluationListCell";//评价
static NSString *HHSpellGroupCellID = @"HHSpellGroupCell";
static NSString *HHpreferentialModelCellID = @"HHpreferentialModelCell";


//cell
static NSString *lastNum_;
static NSArray *lastSeleArray_;
static NSArray *lastSele_IdArray_;

@implementation HHGoodDetailVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.addCartTool.hidden = NO;
}

- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAV_HEIGHT-50) tableViewStyle:UITableViewStylePlain delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    
    [self.view addSubview:self.tabView];
     self.tabView.tableFooterView = [UIView new];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.preferModel = [HHpreferModel new];
    self.preferModel.items = @[@"满1500减50",@"满100减5",@"满200减15"];
    self.preferModel.act_name = @"满减活动";
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    
    HHGoodDetailItem *detail_item = [HHGoodDetailItem sharedGoodDetailItem];
    detail_item.product_stock = @"1";
    [detail_item write];
    //初始化
    [self setUpInit];
    //注册cell
    [self regsterTableCell];
    
    //获取数据
    [self getDatas];
    
    [self addCartOrBuyAction];
   
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    WEAK_SELF();
    self.foot = [[HHGoodDetailFoot alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 500)];
    weakSelf.tabView.tableFooterView = weakSelf.foot;

    self.foot.reloadBlock = ^{
             weakSelf.foot.frame = CGRectMake(0, 0, ScreenW, [HHGoodDetailFoot cellHeight]);
             weakSelf.tabView.tableFooterView = weakSelf.foot;
    };
    
    _pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
}
- (void)backBtnAction{
    
    if (self.goodDetail_backBlock) {
        self.goodDetail_backBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (NSMutableArray *)productStores_names{
    
    if (!_productStores_names) {
        _productStores_names = [NSMutableArray array];
    }
    return _productStores_names;
}

- (NSMutableArray *)productStores_ids{
    
    if (!_productStores_ids) {
        _productStores_ids = [NSMutableArray array];
    }
    return _productStores_ids;
}
- (NSMutableArray *)preferentialArr{
    if (!_preferentialArr) {
        _preferentialArr = [NSMutableArray array];
    }
    return _preferentialArr;
}
- (NSMutableArray *)JoinActivity_arr{
    if (!_JoinActivity_arr) {
        _JoinActivity_arr = [NSMutableArray array];
    }
    return _JoinActivity_arr;
}

#pragma mark - regsterTableCell

- (void)regsterTableCell{
    
    [self.tabView registerNib:[UINib nibWithNibName:HHDetailGoodReferralCellID bundle:nil] forCellReuseIdentifier:HHDetailGoodReferralCellID];
    [self.tabView registerClass:[HHFeatureSelectionViewCell class] forCellReuseIdentifier:HHFeatureSelectionViewCellID];
    [self.tabView registerClass:[HHdiscountPackageViewTabCell class] forCellReuseIdentifier:HHdiscountPackageViewTabCellID];
    [self.tabView registerClass:[HHEvaluationListCell class] forCellReuseIdentifier:HHEvaluationListCellID];
    [self.tabView registerClass:[HHSpellGroupCell class] forCellReuseIdentifier:HHSpellGroupCellID];
    [self.tabView registerClass:[HHpreferentialModelCell class] forCellReuseIdentifier:HHpreferentialModelCellID];
    [self.tabView registerClass:[HHpreferIntegralCell class] forCellReuseIdentifier:@"HHpreferIntegralCell"];


}
#pragma mark - 加入购物车、立即购买
//加入购物车、立即购买
- (void)addCartOrBuyAction{
    self.addCartTool.view = self.view;
    [self.view addSubview:self.addCartTool];
    
    self.addCartTool.addCartBtn.titleLabel.numberOfLines = 1;
    self.addCartTool.addCartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.addCartTool.addCartBtn.titleLabel.font = FONT(15);
    [self.addCartTool.addCartBtn setBackgroundColor:KTitleLabelColor];
    [self.addCartTool.addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.addCartTool.buyBtn.titleLabel.numberOfLines = 1;
    self.addCartTool.buyBtn.titleLabel.font = FONT(15);
    self.addCartTool.buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addCartTool.buyBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    [self.addCartTool.buyBtn setBackgroundColor:APP_COMMON_COLOR];
    
    WEAK_SELF();
    
    self.addCartTool.addCartBlock = ^{
        
            HHActivityModel *GroupBy_m = [HHActivityModel mj_objectWithKeyValues:weakSelf.gooodDetailModel.GroupBuy];
            if ([GroupBy_m.IsJoin isEqual:@1]) {
                //我要开团
                [weakSelf lh_showHudInView:weakSelf.view labText:@"此功能正在开发中"];
            }else{
                //加入购物车
                [weakSelf  addCartHandleData];
            }
    };
   
    self.addCartTool.buyBlock = ^(UIButton *btn) {

        [weakSelf buyProductHandleData];
        
    };
    
}
#pragma mark - 处理立即购买数据

- (void)buyProductHandleData{
    
    HHFeatureSelectionViewCell *cell = [self.tabView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.seleArray.count != cell.featureAttr.count) {
        [SVProgressHUD showInfoWithStatus:@"请选择全属性"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
    }else{
        NSString *select_Id = [cell.seletedIdArray componentsJoinedByString:@"_"];
        NSString *sku_id;
        if (select_Id.length>0) {
            sku_id = select_Id;
        }else{
            sku_id = @"0";
        }
        NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",self.Id,sku_id];
        NSString *quantity = @"1";
        if (cell.Num_>0) {
            quantity = [NSString stringWithFormat:@"%ld",cell.Num_];
        }
        if (sku_id_Str.length>0) {
            //立即购买
            //      是否存在收货地址
            [self isExitAddressWithsku_id_Str:sku_id_Str quantity:quantity];
        }
        //-----//
    }
    
}

#pragma mark - 处理加入购物车数据

- (void)addCartHandleData{
    
    HHFeatureSelectionViewCell *cell = [self.tabView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.seleArray.count != cell.featureAttr.count) {
        NSMutableArray *no_select_arr = [NSMutableArray array];
        [cell.seletedIndexPaths enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSIndexPath class]]) {
            }else{
                [no_select_arr addObject:cell.featureAttr[idx]];
            }
        }];
        NSMutableArray *no_select_ValueName_arr = [NSMutableArray array];
        [no_select_arr enumerateObjectsUsingBlock:^(HHproduct_sku_valueModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [no_select_ValueName_arr addObject:model.ValueName];
        }];
        
        NSString *noSelectValueName_str = [no_select_ValueName_arr componentsJoinedByString:@" "];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请选择 %@",noSelectValueName_str]];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
    }else{
        NSString *select_Id = [cell.seletedIdArray componentsJoinedByString:@"_"];
        NSString *sku_id;
        if (select_Id.length>0) {
            sku_id = select_Id;
        }else{
            sku_id = @"0";
        }
        NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",self.Id,sku_id];
        NSString *quantity = [NSString stringWithFormat:@"%ld",cell.numberButton.currentNumber];
        
        //加入购物车
        [[[HHCartAPI postAddProductsWithsku_id:sku_id_Str quantity:quantity storeId:self.store_id] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
            
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"加入购物车成功～"];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD dismissWithDelay:1.0];
                    
                }else{
                    
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
        
        //----------//
        
    }
    
}

#pragma mark - 是否存在收货地址
- (void)isExitAddressWithsku_id_Str:(NSString *)sku_id_Str quantity:(NSString *)quantity{
    
    [[[HHCartAPI IsExistOrderAddress] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                if ([api.Data isEqual:@1]) {
                    
                    HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                    vc.enter_type = HHaddress_type_Spell_group;
                    vc.sku_Id = sku_id_Str;
                    vc.count = quantity;
                    vc.storeId = self.store_id;
                    vc.mode = self.Mode;
                    [self.navigationController pushVC:vc];
                }else{
                    HHAddAdressVC *vc = [HHAddAdressVC new];
                    vc.titleStr = @"新增收货地址";
                    vc.addressType = HHAddress_settlementType_productDetail;
                    vc.mode = self.Mode;
                    vc.sku_ids = sku_id_Str;
                    vc.storeId = self.store_id;
                    [self.navigationController pushVC:vc];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return self.preferentialArr.count;
    }
    if (section == 3) {
        return  self.productStores_names.count?1:0;
    }
    if (section == 4) {
        if (self.JoinActivity_arr.count>0) {
            return self.JoinActivity_arr.count+1;
        }else{
            return  0;
        }
    }
    if (section == 5) {
        return  1;
    }
    if (section == 6) {
        return self.evaluations.count>0?2:0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *gridcell = nil;

    if (indexPath.section == 0) {
        HHDetailGoodReferralCell *cell = [tableView dequeueReusableCellWithIdentifier:HHDetailGoodReferralCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.gooodDetailModel = self.gooodDetailModel;

        gridcell = cell;
    }
    if (indexPath.section == 1) {
        HHFeatureSelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HHFeatureSelectionViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.gooodDetailModel = self.gooodDetailModel;
        cell.product_sku_value_arr = self.gooodDetailModel.SKUValues;
        cell.lastNum = @"1";
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
        //优惠
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 8) backColor:KVCBackGroundColor];
            [cell.contentView addSubview:h_line];
            UIImageView *imag = [UIImageView lh_imageViewWithFrame:CGRectMake(15, 8, 42, 37) image:[UIImage imageNamed:@"coupon_section"]];
            imag.contentMode = UIViewContentModeCenter;
            [cell.contentView addSubview:imag];
            UILabel *text_lab = [UILabel lh_labelWithFrame:CGRectMake(57, 8, 200, 37) text:self.preferentialArr[indexPath.row] textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
            [cell.contentView addSubview:text_lab];
            UIImageView *right_arrow = [UIImageView lh_imageViewWithFrame:CGRectMake(ScreenW-52, 8, 42, 37) image:[UIImage imageNamed:@"more"]];
            right_arrow.contentMode = UIViewContentModeCenter;
            [cell.contentView addSubview:right_arrow];
            cell.separatorInset = UIEdgeInsetsMake(0, ScreenW, 0, 0);
            gridcell = cell;
        }else if((indexPath.row == self.preferentialArr.count-1)&&self.gooodDetailModel.GiveIntegral.floatValue>0){
            //积分
            HHpreferIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHpreferIntegralCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HHpreferModel *model = self.preferentialArr[indexPath.row];
            cell.model = model;
            cell.separatorInset = UIEdgeInsetsMake(0, ScreenW, 0, 0);
            gridcell = cell;
            
        }else{
            HHpreferentialModelCell *cell = [tableView dequeueReusableCellWithIdentifier:HHpreferentialModelCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HHpreferModel *model = self.preferentialArr[indexPath.row];
            cell.model = model;
            cell.separatorInset = UIEdgeInsetsMake(0, ScreenW, 0, 0);
            gridcell = cell;
        }

    }
    if (indexPath.section == 3){
        //选择门店
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.detailTextLabel.font = FONT(13);
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 8) backColor:KVCBackGroundColor];
        [cell.contentView addSubview:h_line];
        UIImageView *imag = [UIImageView lh_imageViewWithFrame:CGRectMake(15, 8, 42, 42) image:[UIImage imageNamed:@"choose_store"]];
        imag.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:imag];
        UILabel *text_lab = [UILabel lh_labelWithFrame:CGRectMake(57, 8, 100, 42) text:@"选择门店" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [cell.contentView addSubview:text_lab];
        UIImageView *right_arrow = [UIImageView lh_imageViewWithFrame:CGRectMake(ScreenW-52, 8, 42, 42) image:[UIImage imageNamed:@"more"]];
        right_arrow.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:right_arrow];
        
        self.detailText_lab = [UILabel lh_labelWithFrame:CGRectMake(157, 8, ScreenW-157-52, 42) text:@"" textColor:KTitleLabelColor font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
        [cell.contentView addSubview:self.detailText_lab];

        gridcell = cell;
    }
    if (indexPath.section == 4) {
        //拼团
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 8) backColor:KVCBackGroundColor];
            [cell.contentView addSubview:h_line];
            UILabel *text_lab = [UILabel lh_labelWithFrame:CGRectMake(20, 8, 200, 42) text:[NSString stringWithFormat:@"%@人在拼团，可直接参与",self.gooodDetailModel.UserJoinCount] textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
            [cell.contentView addSubview:text_lab];
            gridcell = cell;

        }else{
          HHSpellGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:HHSpellGroupCellID];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.model = self.JoinActivity_arr[indexPath.row-1];
          gridcell = cell;
        }
    }
    if (indexPath.section == 5) {
        //搭配套餐
        HHdiscountPackageViewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:HHdiscountPackageViewTabCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Packages = self.gooodDetailModel.Packages;
        cell.indexPath = indexPath;
        cell.nav = self.navigationController;
        gridcell = cell;
    }
    
    if (indexPath.section == 6) {
        if (indexPath.row == 0) {
            //商品评价
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 8) backColor:KVCBackGroundColor];
            [cell.contentView addSubview:h_line];
            UILabel *text_lab = [UILabel lh_labelWithFrame:CGRectMake(20, 8, 200, 42) text:@"商品评价" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
            [cell.contentView addSubview:text_lab];
            UIImageView *right_arrow = [UIImageView lh_imageViewWithFrame:CGRectMake(ScreenW-52, 8, 42, 42) image:[UIImage imageNamed:@"more"]];
            right_arrow.contentMode = UIViewContentModeCenter;
            [cell.contentView addSubview:right_arrow];
            gridcell = cell;
            
        }else{
            //商品评价
            HHEvaluationListCell *cell = [tableView dequeueReusableCellWithIdentifier:HHEvaluationListCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            ///////////////////////////////////////////////////////////////////////
            cell.model =  [HHEvaluationListModel mj_objectWithKeyValues:self.evaluations[0]];
            gridcell = cell;
        }

    }
    
    return gridcell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return [self.tabView cellHeightForIndexPath:indexPath model:self.gooodDetailModel keyPath:@"gooodDetailModel" cellClass:[HHDetailGoodReferralCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    if (indexPath.section == 1) {
        
        return   self.collectionHeight+10;
    }

    if (indexPath.section == 2) {
        //优惠
        if (indexPath.row == 0) {
            return 45;
        }else{
        HHpreferModel *model = self.preferentialArr[indexPath.row];
         return [self.tabView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHpreferentialModelCell class] contentViewWidth:[self cellContentViewWith]];
        }
    }
    if (indexPath.section == 3) {
        return 50;
    }
    if (indexPath.section == 4) {
        //拼团
        if (indexPath.row == 0) {
            return 50;
        }
        return 60;
    }
    
    if (indexPath.section == 5) {
        
        CGFloat height = 40+WidthScaleSize_H(120)+10;
        return  self.gooodDetailModel.Packages.count>0?height:0;
    }
    if (indexPath.section == 6) {
            if (indexPath.row == 0) {
                return 50;
            }else{
                id model = [HHEvaluationListModel mj_objectWithKeyValues:self.evaluations[0]];
                
                return [self.tabView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHEvaluationListCell class] contentViewWidth:[self cellContentViewWith]];
            }
        }

    return 95;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 6) {
        if (indexPath.row == 0) {
            //评价列表
            HHEvaluationListVC *vc = [HHEvaluationListVC new];
            vc.pid = self.gooodDetailModel.Id;
            [self.navigationController pushVC:vc];
        }
    }
    if (indexPath.section == 3) {
        [_pickView setStyle:HXCommonPickViewStyleDIY titleArr:self.productStores_names];
        WEAK_SELF();
        _pickView.completeBlock = ^(NSString *result) {
            weakSelf.detailText_lab.text = result;
            NSInteger index = [weakSelf.productStores_names indexOfObject:result];
            weakSelf.store_id = weakSelf.productStores_ids[index];
        };
        [_pickView showPickViewAnimation:YES];
    }
}
#pragma mark - HHFeatureSelectionViewCellDelegate

- (void)choosedStock:(NSString *)product_stock product_price:(NSString *)product_price featureselectionCell:(id)featureselectionCell{
    
    HHDetailGoodReferralCell  *cell = (HHDetailGoodReferralCell  *)[self.tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (self.IsSecKill == YES) {
        cell.product_min_priceLabel.text = @"";
    }else{
        cell.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",product_price.floatValue];
    }
    cell.stock_label.text = [NSString stringWithFormat:@"库存：%@件",product_stock];
    HHGoodDetailItem *detail_item = [HHGoodDetailItem sharedGoodDetailItem];
    detail_item.product_stock = product_stock;
    [detail_item write];
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
    WEAK_SELF();
    self.Mode = @1;
    //商品详情
    [[[HHHomeAPI GetProductDetailWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.gooodDetailModel = nil;
                self.gooodDetailModel = [HHgooodDetailModel mj_objectWithKeyValues:api.Data];
                
                self.cycleScrollView.imageURLStringsGroup = self.gooodDetailModel.ImageUrls;
                self.discribeArr =  self.gooodDetailModel.AttributeValueList.mutableCopy;
                
                self.addCartTool.product_id = self.gooodDetailModel.Id;
                if ([self.gooodDetailModel.IsCollection isEqual:@1]) {
                    self.addCartTool.collectBtn.selected  = YES;
                }else{
                    self.addCartTool.collectBtn.selected = NO;
                }
               
                self.foot.model = self.gooodDetailModel;
                
                self.addCartTool.addCartBtn.hidden = YES;

                //正在拼团列表
                self.JoinActivity_arr = self.gooodDetailModel.JoinActivity.mutableCopy;
                
                [self.preferentialArr removeAllObjects];
                if ((self.gooodDetailModel.Coupons.count>0)||(self.gooodDetailModel.MeetActivity.count>0)||(self.gooodDetailModel.GiveIntegral.floatValue>0)) {
                    [self.preferentialArr addObject:@"优惠"];
                }
                //店铺优惠券
                if (self.gooodDetailModel.Coupons.count>0) {
                    HHpreferModel *model = [HHpreferModel new];
                    model.act_name = @"店铺优惠券";
                    NSMutableArray *items_arr = [NSMutableArray array];
                    [self.gooodDetailModel.Coupons enumerateObjectsUsingBlock:^(MeetActivityModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [items_arr addObject:obj.DisplayName];
                    }];
                    model.items = items_arr;
                    [self.preferentialArr addObject:model];
                }
                //满减活动
                if (self.gooodDetailModel.MeetActivity.count>0) {
                    HHpreferModel *model = [HHpreferModel new];
                    model.act_name = @"满减活动";
                    NSMutableArray *items_arr = [NSMutableArray array];
                    [self.gooodDetailModel.MeetActivity enumerateObjectsUsingBlock:^(MeetActivityModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [items_arr addObject:obj.Name];
                    }];
                    model.items = items_arr;
                    [self.preferentialArr addObject:model];
                }
                if (self.gooodDetailModel.GiveIntegral.floatValue>0) {
                    HHpreferModel *model = [HHpreferModel new];
                    model.act_name = @"积分";
                    model.items = @[self.gooodDetailModel.GiveIntegral];
                    [self.preferentialArr addObject:model];
                }
                
                
                HHGoodDetailItem *detail_item = [HHGoodDetailItem sharedGoodDetailItem];
                detail_item.product_stock = self.gooodDetailModel.Stock;
                [detail_item write];
                
                [self.tabView reloadData];
                
                [self.activityIndicator stopAnimating];
                [hudView removeFromSuperview];
                self.addCartTool.userInteractionEnabled = YES;
                
                [self.activityIndicator removeFromSuperview];
                [self tableView:self.tabView viewForHeaderInSection:1];

                
                weakSelf.tableHeader = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_WIDTH+65) backColor:kWhiteColor];
                [weakSelf.tableHeader addSubview:self.cycleScrollView];
                
                weakSelf.seckill_view = [[HHSeckillCustomView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.cycleScrollView.frame), ScreenW-10, 65)];
                [weakSelf.tableHeader addSubview:weakSelf.seckill_view];
                
                weakSelf.IsSecKill = NO;
                weakSelf.seckill_view.hidden = YES;
                self.tableHeader.frame = CGRectMake(0, 0, ScreenW, SCREEN_WIDTH);

                self.addCartTool.addCartBtn.hidden = NO;

                // 秒杀
                HHActivityModel *SecKill_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SecKill];
                if ([SecKill_m.IsSecKill isEqual:@1]) {
                    weakSelf.IsSecKill = YES;
                    weakSelf.seckill_view.hidden = NO;
                    weakSelf.seckill_view.activity_m = SecKill_m;
                    weakSelf.seckill_view.price_label.text = [NSString stringWithFormat:@"¥%.2f",SecKill_m.Price.floatValue];
                    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:%.2f",weakSelf.gooodDetailModel.MarketPrice?weakSelf.gooodDetailModel.MarketPrice.floatValue:0.00]];
                    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
                    weakSelf.seckill_view.pre_price_label.attributedText = newPrice;
                    self.tableHeader.frame = CGRectMake(0, 0, ScreenW, SCREEN_WIDTH+65);
                    if (SecKill_m.StartSecond.integerValue>0) {
                        weakSelf.seckill_view.limit_time_label.text = @"距离活动开始";
                        weakSelf.seckill_view.countDown.timestamp = SecKill_m.StartSecond.integerValue;
                    }else{
                        weakSelf.seckill_view.limit_time_label.text = @"距离活动结束";
                        weakSelf.seckill_view.countDown.timestamp = SecKill_m.EndSecond.integerValue;
                    }
                    
                    self.tableHeader.frame = CGRectMake(0, 0, ScreenW, SCREEN_WIDTH+65);
                  
                    self.addCartTool.addCartBtn.hidden = YES;
                }
                //拼团
                HHActivityModel *GroupBy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuy];
                if ([GroupBy_m.IsJoin isEqual:@1]) {
                    self.Mode = GroupBy_m.Mode;
                    weakSelf.addCartTool.addCartBtn.titleLabel.numberOfLines = 2;
                    weakSelf.addCartTool.addCartBtn.titleLabel.font = FONT(13);
                    [weakSelf.addCartTool.addCartBtn setTitle:[NSString stringWithFormat:@"¥%0.2f\n我要开团",GroupBy_m.Price?GroupBy_m.Price.floatValue:0.00] forState:UIControlStateNormal];
                    [weakSelf.addCartTool.addCartBtn setBackgroundColor:RGB(253,74,76)];
                    weakSelf.addCartTool.buyBtn.titleLabel.numberOfLines = 2;
                    weakSelf.addCartTool.buyBtn.titleLabel.font = FONT(13);
                    [weakSelf.addCartTool.buyBtn setTitle:[NSString stringWithFormat:@"¥%0.2f\n单独购买",self.gooodDetailModel.BuyPrice?self.gooodDetailModel.BuyPrice.floatValue:0.00] forState:UIControlStateNormal];
                    
                    weakSelf.seckill_view.hidden = NO;
                    weakSelf.seckill_view.activity_m = GroupBy_m;
                    weakSelf.seckill_view.price_label.text = [NSString stringWithFormat:@"¥%.2f",GroupBy_m.Price.floatValue];
                    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:¥%.2f",weakSelf.gooodDetailModel.MarketPrice?weakSelf.gooodDetailModel.MarketPrice.floatValue:0.00]];
                    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
                    weakSelf.seckill_view.pre_price_label.attributedText = newPrice;
                    self.tableHeader.frame = CGRectMake(0, 0, ScreenW, SCREEN_WIDTH+65);
                    weakSelf.seckill_view.countDown.hidden = YES;
                    weakSelf.seckill_view.limit_time_label.text = @"";

//                    if (SecKill_m.StartSecond.integerValue>0) {
//                        weakSelf.seckill_view.limit_time_label.text = @"距离活动开始";
//                        weakSelf.seckill_view.countDown.timestamp = SecKill_m.StartSecond.integerValue;
//                    }else{
//                        weakSelf.seckill_view.limit_time_label.text = @"距离活动结束";
//                        weakSelf.seckill_view.countDown.timestamp = SecKill_m.EndSecond.integerValue;
//                    }
                    self.tableHeader.frame = CGRectMake(0, 0, ScreenW, SCREEN_WIDTH+65);

                }
                self.tabView.tableHeaderView = self.tableHeader;

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
    
   //评价
    [self getEvaluateList];
    
    //门店
    [self GetProductStore];
}
//门店列表
- (void)GetProductStore{
    
    [[[HHHomeAPI GetProductStoreWithpid:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:dic];
                    [self.productStores_names addObject:model.store_name];
                    [self.productStores_ids addObject:model.store_id];
                }];
                [self.tabView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
    
}
//评价
- (void)getEvaluateList{
    
    [[[HHHomeAPI GetProductEvaluateWithId:self.Id page:@1 pageSize:@1 hasImage:nil level:nil] netWorkClient] getRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                NSArray *arr = api.Data;
                self.evaluations = arr.mutableCopy;
                
                [self.tabView reloadSection:6 withRowAnimation:UITableViewRowAnimationNone];
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
    self.tabView.estimatedRowHeight = 50;
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.tableHeader = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_WIDTH+65) backColor:kWhiteColor];
    [self.tableHeader addSubview:self.cycleScrollView];

    self.seckill_view = [[HHSeckillCustomView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.cycleScrollView.frame), ScreenW-10, 65)];
    self.seckill_view.hidden = YES;
    [self.tableHeader addSubview:self.seckill_view];

    self.tabView.tableHeaderView = self.tableHeader;
    
}
#pragma mark - 懒加载

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)evaluations{
    
    if (!_evaluations) {
        _evaluations = [NSMutableArray array];
    }
    return _evaluations;
}
//头部
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) imageNamesGroup:@[@""]];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@""];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _cycleScrollView.currentPageDotColor = APP_COMMON_COLOR;
        _cycleScrollView.pageDotColor = RGB(228, 159, 165);
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}
- (HHAddCartTool *)addCartTool{
    if (!_addCartTool) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat y = statusRect.size.height+44;
        _addCartTool = [[HHAddCartTool alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50-y, SCREEN_WIDTH, 50)];
        _addCartTool.nav = self.navigationController;
        UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 1) backColor:RGB(220, 220, 220)];
        [_addCartTool addSubview:line];
    }
    return _addCartTool;
    
}

@end
