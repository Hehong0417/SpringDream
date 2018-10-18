//
//  HHSubmitOrdersVC.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrdersVC.h"
#import "HHSubmitOrderTool.h"
#import "HHSubmitOrderCell.h"
#import "HHSubmitOrdersHead.h"
#import "HHShippingAddressVC.h"
//#import "HHGoodBaseViewController.h"
#import "HHPaySucessVC.h"
#import "HHActivityWebVC.h"
#import "HHSendGiftWebVC.h"
#import "HHSaleGroupWebVC.h"
#import "HHFamiliarityPayVC.h"
#import "HHBargainingWebVC.h"
#import "HHPayTypeVC.h"
#import "HHCouponItem.h"
#import "HHOrderIdItem.h"
#import "HHSubmitTitleCell.h"
#import "HHOrderDetailVC.h"

@interface HHSubmitOrdersVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHShippingAddressVCProtocol,payTypeDelegate>
{
    UITextField *noteTF;
    UISwitch *swi;
}

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHSubmitOrderTool *submitOrderTool;
@property (nonatomic, strong)   NSArray *leftTitleArr;
@property (nonatomic, strong)   NSArray *leftTitle2Arr;
@property (nonatomic, strong)   NSMutableArray *rightDetailArr;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSString *address_id;
@property (nonatomic, strong)   NSNumber *pay_mode;
@property (nonatomic, strong)   NSString *Id;
@property (nonatomic, strong)   HHMineModel *address_model;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,assign) BOOL  familiarityPay;

@property(nonatomic,strong) NSMutableArray *coupons_copys;
@property(nonatomic,strong) HHcouponsModel *select_coupon_model;

@property (nonatomic, strong) NSMutableArray *productStores_names;
@property (nonatomic, strong) NSMutableArray *productStores_ids;

@property(nonatomic,strong) NSMutableArray *integralSelecItems;

@property(nonatomic,strong) NSMutableArray *shippingStoreIdsSelecItems;


@property(nonatomic,strong) HHSubmitOrdersHead *SubmitOrdersHead;
@property(nonatomic,strong) HXCommonPickView *pickView;
@property (nonatomic, strong) UIButton *currentSelectBtn;
@property (nonatomic, strong) NSIndexPath *currentSelectIndexPath;
@property (nonatomic, strong) UIButton *distributton;
@property (nonatomic, strong) NSString *toStoreId;

@end

@implementation HHSubmitOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HHCouponItem *couponsModel = [HHCouponItem sharedCouponItem];
    couponsModel.coupon_model = nil;
    couponsModel.lastSelectIndex = 0;
    couponsModel.order_total_money = 0.0f;
    couponsModel.last_total_money = 0.0f;
    [couponsModel write];

    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
    OrderIdItem.order_id = nil;
    OrderIdItem.cartIds = self.cartIds;
    [OrderIdItem write];
    
    self.page = 1;
    self.leftTitleArr  = @[@"快递运费",@"订单总计"];

    NSArray *arr = @[@"包邮",@"¥0.01"];
    self.rightDetailArr  = arr.mutableCopy;
    
    self.title = @"确认订单";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44-50;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];
    [self.tableView registerClass:[HHSubmitTitleCell class] forCellReuseIdentifier:@"HHSubmitTitleCell"];
    
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    
    //地址栏
    [self addSubmitOrdersHead];
    
    //获取我的门店
    [self getMyStoreData];
    
    //底部结算条
    [self addSubmitOrderTool];
    
    //获取收货数据
    [self getAddressData];
    
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
   
    if (self.enter_type == HHaddress_type_Spell_group) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.enter_type == HHaddress_type_add_cart){
        [self.navigationController popToRootVC];
    }else if (self.enter_type == HHaddress_type_add_productDetail){
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 2) {
                [self.navigationController popToVC:vc];
            }
        }];
    }else if(self.enter_type == HHaddress_type_another){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.enter_type == HHaddress_type_package){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSMutableArray *)datas{
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)coupons_copys{
    if (!_coupons_copys) {
        _coupons_copys = [NSMutableArray array];
    }
    return _coupons_copys;
}
- (NSMutableArray *)integralSelecItems{
    if (!_integralSelecItems) {
        _integralSelecItems = [NSMutableArray array];
    }
    return _integralSelecItems;
}
- (NSMutableArray *)shippingStoreIdsSelecItems{
    if (!_shippingStoreIdsSelecItems) {
        _shippingStoreIdsSelecItems = [NSMutableArray array];
    }
    return _shippingStoreIdsSelecItems;
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
//我的门店
- (void)getMyStoreData{
    
    [[[HHMineAPI GetUserStore] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:dic];
                    if (idx == 0) {
                        self.SubmitOrdersHead.goodStore_name_label.text = model.store_name;
                        self.toStoreId = model.store_id;
                    }
                    [self.productStores_names addObject:model.store_name];
                    [self.productStores_ids addObject:model.store_id];
                }];
            }
        }
        
    }];
    
}
//地址列表
- (void)getAddressData{
    
    [[[HHMineAPI GetAddressListWithpage:@(1)] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = (NSArray *)api.Data;
                self.address_model = [HHMineModel mj_objectWithKeyValues:arr[0]];
                self.address_id = self.address_model.AddrId;
                //设置收货地址
                self.SubmitOrdersHead.topConstraint.constant = 20;
                self.SubmitOrdersHead.model = self.address_model;
                
                //获取数据
                [self getDatas];
            }
        }
    }];
}

