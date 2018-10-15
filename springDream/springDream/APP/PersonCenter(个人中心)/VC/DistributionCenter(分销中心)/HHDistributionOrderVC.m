//
//  HHMyOrderVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHDistributionOrderVC.h"
#import "HJOrderCell.h"
#import "HHOrderTwoCell.h"
#import "HHSubmitOrdersVC.h"
#import "HHOrderDetailVC.h"
#import "HHMyOrderItem.h"
#import "HHPostEvaluationVC.h"
#import "HHEvaluationListVC.h"
#import "HHNewApplyRefundVC.h"
#import "HHOrderItemModel.h"
#import "HHMyOrderItem.h"
#import "HHFamiliarityPayVC.h"
#import "HHPaySucessVC.h"
#import "HHLogisticsVC.h"

@interface HHDistributionOrderVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,NewApplyRefundDelegate>

@property(nonatomic,strong)   SGSegmentedControl *SG;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   NSMutableArray *items_arr;
@property (nonatomic, assign)   BOOL isFooterRefresh;
@property (nonatomic, assign)   BOOL isHeaderRefresh;
@property(nonatomic,assign)   BOOL  isLoading;
@property(nonatomic,assign)   BOOL  isWlan;
@end
@implementation HHDistributionOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分销订单";
    self.view.backgroundColor = KVCBackGroundColor;
    self.page = 1;
    //UI
    [self setUI];
    
}
#pragma mark - UI
- (void)setUI{
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT-64;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //registerCell
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderTwoCell" bundle:nil] forCellReuseIdentifier:@"HHOrderTwoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderCell" bundle:nil] forCellReuseIdentifier:@"HJOrderCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderOneCell" bundle:nil] forCellReuseIdentifier:@"HJOrderOneCell"];
    
    //headdRefresh
    [self addHeadRefresh];
    [self addFootRefresh];
    
}
#pragma mark - 懒加载
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)items_arr{
    if (!_items_arr) {
        _items_arr = [NSMutableArray array];
    }
    return _items_arr;
}

#pragma mark - 刷新控件
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        
        self.isFooterRefresh = NO;
        self.isHeaderRefresh = YES;
     [self getDatasWithIndex:@0];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        self.isHeaderRefresh = NO;
        [self getDatasWithIndex:@0];
    }];
    refreshfooter.stateLabel.textColor = KTitleLabelColor;
    self.tableView.mj_footer = refreshfooter;
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        if (self.isWlan) {
            return [UIImage imageNamed:@"record_icon_no"];
        }else{
            return [UIImage imageNamed:@"img_network_disable"];
        }
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *titleStr;
    if (self.isLoading) {
        if (self.isWlan) {
            titleStr = @"没有相应的订单记录喔";
        }else{
            titleStr = @"";
        }
    }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
    
    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20;
}
#pragma mark - NetWork

- (void)getDatasWithIndex:(NSNumber *)index{
    
    
    [[[HHMineAPI GetDistributionOrderWithpage:@(self.page) pageSize:@15] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.isLoading = YES;
        
        if (self.isHeaderRefresh ==YES) {
            [self.datas removeAllObjects];
            [self.items_arr removeAllObjects];
        }
        if (!error) {
            if (api.State == 1) {
                self.isWlan = YES;
                [self.items_arr  removeAllObjects];
                [self loadDataFinish:api.Data];
                
            }else{
                self.isWlan = YES;
                [SVProgressHUD showInfoWithStatus:api.Msg];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
                [self.tableView reloadData];
            }
        }else{
            self.isWlan = NO;
            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - 刷新数据处理
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    //处理数据
    [self.datas enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        HHCartModel *cart_m = [HHCartModel mj_objectWithKeyValues:dic];
        
        HHOrderItemModel *orderItem_m = [HHOrderItemModel new];
        orderItem_m.order_id = cart_m.order_id;
        orderItem_m.order_date = cart_m.order_date;
        orderItem_m.status = cart_m.status;
        orderItem_m.status_name = cart_m.status_name;
        orderItem_m.order_can_evaluate = cart_m.order_can_evaluate;
        orderItem_m.total = cart_m.total;
        
        [cart_m.items enumerateObjectsUsingBlock:^(HHproductsModel *productsM, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [productsM.product_item enumerateObjectsUsingBlock:^(HHproducts_item_Model * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HHproducts_item_Model *products_item_m = [HHproducts_item_Model new];
                products_item_m.prodcut_name = productsM.prodcut_name;
                products_item_m.icon = productsM.icon;
                products_item_m.product_item_id = obj.product_item_id;
                products_item_m.product_item_price = obj.product_item_price;
                products_item_m.product_item_quantity = obj.product_item_quantity;
                products_item_m.product_item_status = obj.product_item_status;
                products_item_m.product_item_sku_name = obj.product_item_sku_name;
                [orderItem_m.items addObject:products_item_m];
                [orderItem_m.pids addObject:obj.product_item_id];
            }];
        }];
        [self.items_arr addObject:orderItem_m];
    }];
    if (arr.count < 15) {
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
    self.tableView.mj_footer.hidden = NO;
    
    if (noMoreData) {
        if (self.datas.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    }
    //刷新界面
    [self.tableView reloadData];
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    
}
#pragma mark --- ApplyRefundDelegate

- (void)backActionWithBtn:(UIButton *)btn{
    [self.items_arr removeAllObjects];
    [self.datas removeAllObjects];
    [self getDatasWithIndex:@0];
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    HHOrderItemModel *orders_m = self.items_arr[indexPath.section];
    
    UITableViewCell *grideCell;
    if (indexPath.row == orders_m.items.count){
        //订单总计
        HHOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderTotalModel = orders_m;
        grideCell = cell;
        
    }else{
        //商品
        HJOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HJOrderCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HHproducts_item_Model *product_m = orders_m.items[indexPath.row];
        cell.productModel =  product_m;
        cell.nav = self.navigationController;
        [self setStandardLabWith:product_m cell:cell];
        grideCell = cell;
        
        [cell.StandardLab setTapActionWithBlock:^{
            
            HHNewApplyRefundVC *vc = [[HHNewApplyRefundVC alloc] init];
            vc.delegate = self;
            HHproducts_item_Model *model1 = orders_m.items[indexPath.row];
            vc.order_id = orders_m.order_id;
            vc.item_model = model1;
            
            if (product_m.product_item_status.integerValue == 2||product_m.product_item_status.integerValue == 6||product_m.product_item_status.integerValue == 9) {
                vc.title_str = @"申请退款";
            }else if (product_m.product_item_status.integerValue == 3||product_m.product_item_status.integerValue == 7||product_m.product_item_status.integerValue == 10){
                vc.title_str = @"申请退货";
            }
            [self.navigationController pushVC:vc];
        }];
    }
    grideCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    
    return grideCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) backColor:kWhiteColor];
    
    UIView *line = [UIView lh_viewWithFrame:CGRectMake(10, 0, ScreenW-20, 1) backColor:KVCBackGroundColor];
    [footView addSubview:line];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-160-30, 10, 80, 30) target:self action:@selector(oneAction:) title:@"取消" titleColor:kBlackColor font:FONT(14) backgroundColor:KVCBackGroundColor];
    oneBtn.tag = section+100;
    
    [oneBtn lh_setCornerRadius:0 borderWidth:1 borderColor:KDCLabelColor];
    [footView addSubview:oneBtn];
    
    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-95, 10, 80, 30) target:self action:@selector(twoAction:) title:@"去评价" titleColor:RGB(213, 128, 136) font:FONT(14) backgroundColor:RGB(255, 239, 239)];
    twoBtn.tag = section+1000;
    [twoBtn lh_setCornerRadius:0 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    //分割线Y坐标
    CGFloat down_y = 50;
    if (self.datas.count>0) {
        HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
        NSString *status = model.status;
        if ([status isEqualToString:@"1"]) {
            //待付款
            down_y = 50;
            //oneBtn
            [self setBtnAttrWithBtn:oneBtn Title:@"取消订单" CornerRadius:0 borderColor:KDCLabelColor titleColor:kBlackColor backgroundColor:KVCBackGroundColor];
            //twoBtn
            NSString *twoBtn_title = @"前往支付";
            if ([model.order_mode isEqual:@16]) {
                
                twoBtn_title = @"亲密付";
            }else{
                twoBtn_title = @"前往支付";
            }
            [self setBtnAttrWithBtn:twoBtn Title:twoBtn_title CornerRadius:0 borderColor:APP_COMMON_COLOR titleColor:RGB(213, 128, 136) backgroundColor:RGB(255, 239, 239)];
        }else if([status isEqualToString:@"2"]){
            //待发货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:YES];
        }else if([status isEqualToString:@"3"]){
            //待收货
            down_y = 50;
            [self setBtnAttrWithBtn:oneBtn Title:@"查看物流" CornerRadius:0 borderColor:KDCLabelColor titleColor:kBlackColor backgroundColor:KVCBackGroundColor];
            [self setOneBtn:oneBtn WithOneBtnState:NO twoBtn:twoBtn twoBtnState:NO];
            [self setBtnAttrWithBtn:twoBtn Title:@"确认收货" CornerRadius:0 borderColor:APP_COMMON_COLOR titleColor:RGB(213, 128, 136) backgroundColor:RGB(255, 239, 239)];
        }else if([status isEqualToString:@"4"]){
            //订单关闭
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:YES];
            
        }else if([status isEqualToString:@"5"]){
            // @"待评价";
            down_y = [model.order_can_evaluate isEqual:@1]?50:0;
            BOOL oneBtnState =  [model.order_can_evaluate isEqual:@1]?NO:YES;
            BOOL twoBtnState =  [model.order_can_evaluate isEqual:@1]?NO:YES;
            
            [self setBtnAttrWithBtn:oneBtn Title:@"查看物流" CornerRadius:0 borderColor:KDCLabelColor titleColor:kBlackColor backgroundColor:KVCBackGroundColor];
            [self setOneBtn:oneBtn WithOneBtnState:oneBtnState twoBtn:twoBtn twoBtnState:twoBtnState];
            //twoBtn
            [self setBtnAttrWithBtn:twoBtn Title:@"去评价" CornerRadius:0 borderColor:APP_COMMON_COLOR titleColor:RGB(213, 128, 136) backgroundColor:RGB(255, 239, 239)];
        }else if([status isEqualToString:@"6"]){
            // 申请退款
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"7"]){
            // 申请退货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"8"]){
            // 申请换货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"9"]){
            // 已退款
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"10"]){
            // 已退货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }
    }
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, down_y, SCREEN_WIDTH, 5) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];
    
    return footView;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