//获取数据
- (void)getDatas{
    
    [[[HHCartAPI GetConfirmOrderWithids:self.address_id mode:self.mode skuId:self.sku_Id quantity:self.count.numberValue gbId:self.gbId storeId:self.storeId cardIds:self.cartIds] netWorkClient] getRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.model =  [HHCartModel mj_objectWithKeyValues:api.Data];

                self.datas = self.model.orders.mutableCopy;
                NSArray *orders_copys = self.model.orders;
           
                [orders_copys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.integralSelecItems addObject:@0];
                    [self.shippingStoreIdsSelecItems addObject:@1];
                }];
                if (self.model.coupons.count>0) {
                    [self.datas addObject:@"可用优惠券"];
                }
                //设置地址
                self.SubmitOrdersHead.addressModel = self.model;
                self.address_id = self.model.addrId;
                
                if ([self.model.isSeniorExecutiveGroup isEqual:@1]) {
                    //选择收货门店
                    self.SubmitOrdersHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
                    self.SubmitOrdersHead.goodStore_view.hidden = NO;
                }else{
                   self.toStoreId = nil;
                   self.SubmitOrdersHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
                   self.SubmitOrdersHead.goodStore_view.hidden = YES;
                }
                
                CGFloat money_total = self.model.totalMoney.doubleValue;
                self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",money_total];
                
                [self.tableView reloadData];
                
                //
                HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
                couponItem.order_total_money = self.model.totalMoney.doubleValue;
                couponItem.lastSelectIndex = 0;
                couponItem.last_total_money = money_total;
                NSMutableArray *arr = [NSMutableArray array];
                [self.model.coupons enumerateObjectsUsingBlock:^(HHcouponsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arr addObject:@0];
                    *stop = 0;
                }];
                
                [arr insertObject:@1 atIndex:0];
                couponItem.selectItems = arr.mutableCopy;
                [couponItem write];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }
    }];
    
}
- (void)addSubmitOrdersHead{
    
    self.SubmitOrdersHead = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrdersHead" owner:nil options:nil] lastObject];
    self.SubmitOrdersHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.SubmitOrdersHead.goodStore_view.hidden = YES;
    self.SubmitOrdersHead.userInteractionEnabled = YES;
    UIImageView *imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) image:[UIImage imageNamed:@"addr_bg"]];
    [self.SubmitOrdersHead insertSubview:imageV atIndex:0];
    //收货地址
    WEAK_SELF();
    [self.SubmitOrdersHead setTapActionWithBlock:^{
       
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        vc.delegate = weakSelf;
        vc.enter_type = HHenter_type_submitOrder;
        [weakSelf.navigationController pushVC:vc];
        
    }];
    self.tableView.tableHeaderView = self.SubmitOrdersHead;
    
    self.pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.SubmitOrdersHead.goodStore_view.userInteractionEnabled = YES;
    [self.SubmitOrdersHead.goodStore_view setTapActionWithBlock:^{
        if (self.productStores_names.count>0) {
            [self.pickView setStyle:HXCommonPickViewStyleDIY titleArr:self.productStores_names];
            WEAK_SELF();
            self.pickView.completeBlock = ^(NSString *result) {
                weakSelf.SubmitOrdersHead.goodStore_name_label.text = result;
                NSInteger index = [weakSelf.productStores_names indexOfObject:result];
                weakSelf.toStoreId = weakSelf.productStores_ids[index];
            };
            [self.pickView showPickViewAnimation:YES];
        }
    }];
}
- (void)addSubmitOrderTool{
    
    self.submitOrderTool  = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrderTool" owner:nil options:nil] lastObject];
    self.submitOrderTool.closePay_constant_w.constant = 0;
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-STATUS_NAV_HEIGHT-50-SafeAreaBottomHeight, SCREEN_WIDTH, 50)];
    self.submitOrderTool.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    
    
    self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled = YES;
    //去付款
    [self.submitOrderTool.ImmediatePayLabel setTapActionWithBlock:^{
        
        [self submitOrderAction];
    
    }];
    
    //亲密付
    self.submitOrderTool.closePay.userInteractionEnabled = YES;
    [self.submitOrderTool.closePay setTapActionWithBlock:^{
        self.familiarityPay = YES;
        self.mode = @16;
        [self createOrder];
    }];
    [toolView addSubview:self.submitOrderTool];
    [self.view addSubview:toolView];
}