//
//    if (indexPath.row == model.items.count){
//        //订单总计
//    }else{
//        //商品
//        HHOrderDetailVC *vc = [HHOrderDetailVC new];
//        vc.orderid = model.order_id;
//        [self.navigationController pushVC:vc];
//    }
}
//设置按钮隐藏或显示
- (void)setOneBtn:(UIButton *)oneBtn WithOneBtnState:(BOOL)oneBtnSate twoBtn:(UIButton *)twoBtn twoBtnState:(BOOL)twoBtnState{
    oneBtn.hidden = oneBtnSate;
    twoBtn.hidden = twoBtnState;
}
//设置退款退货按钮状态
-(void)setStandardLabWith:(HHproducts_item_Model *)productModel cell:(HJOrderCell *)cell{
    cell.StandardLab.hidden = NO;
    [HHMyOrderItem shippingLogisticsStateWithStatus_code:productModel.product_item_status.integerValue cell:cell];
}
//设置段尾按钮属性和标题
- (void)setBtnAttrWithBtn:(UIButton *)btn Title:(NSString *)title CornerRadius:(NSInteger)cornerRadius borderColor:(UIColor *)borderColor titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor{
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn lh_setCornerRadius:cornerRadius borderWidth:1 borderColor:borderColor];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:backgroundColor];
}

- (void)oneAction:(UIButton *)btn{
    NSInteger section = btn.tag - 100;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    NSString *status = model.status;
    
    if ([status isEqualToString:@"1"]) {
        //待付款--->取消订单
        [self handleOrderWithorderid:model.order_id status:HHhandle_type_cancel btn:btn title:@"确定取消订单吗？"];
        
    }else if([status isEqualToString:@"2"]){
        //待发货
        
    }else if([status isEqualToString:@"3"]){
        
        //待收货--->查看物流
        HHLogisticsVC *vc = [HHLogisticsVC new];
        vc.orderid = model.order_id;
        //              vc.express_order = model.return_goods_express_order;
        //               vc.express_name = model.return_goods_express_name;
        [self.navigationController pushVC:vc];
        
    }else if([status isEqualToString:@"5"]){
        //交易成功-->删除订单
        HHLogisticsVC *vc = [HHLogisticsVC new];
        vc.orderid = model.order_id;
        // vc.express_order = model.return_goods_express_order;
        // vc.express_name = model.return_goods_express_name;
        [self.navigationController pushVC:vc];
    }
}
//处理订单
- (void)handleOrderWithorderid:(NSString *)orderid status:(HHhandle_type)handle_type btn:(UIButton *)btn  title:(NSString *)titleStr{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:titleStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn.enabled = NO;
        if (handle_type == HHhandle_type_cancel) {
            //取消订单
            [[[HHMineAPI postOrder_CloseWithorderid:orderid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                btn.enabled = YES;
                if (!error) {
                    if (api.State == 1) {
                        [self.datas removeAllObjects];
                        [self.items_arr removeAllObjects];
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"取消订单成功！"];
                        [self getDatasWithIndex:@0];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }
            }];
        }else if (handle_type == HHhandle_type_delete){
            //删除订单
            
        }else if (handle_type == HHhandle_type_Confirm){
            //确认收货
            [[[HHMineAPI postConfirmOrderWithorderid:orderid]netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                btn.enabled = YES;
                if (!error) {
                    if (api.State == 1) {
                        
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"确认收货成功！"];
                        self.page = 1;
                        [self.datas removeAllObjects];
                        [self.items_arr removeAllObjects];
                        [self getDatasWithIndex:@0];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }else {
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }];
        }
        //        广州市番禺区大石镇周岸坊前街一巷6-1
        //        兴华街3巷3号401
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

//支付订单
- (void)payOrderWithorderid:(NSString *)orderid btn:(UIButton *)btn pid:(NSString *)pid{
    
    btn.enabled = NO;
    //----->微信支付
    [[[HHMineAPI postOrder_AppPayAddrId:nil orderId:orderid money:nil]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        btn.enabled = YES;
        if (!error) {
            if (api.State == 1) {
                HHWXModel *model = [HHWXModel mj_objectWithKeyValues:api.Data];
                HJUser *user = [HJUser sharedUser];
                user.pids = pid;
                [user write];
                [HHWXModel payReqWithModel:model];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else {
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}
- (void)twoAction:(UIButton *)btn{
    
    NSInteger section = btn.tag - 1000;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    HHOrderItemModel *orders_m = self.items_arr[section];
    
    NSString *status = model.status;
    if ([status isEqualToString:@"1"]) {
        //待付款--->去支付
        if ([model.order_mode isEqual:@16]) {
            //亲密付
            HHFamiliarityPayVC *vc = [HHFamiliarityPayVC new];
            vc.orderId = model.order_id;
            [self.navigationController pushVC:vc];
        }else{
            NSString *pid_str = [orders_m.pids componentsJoinedByString:@","];
            [self payOrderWithorderid:model.order_id btn:btn pid:pid_str];
        }
    }else if([status isEqualToString:@"3"]){
        //        //待收货--->确认收货
        [self handleOrderWithorderid:model.order_id status:HHhandle_type_Confirm btn:btn title:@"是否确认收货？"];
        
    }else if([status isEqualToString:@"5"]){
        //交易成功-->评价
        HHPostEvaluationVC *vc = [HHPostEvaluationVC new];
        HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
        HHOrderItemModel *itemModel = self.items_arr[section];
        vc.orderItem_m = itemModel;
        vc.orderId = model.order_id;
        
        [self.navigationController pushVC:vc];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) backColor:kWhiteColor];
    
    UIButton *button = [UIButton lh_buttonWithFrame:CGRectMake(8, 0, 40, 40) target:self action:nil image:[UIImage imageNamed:@"logo"] title:nil titleColor:kBlackColor font:FONT(13)];
    [headView addSubview:button];
    //
    CGSize storeName_size = [model.store_name lh_sizeWithFont:FONT(13)  constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    
    UILabel *storeName_label = [UILabel lh_labelWithFrame:CGRectMake(44, 0, storeName_size.width+10, 40) text:model.store_name textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [headView addSubview:storeName_label];
    
    UILabel *textLabel = [UILabel lh_labelWithFrame:CGRectMake(ScreenW-95, 0, 80, 40) text:model.status_name textColor:APP_COMMON_COLOR font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
    [headView addSubview:textLabel];
    
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HHOrderItemModel *orders_m = self.items_arr[section];
    return orders_m.items.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHOrderItemModel *orders_m = self.items_arr[indexPath.section];
    if (indexPath.row == orders_m.items.count) {
        return 44;
    }else{
        return 100;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    return model.footHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
#pragma mark-微信支付
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KWX_Pay_Fail_Notification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
}
- (void)wxPaySucesscount{
    
    HJUser *user = [HJUser sharedUser];
    HHPaySucessVC *vc = [HHPaySucessVC new];
    vc.pids = user.pids;
    [self.navigationController pushVC:vc];
    
}

- (void)wxPayFailcount {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showErrorWithStatus:@"支付失败～"];
        
    });
    
}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    return copy;
}
@end