#pragma mark - HHShippingAddressVCProtocol

- (void)shippingAddressTableView_didSelectRowWithaddressModel:(HHMineModel *)addressModel{
   
    self.address_id = addressModel.AddrId;
    //设置收货地址
    self.SubmitOrdersHead.topConstraint.constant = 20;
    self.SubmitOrdersHead.model = addressModel;
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"logo_data_disabled"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂时没有数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:KACLabelColor
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -100;
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.datas.count-1&&self.datas.count>self.model.orders.count) {
     //优惠券
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.textColor = KTitleLabelColor;
        cell1.detailTextLabel.textColor = KTitleLabelColor;
        cell1.textLabel.font = FONT(13);
        cell1.detailTextLabel.font = FONT(14);
        cell1.textLabel.text = self.datas[indexPath.section];
        cell1.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
        
    }else{
        HHordersModel *order_model = self.datas[indexPath.section];
        if (indexPath.row<order_model.products.count) {
            HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
            HHproductsModel *model = order_model.products[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.productsModel = model;
            return cell;
        }else{
            UITableViewCell *gridCell = nil;
            if (indexPath.row == order_model.products.count) {
                HHSubmitTitleCell *subTitleCell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitTitleCell"];
                subTitleCell.detail_label.attributedText = order_model.addtion_value_arr[indexPath.row-order_model.products.count];
                gridCell = subTitleCell;
                
            }else{
                UITableViewCell *cell1 =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                cell1.textLabel.textColor = KTitleLabelColor;
                cell1.detailTextLabel.textColor = kBlackColor;
                cell1.textLabel.font = FONT(13);
                cell1.detailTextLabel.font = FONT(14);
                
                cell1.textLabel.text = order_model.addtion_arr[indexPath.row-order_model.products.count];
                cell1.detailTextLabel.text = order_model.addtion_value_arr[indexPath.row-order_model.products.count];
                if (order_model.isCanUseIntegral.integerValue == 1&&indexPath.row == order_model.products.count+order_model.addtion_value_arr.count-1) {
                    //可用积分
                    UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(IntegralSelectAction:) image:[UIImage imageNamed:@"icon_sign_default"]];
                    [btn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
                    btn.tag = indexPath.section+10000;
                    cell1.accessoryView = btn;
                    btn.selected = ((NSNumber *)self.integralSelecItems[indexPath.section]).boolValue;
                    if (btn.selected) {
                        NSInteger  row = indexPath.row-1;
                        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",order_model.showMoney.doubleValue -  order_model.orderIntegralMoney.doubleValue];
                    }
                }
                gridCell = cell1;

            }
            
            return gridCell;
        }
    }
    return nil;
}
//积分选择
- (void)IntegralSelectAction:(UIButton *)btn{
    
    NSInteger section = btn.tag-10000;
    
    HHordersModel *order_model = self.datas[section];
    
    NSInteger  row = order_model.products.count;
    
    if (section == self.datas.count-1&&self.datas.count>self.model.orders.count) {
        
    }else{
        
    __block  float totol_Integral=0;
    [self.model.orders enumerateObjectsUsingBlock:^(HHordersModel *order_model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.integralSelecItems enumerateObjectsUsingBlock:^(NSNumber  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@1]) {
                totol_Integral = totol_Integral+order_model.orderIntegral.doubleValue;
            }
            *stop = 0;
        }];
    }];
        if (btn.selected) {
            btn.selected = NO;
            [self updatePriceSubMitToolWithbtn:btn section:section row:row];

        }else{
          if (totol_Integral>self.model.totalIntegral.doubleValue) {
            [SVProgressHUD showInfoWithStatus:@"积分不足"];
              btn.selected = NO;
          }else{
            btn.selected = YES;
              [self updatePriceSubMitToolWithbtn:btn section:section row:row];
          }
            
        }
        NSLog(@"totol_Integral:%.2f",totol_Integral);

   
    }
}
- (void)updatePriceSubMitToolWithbtn:(UIButton *)btn section:(NSInteger)section row:(NSInteger)row{
    
    //订单总计
    HHSubmitTitleCell *subTitleCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    HHordersModel *order_model = self.datas[section];
    if (btn.selected) {
        NSString *protocolStr = [NSString stringWithFormat:@"¥%.2f",order_model.showMoney.doubleValue -  order_model.orderIntegralMoney.doubleValue];
        NSString *contentStr = [NSString stringWithFormat:@"共%ld件商品,合计:%@",order_model.products.count,protocolStr];
        NSMutableAttributedString *attr = [NSString lh_attriStrWithprotocolStr:protocolStr content:contentStr protocolStrColor:APP_NAV_COLOR contentColor:kDarkGrayColor commonFont:FONT(14)];
        subTitleCell.detail_label.attributedText = attr;
        
        //总计
        NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:4];
        
        CGFloat money_total =  money_total_str.doubleValue - order_model.orderIntegralMoney.doubleValue;
        self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",money_total];
        
    }else{
        NSString *protocolStr = [NSString stringWithFormat:@"¥%.2f",order_model.showMoney.floatValue];
        NSString *contentStr = [NSString stringWithFormat:@"共%ld件商品,合计:%@",order_model.products.count,protocolStr];
        NSMutableAttributedString *attr = [NSString lh_attriStrWithprotocolStr:protocolStr content:contentStr protocolStrColor:APP_NAV_COLOR contentColor:kDarkGrayColor commonFont:FONT(14)];
        subTitleCell.detail_label.attributedText = attr;
        //总计
        NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:4];
        
        CGFloat money_total = money_total_str.doubleValue + order_model.orderIntegralMoney.doubleValue;
        self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",money_total];
    }
    
    HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
    NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:4];
    couponItem.order_total_money = money_total_str.doubleValue;
    [couponItem write];
    
    [self.integralSelecItems replaceObjectAtIndex:section withObject:@(btn.selected)];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.datas.count>self.model.orders.count&&section == self.datas.count-1) {
        return 1;
    }else{
        HHordersModel *order_model = self.datas[section];
        return order_model.products.count+order_model.addtion_arr.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.datas.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHordersModel *order_model = self.datas[indexPath.section];
    if (indexPath.section == self.datas.count-1&&self.datas.count>self.model.orders.count) {
        return 44;
    }else{
      if (indexPath.row<order_model.products.count) {
        return 100;
      }else{
          if (indexPath.row == order_model.products.count) {

              return 44;
          }
        return 30;
      }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.datas.count>self.model.orders.count&&indexPath.section == self.datas.count-1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        HHPayTypeVC *vc = [HHPayTypeVC new];
        vc.delegate = self;
        self.coupons_copys = self.model.coupons.mutableCopy;
        HHcouponsModel *coupon_m = [HHcouponsModel new];
        coupon_m.CouponValue = 0;
        coupon_m.DisplayName = @"不使用";
        [self.coupons_copys insertObject:coupon_m atIndex:0];
        vc.coupons = self.coupons_copys;
        NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:4];
        vc.total_money = money_total_str;
        vc.submitOrderTool = self.submitOrderTool;
        vc.title_str = @"优惠详情";
        vc.btn_title = @"确   定";
        vc.couponCell = cell;
        [self setUpAlterViewControllerWith:vc WithDistance:ScreenH/2 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *sectionHead =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        sectionHead.backgroundColor = kWhiteColor;
    if (self.datas.count>self.model.orders.count&&section == self.datas.count-1) {
      //优惠券
      
    }else{
        HHordersModel *order_model = self.datas[section];

        UIButton *button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 40, 40) target:self action:nil image:[UIImage imageNamed:@"logo"] title:nil titleColor:kBlackColor font:FONT(13)];

        [sectionHead addSubview:button];
        
        CGSize storeName_size = [order_model.storeName lh_sizeWithFont:FONT(13)  constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        
        UILabel *storeName_label = [UILabel lh_labelWithFrame:CGRectMake(40, 0, storeName_size.width+10, 40) text:order_model.storeName textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [sectionHead addSubview:storeName_label];

        
        //配送方式
        if (order_model.storeId.integerValue>0) {
            
        UIView *distribution_view = [UIView lh_viewWithFrame:CGRectMake(ScreenW-150, 0, 150, 40) backColor:kWhiteColor];
        
        NSInteger  shippingStore_way = ((NSNumber *)self.shippingStoreIdsSelecItems[section]).integerValue;
        
        NSArray *btnImag = @[@"  自提",@"  邮寄"];
        for (NSInteger i =0; i<2; i++) {
         
            self.distributton = [UIButton lh_buttonWithFrame:CGRectMake(i*60, 0, 60, 40) target:self action:nil image:[UIImage imageNamed:@"icon_sign_default"] title:btnImag[i] titleColor:kBlackColor font:FONT(13)];
            self.distributton.tag = i+section+10000;
            [self.distributton setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
            if (i == shippingStore_way) {
                self.distributton.selected = YES;
            }
            WEAK_SELF();
            [weakSelf.distributton setTapActionWithBlock:^{
                
                [weakSelf selecetDistributton:weakSelf.distributton section:section index:i];
            }];
            [distribution_view addSubview:self.distributton];
        }

        [sectionHead addSubview:distribution_view];

        }
        
    }
    return sectionHead;
}
//选择配送方式
- (void)selecetDistributton:(UIButton *)button section:(NSInteger)section index:(NSInteger)index{
    
    [self.shippingStoreIdsSelecItems replaceObjectAtIndex:section withObject:@(index)];
    
    [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.datas.count>self.model.orders.count&&section == self.datas.count-1) {
        //优惠券
        return 5;
    }else{
        return 40;
    }
}

#pragma mark- payTypeDelegate

- (void)commitActionWithBtn:(UIButton *)btn selectIndex:(NSInteger)selectIndex select_model:(HHcouponsModel *)model total_money:(CGFloat )total_money submitOrderTool:(HHSubmitOrderTool *)submitOrderTool couponCell:(UITableViewCell *)couponCell lastConponValue:(CGFloat)lastConponValue last_total_money:(CGFloat)last_total_money {
    
    if (selectIndex == 0) {
        //不使用
        HHCouponItem *coupon_item = [HHCouponItem sharedCouponItem];
        coupon_item.coupon_model = nil;
        coupon_item.lastSelectIndex = 0;
        [coupon_item write];
        CGFloat money_total;
        if (last_total_money<=lastConponValue) {
            money_total = total_money;
        }else{
            money_total = total_money + lastConponValue;
        }
        
        submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",money_total>0?money_total:0.01];
        couponCell.detailTextLabel.text = @"不使用";

    }else{
        
        CGFloat money_total = total_money-model.CouponValue.doubleValue;
        submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",money_total>0?money_total:0.01];
        couponCell.detailTextLabel.text = model.DisplayName;
        
        HHCouponItem *coupon_item = [HHCouponItem sharedCouponItem];
        coupon_item.coupon_model = model;
        coupon_item.lastSelectIndex = selectIndex;
        [coupon_item write];
        
    }
}
#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance WithDirection:(XWDrawerAnimatorDirection)vcDirection WithParallaxEnable:(BOOL)parallaxEnable WithFlipEnable:(BOOL)flipEnable
{
    [self dismissViewControllerAnimated:YES completion:nil]; //以防有控制未退出
    XWDrawerAnimatorDirection direction = vcDirection;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = parallaxEnable;
    animator.flipEnable = flipEnable;
    [self xw_presentViewController:vc withAnimator:animator];
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{

    }];
}
#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 去付款

- (void)submitOrderAction{
    
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
        
        self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled = NO;
        self.submitOrderTool.closePay.userInteractionEnabled = NO;
        
//        if (self.enter_type == HHaddress_type_Spell_group) {
//            //活动拼团
//            [self createOrder];
//
//        }else if (self.enter_type == HHaddress_type_add_cart){
//            if ([self.sendGift isEqual:@1]) {
//                //送礼
//                [self createOrder];
//            }else{
                //购物车
                [self createOrder];
//            }
//        }else if (self.enter_type == HHaddress_type_package){
//            //优惠套餐
//            [self createOrder];
//        }
    }else{
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"你未安装微信，是否安装？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertC dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
}
#pragma mark - 创建订单
- (void)createOrder{
    
    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
    if (OrderIdItem.order_id) {
        [self orderPayWithaddress_id:nil orderId:OrderIdItem.order_id];
    }else{
        //优惠券
        NSString *coupon_id=nil;
        HHCouponItem *couponsModel = [HHCouponItem sharedCouponItem];
        if (couponsModel.coupon_model) {
            coupon_id = couponsModel.coupon_model.UserCouponId;
        }else{
            coupon_id = nil;
        }
        //积分
        NSString *integralTempIds_str;
        NSMutableArray *integralTempIds_arr = [NSMutableArray array];
        [self.integralSelecItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@1]) {
       
                [self.model.orders enumerateObjectsUsingBlock:^(HHordersModel * order_m, NSUInteger two_idx, BOOL * _Nonnull stop) {
                    if (idx == two_idx) {
                        [integralTempIds_arr addObject:order_m.freightId];
                    }
                }];
            }
        }];

        if (integralTempIds_arr.count>0) {
            integralTempIds_str = [integralTempIds_arr componentsJoinedByString:@","];
        }
        
        //配送方式
        NSString *shippingStoreIds_str;
        NSMutableArray *shippingStoreIds_arr = [NSMutableArray array];
        
        [self.shippingStoreIdsSelecItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@0]) {
                [self.model.orders enumerateObjectsUsingBlock:^(HHordersModel * order_m, NSUInteger two_idx, BOOL * _Nonnull stop) {
                    if (idx == two_idx) {
                        [shippingStoreIds_arr addObject:order_m.storeId];
                    }
                }];
            }
        }];
        
        if (shippingStoreIds_arr.count>0) {
            shippingStoreIds_str = [shippingStoreIds_arr componentsJoinedByString:@","];
        }
        
        //
        if ([self.model.isSeniorExecutiveGroup isEqual:@0]) {
            self.toStoreId = @"0";
        }
        
        [[[HHMineAPI postOrder_CreateWithAddrId:self.address_id skuId:self.sku_Id count:self.count mode:self.mode gbId:self.gbId couponId:coupon_id integralTempIds:integralTempIds_str message:nil cartIds:self.cartIds storeId:self.toStoreId shippingStoreIds:shippingStoreIds_str]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled  = YES;
            self.submitOrderTool.closePay.userInteractionEnabled = YES;
            if (!error) {
                if (api.State == 1) {
                    
                    self.order_id = api.Data;
                    //亲密付
                    if (self.familiarityPay) {
                        HHFamiliarityPayVC *vc = [HHFamiliarityPayVC new];
                        vc.orderId = self.order_id;
                        [self.navigationController pushVC:vc];
                    }else if ([self.mode isEqual:@4096]){
                        HHBargainingWebVC *vc = [HHBargainingWebVC new];
                        vc.orderId = self.order_id;
                        [self.navigationController pushVC:vc];
                    } else{
                        //保存创建的订单号
                        HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
                        OrderIdItem.order_id = self.order_id;
                        [OrderIdItem write];
                        
                        [self orderPayWithaddress_id:nil orderId:self.order_id];
                    }
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else {
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
    }
    
}
#pragma mark - 订单支付
-(void)orderPayWithaddress_id:(NSString *)address_id orderId:(NSString *)orderId{
    
    [[[HHMineAPI postOrder_AppPayAddrId:address_id orderId:orderId money:nil]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled  = YES;
        if (!error) {
            if (api.State == 1) {
                HHWXModel *model = [HHWXModel mj_objectWithKeyValues:api.Data];
                [HHWXModel payReqWithModel:model];
            }else{
                if ([api.Msg isEqualToString:@"客户不存在"]) {
                    
                    [SVProgressHUD showInfoWithStatus:@"微信支付相关公众号正在申请中，请耐心等候！"];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
        }else {
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
    }];
}

#pragma mark-微信支付

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
    
}
- (void)wxPaySucesscount{
    
    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
    OrderIdItem.order_id = nil;
    [OrderIdItem write];

    if (self.enter_type == HHaddress_type_Spell_group) {
        //活动拼团----订单详情
        [[[HHMineAPI GetOrderDetailWithorderid:self.order_id] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    //发送删除立即购买的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:DELETE_SHOPITEMSELECTBACK object:nil userInfo:nil];
                    
                    self.model = [HHCartModel mj_objectWithKeyValues:api.Data];
                    if ([self.mode isEqual:@2]) {
                        HHActivityWebVC *vc = [HHActivityWebVC new];
                        vc.gbId = self.model.gbid;
                        [self.navigationController pushVC:vc];
                    }else if([self.mode isEqual:@8]){
                        HHSendGiftWebVC *vc = [HHSendGiftWebVC new];
                        vc.gbId = self.model.gbid;
                        vc.orderId = self.order_id;
                        [self.navigationController pushVC:vc];
                    }else if ([self.mode isEqual:@32]){
                        HHSaleGroupWebVC *vc = [HHSaleGroupWebVC new];
                        vc.gbId = self.model.gbid;
                        [self.navigationController pushVC:vc];
                    }
                }else{
                    
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
        
    }else {
        //购物车
//        HHPaySucessVC *vc = [HHPaySucessVC new];
//        vc.pids = OrderIdItem.cartIds;
//        [self.navigationController pushVC:vc];
        HHOrderDetailVC *vc = [HHOrderDetailVC new];
        vc.orderid = self.order_id;
        vc.isCreateOrderEnter = YES;
        [self.navigationController pushVC:vc];

    }
}

- (void)wxPayFailcount {

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
//        [SVProgressHUD showErrorWithStatus:@"支付失败～"];
//
//    });
    HHOrderDetailVC *vc = [HHOrderDetailVC new];
    vc.orderid = self.order_id;
    vc.isCreateOrderEnter = YES;
    [self.navigationController pushVC:vc];
    
    
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];

    return copy;
}
@end
