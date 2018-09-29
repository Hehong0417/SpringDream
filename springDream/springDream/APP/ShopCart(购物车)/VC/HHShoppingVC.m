//
//  CartVC.m
//  Store
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHShoppingVC.h"
#import "HHCartCell.h"
#import "HHCartFootView.h"
#import "HHSubmitOrdersVC.h"
//#import "HHGoodBaseViewController.h"
#import "HHtEditCarItem.h"
#import "HHGoodListVC.h"
#import "HHAddAdressVC.h"
#import "HHSelectSectionItem.h"

@interface HHShoppingVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger  count;
    NSInteger  subcount;
    UILabel *tipLabel;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHCartFootView *settleAccountView;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSString *money_total;
@property (nonatomic, strong)   NSString *s_integral_total;
@property (nonatomic, strong)   NSMutableArray *selectItems;
@property (nonatomic, strong)   UIButton *manage_btn;
@end
@implementation HHShoppingVC

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.manage_btn.selected = YES;
    [self manageAction:self.manage_btn];
    //是否登录
    [self isLoginOrNot];
    
    //获取数据
    [self getDatas];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    self.title = @"购物车";
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    //返回按钮
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 30, 45) target:self action:@selector(backBtnAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    //tableView

    CGFloat tableHeight;
    if (self.cartType == HHcartType_goodDetail) {
        tableHeight = SCREEN_HEIGHT-Status_HEIGHT-44;
        backBtn.hidden = NO;
        
    }else{
        tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44 - 50;
        backBtn.hidden = YES;

    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHCartCell" bundle:nil] forCellReuseIdentifier:@"HHCartCell"];
    
//    //顶部提示条
//    [self addTipHeadView];

    //底部结算条
    [self addSettleAccountView];
    
    [self addHeadRefresh];
    
    self.manage_btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 60, 60) target:self action:@selector(manageAction:) title:@"管理" titleColor:kWhiteColor font:FONT(14) backgroundColor:kClearColor];
    [self.manage_btn setTitle:@"完成" forState:UIControlStateSelected];
    [self.manage_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:self.manage_btn];

}
- (void)manageAction:(UIButton *)manage_btn{
    
   manage_btn.selected  = !manage_btn.selected;
    
    if (manage_btn.selected == YES) {
        //完成---移入收藏夹、删除已选
        self.settleAccountView.sendGift_label.hidden = NO;
        self.settleAccountView.money_totalLabel.hidden = YES;
        NSMutableArray *select_idx_arr = [self getNewSelect_arr];
        self.settleAccountView.sendGift_label.text = select_idx_arr.count>0?[NSString stringWithFormat:@"移入收藏夹(%ld)",select_idx_arr.count]:@"移入收藏夹";
        self.settleAccountView.settleBtn.text = select_idx_arr.count>0?[NSString stringWithFormat:@"删除已选(%ld)",select_idx_arr.count]:@"删除已选";
    }else{
      //管理---去结算
        
        self.settleAccountView.sendGift_label.hidden = YES;
        self.settleAccountView.money_totalLabel.hidden = NO;
        self.settleAccountView.settleBtn.text = @"去结算";

    }
    
}
- (void)backBtnAction{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cartVCBackActionHandle)]) {
        
        [self.delegate cartVCBackActionHandle];
    }
    
    [self.navigationController popVC];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"cart_none"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{

  return [[NSAttributedString alloc] initWithString:@"购物车为空～" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//    return [[NSAttributedString alloc] initWithString:@"再忙也要犒劳下自己" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
//
//}
//
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{

    return [[NSAttributedString alloc] initWithString:@"逛一逛" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:kWhiteColor}];

}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -130, 0.0, -130);

    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:20 size:CGSizeMake(ScreenW-240, 35)];

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
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{

//    HHGoodListVC *vc = [HHGoodListVC new];
//    vc.type = nil;
//    vc.categoryId = nil;
//    vc.name = nil;
//    vc.orderby = nil;
//    [self.navigationController pushVC:vc];

}
#pragma mark - 刷新控件

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    
}

- (void)isLoginOrNot{
    //
    
//    HJUser *user = [HJUser sharedUser];
//    if (user.token.length == 0) {
//        //判断是否登录
//        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
//        vc.tabBarVC = self.tabBarController;
//        vc.tabSelectIndex = 2;
//        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//    }else{
//        //获取数据
//        [self getDatas];
//    }
}
//获取数据
- (void)getDatas{
    
    [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {

        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if (!error) {
            if (api.State == 1) {
                
                self.model  =  [HHCartModel mj_objectWithKeyValues:api.Data];
                
//                if ([self.model.sendGift isEqual:@1]) {
//                    self.settleAccountView.sendGift_label.hidden = NO;
//                    self.settleAccountView.sendGift_widthConstant.constant = 80;
//                }else{
//                    self.settleAccountView.sendGift_label.hidden = YES;
//                    self.settleAccountView.sendGift_widthConstant.constant = 0;
//                }
                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥0.00"];

//                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥%.2f",self.model.total?self.model.total.floatValue:0.00];

                [self getShopCartListFinsih:self.model];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{

            [SVProgressHUD showInfoWithStatus:api.Msg];
        }

    }];
    
}
- (void)getShopCartListFinsih:(HHCartModel *)data {
    
    if (data.stores.count ==0) {
        tipLabel.hidden = YES;
        if (self.cartType == HHcartType_goodDetail) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-Status_HEIGHT-44);
        }else{
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-49-Status_HEIGHT-44);
        }
        self.settleAccountView.hidden = YES;
    }else{
        self.settleAccountView.hidden = NO;
        tipLabel.hidden = NO;

        if (self.cartType == HHcartType_goodDetail) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-50-Status_HEIGHT-44);
        }else{
           self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-49-50-Status_HEIGHT-44);
        }
    }
    self.settleAccountView.selectBtn.selected = NO;
    
    //全选左边点击数据源
    self.selectItems = [NSMutableArray array];
    [self.model.stores enumerateObjectsUsingBlock:^(HHstoreModel *storeModel, NSUInteger idx, BOOL *stop) {
        HHSelectSectionItem *sectionItem = [HHSelectSectionItem new];
        NSMutableArray *section_items = [NSMutableArray array];
        [storeModel.products enumerateObjectsUsingBlock:^(HHproductsModel * productModel, NSUInteger twoIdx, BOOL * _Nonnull stop) {
            HHSelectRowItem *item = [HHSelectRowItem new];
            item.row_selected = @0;
            [section_items addObject:item];
            *stop = NO;

        }];
        sectionItem.selectRow_Arr = section_items;
        [self.selectItems addObject:sectionItem];
        *stop = NO;
    }];

    //新增
    [self.tableView reloadData];
}
- (void)addTipHeadView{
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    tipLabel.font = FONT(13);
    tipLabel.text = @"提示：请尽快提交订单，避免现有商品售完无法下单！";
    tipLabel.backgroundColor = kWhiteColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = tipLabel;
    
}
- (void)addSettleAccountView{
    
    self.settleAccountView  = [[[NSBundle mainBundle] loadNibNamed:@"HHCartFootView" owner:self options:nil] lastObject];
//    self.settleAccountView.hidden = YES;
//    self.settleAccountView.sendGift_label.hidden = YES;
//    self.settleAccountView.sendGift_widthConstant.constant = 0;
    CGFloat settleView_y;
    if (self.cartType == HHcartType_goodDetail) {
        settleView_y = SCREEN_HEIGHT- 49-Status_HEIGHT -44;
    }else{
        settleView_y = SCREEN_HEIGHT-49-50-Status_HEIGHT-44;
    }
    UIView *settleView = [[UIView alloc] initWithFrame:CGRectMake(0, settleView_y, SCREEN_WIDTH, 50)];
    self.settleAccountView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.settleAccountView.settleBtn.userInteractionEnabled = YES;

    [settleView addSubview:self.settleAccountView];
    [self.view addSubview:settleView];
    
    self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥0.00"];

    
    //全选
    WEAK_SELF();
    self.settleAccountView.allChooseBlock = ^(NSNumber *allSelected) {
        [weakSelf caculateSettleGoodsListBaseLeftSelectArrIsAllSelected:allSelected.boolValue];
        
    };
    
  
    //提交订单&删除已选
    [self.settleAccountView.settleBtn setTapActionWithBlock:^{
        
        //获取已选数组
        NSMutableArray *select_idx_arr = [self getNewSelect_ids];
        
        if (self.manage_btn.selected == YES) {
            //删除已选 select_idx_arr(cart_ids)
            NSString *cartIds = [select_idx_arr componentsJoinedByString:@","];
            [self deleteGetDataWithCartIds:cartIds];
            
        }else{
            //去结算
            if (select_idx_arr.count>0) {
                
                //判断是否存在高管商品和其他商品
                NSMutableArray *selectGroupNameItems = [self getSelectGroupNameItems];
                
                if ([selectGroupNameItems containsObject:@1]&&[selectGroupNameItems containsObject:@0]) {
                    
                    [SVProgressHUD showInfoWithStatus:@"高管订货商品不能和普通商品一起结算！"];
                }else{
                    [self isExitAddressWithSendGift:@0];
                }
                
            }else{
                
                [self lh_showHudInView:self.view labText:@"您还没有选择宝贝哦"];
            }
        }
        
    }];
    
    //送礼/移入收藏夹
    self.settleAccountView.sendGift_label.userInteractionEnabled = YES;
    [self.settleAccountView.sendGift_label setTapActionWithBlock:^{
        //获取已选数组id
        NSMutableArray *select_ids = [self getNewSelect_arr];
        
        // [self isExitAddressWithSendGift:@1];
        if (self.manage_btn.selected == YES) {
            //移入收藏夹
            NSString *pid_str = [select_ids componentsJoinedByString:@","];
            
        if (pid_str.length>0) {

            [[[HHHomeAPI postAddProductCollectionWithpids:pid_str] netWorkClient] postRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
                if (!error) {
                    if (api.State == 1) {
                        
                        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                        [SVProgressHUD showSuccessWithStatus:api.Msg];
                        [self getDatas];
                    }else{
                        [SVProgressHUD setMinimumDismissTimeInterval:1.5];

                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }else{
                    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                }
            }];
            
        }else{
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            
            [SVProgressHUD showInfoWithStatus:@"请先选择商品～"];
           }
        }
        
    }];
    
}
//是否存在收货地址
- (void)isExitAddressWithSendGift:(NSNumber *)sendGiftBtnSelected{
    
    [[[HHCartAPI IsExistOrderAddress] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                if ([api.Data isEqual:@1]) {

                    HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                    NSMutableArray *select_ids = [self getNewSelect_ids];
                    vc.cartIds = [select_ids componentsJoinedByString:@","];

                    if ([self.model.sendGift isEqual:@1]) {
                        if ([sendGiftBtnSelected isEqual:@1]) {
                            vc.enter_type = HHaddress_type_Spell_group;
                            vc.sendGift = self.model.sendGift;
                            vc.mode = @8;
                        }else{
                            vc.mode = nil;
                            vc.enter_type = HHaddress_type_add_cart;
                        }
                    }else{
                        vc.mode = nil;
                        vc.enter_type = HHaddress_type_add_cart;
                    }
                    [self.navigationController pushVC:vc];
                }else{
                    HHAddAdressVC *vc = [HHAddAdressVC new];
                    vc.addressType = HHAddress_settlementType_cart;
                    if ([self.model.sendGift isEqual:@1]) {
                        if ([sendGiftBtnSelected isEqual:@1]) {
                          vc.mode = @8;
                          vc.sendGift = self.model.sendGift;
                        }else{
                          vc.mode = nil;
                        }
                    }else{
                          vc.mode = nil;
                    }
                    vc.titleStr = @"新增收货地址";
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
//加
- (void)plusBtnAction:(UIButton *)btn{
    
    HHCartCell *cell = (HHCartCell *)btn.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.model.stores[indexPath.section].products[indexPath.row];
    if (model.quantity.integerValue>1) {
        UIButton *minusBtn = (UIButton *)cell.quantityTextField.leftView;
        minusBtn.enabled = YES;
    }
    NSInteger  quantity = model.quantity.integerValue;
    quantity++;
    
    [self minusQuantityWithcart_id:model.cartid quantity:@"1"  cartCell:cell];

}
//减
- (void)minusBtnAction:(UIButton *)btn{

     HHCartCell *cell = (HHCartCell *)btn.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.model.stores[indexPath.section].products[indexPath.row];
    if (model.quantity.integerValue<=1) {
        btn.enabled = NO;
    }else{
        
        NSInteger   quantity = model.quantity.integerValue;
        quantity--;
        [self minusQuantityWithcart_id:model.cartid quantity:@"-1"  cartCell:cell];
      
    }
}
- (void)plusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity cartCell:(HHCartCell *)cartCell{
   
    [[[HHCartAPI postAddQuantityWithcart_id:cart_id quantity:quantity] netWorkClient] postRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self refreshData];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
}
- (void)minusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity cartCell:(HHCartCell *)cartCell{
    
    [[[HHCartAPI postminusQuantityWithcart_id:cart_id quantity:quantity] netWorkClient] postRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self refreshData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}

- (void)refreshData{
    
    [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                [self.datas removeAllObjects];
                self.model  =  [HHCartModel mj_objectWithKeyValues:api.Data];
                self.datas = [self.model.products mutableCopy];
                HHtEditCarItem *editCarItem  = [HHtEditCarItem shopCartGoodsList:self.model.stores selectionArr:self.selectItems];
//                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
                self.settleAccountView.selectBtn.selected = editCarItem.settleAllSelect;
//                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥%@",self.model.total?self.model.total:@"0.00"];
                __block BOOL isSelect = NO;
                [self.selectItems enumerateObjectsUsingBlock:^(HHSelectSectionItem *secItem, NSUInteger idx, BOOL * _Nonnull stop) {
                    [secItem.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (rowItem.row_selected.boolValue == YES) {
                            isSelect = YES;
                            *stop = YES;
                        }
                    }];
                }];
                if (isSelect == YES) {
                    self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
                }else{
                    self.settleAccountView.money_totalLabel.text =  @"合计¥0.00";
                }
                [self.tableView reloadData];
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
#pragma mark - 全选
- (void)caculateSettleGoodsListBaseLeftSelectArrIsAllSelected:(BOOL )allSelect{
    
    [self.selectItems removeAllObjects];
    
    [self.model.stores enumerateObjectsUsingBlock:^(HHstoreModel *storeModel, NSUInteger idx, BOOL *stop) {
        HHSelectSectionItem *sectionItem = [HHSelectSectionItem new];
        NSMutableArray *section_items = [NSMutableArray array];
        [storeModel.products enumerateObjectsUsingBlock:^(HHproductsModel * productModel, NSUInteger twoIdx, BOOL * _Nonnull stop) {
            HHSelectRowItem *item = [HHSelectRowItem new];
            item.row_selected = @(allSelect);
            [section_items addObject:item];
            *stop = NO;
            
        }];
        sectionItem.selectRow_Arr = section_items;
        [self.selectItems addObject:sectionItem];
        *stop = NO;
    }];

    [self caculateSettleGoodsListBaseLeftSelectArr];
    
}
- (void)caculateSettleGoodsListBaseLeftSelectArr {
    
    HHtEditCarItem *editCarItem = [HHtEditCarItem shopCartGoodsList:self.model.stores selectionArr:self.selectItems];
    self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
    
    if (self.manage_btn.selected == YES) {
        self.settleAccountView.sendGift_label.text = self.selectItems.count>0?[NSString stringWithFormat:@"移入收藏夹(%ld)",self.selectItems.count]:@"移入收藏夹";
        self.settleAccountView.settleBtn.text = self.selectItems.count>0?[NSString stringWithFormat:@"删除已选(%ld)",self.selectItems.count]:@"删除已选";
    }
    
    [self.tableView reloadData];
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCartCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HHproductsModel *model = self.model.stores[indexPath.section].products[indexPath.row];
    cell.productModel = model;
    UIButton *plusBtn = (UIButton *)cell.quantityTextField.rightView;
    [plusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *minusBtn = (UIButton *)cell.quantityTextField.leftView;
    [minusBtn addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (model.quantity.integerValue <= 1) {
        minusBtn.enabled = NO;
    }else{
        minusBtn.enabled = YES;
    }
    cell.indexPath = indexPath;
    
    HHSelectSectionItem *sectin_selectItem = self.selectItems[indexPath.section];
    HHSelectRowItem *row_selectItem = sectin_selectItem.selectRow_Arr[indexPath.row];
    cell.leftSelected = row_selectItem.row_selected.boolValue;
    WEAK_SELF();
    cell.ChooseBtnSelectAction = ^(NSIndexPath *inPath, BOOL chooseBtnSelected) {
        
        HHSelectSectionItem *section_Item = weakSelf.selectItems[indexPath.section];
        
        HHSelectSectionItem  *new_section_Item = [HHSelectSectionItem new];
        NSMutableArray *new_selectRow_Arr = [NSMutableArray array];
        [section_Item.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger idx, BOOL * _Nonnull stop) {
            HHSelectRowItem *new_rowItem = [HHSelectRowItem new];
            if (idx == inPath.row) {
                new_rowItem.row_selected = @(chooseBtnSelected);
                [new_selectRow_Arr addObject:new_rowItem];
            }else{
                new_rowItem.row_selected = rowItem.row_selected;
                [new_selectRow_Arr addObject:new_rowItem];
            }
        }];
        new_section_Item.selectRow_Arr = new_selectRow_Arr;
        [self.selectItems replaceObjectAtIndex:indexPath.section withObject:new_section_Item];

        HHtEditCarItem *editCarItem  = [HHtEditCarItem shopCartGoodsList:weakSelf.model.stores selectionArr:weakSelf.selectItems];
        self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"合计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
        self.settleAccountView.selectBtn.selected = editCarItem.settleAllSelect;

        //
        if (self.manage_btn.selected == YES) {
            //获取已选数组
            NSMutableArray *select_idx_arr = [self getNewSelect_arr];
            self.settleAccountView.sendGift_label.text = select_idx_arr.count>0?[NSString stringWithFormat:@"移入收藏夹(%ld)",select_idx_arr.count]:@"移入收藏夹";
            self.settleAccountView.settleBtn.text = select_idx_arr.count>0?[NSString stringWithFormat:@"删除已选(%ld)",select_idx_arr.count]:@"删除已选";
        }
    };
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.model.stores.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HHstoreModel *model = self.model.stores[section];
    return model.products.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    HHproductsModel *model = self.model.products[indexPath.section];
//
//    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
//    vc.Id = model.pid;
//    [self.navigationController pushVC:vc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHstoreModel *model = self.model.stores[section];
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) backColor:KVCBackGroundColor];
    //店铺名称
    UIButton *button = [UIButton lh_buttonWithFrame:CGRectMake(8, 0, 40, 40) target:self action:nil image:[UIImage imageNamed:@"logo"] title:nil titleColor:kBlackColor font:FONT(13)];
    [headView addSubview:button];
//
    CGSize storeName_size = [model.storeName lh_sizeWithFont:FONT(13)  constrainedToSize:CGSizeMake(MAXFLOAT, 20)];

    UILabel *storeName_label = [UILabel lh_labelWithFrame:CGRectMake(52, 0, storeName_size.width+10, 40) text:model.storeName textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [headView addSubview:storeName_label];

    if (model.groupName.length>0) {
        CGSize mode_size = [model.groupName lh_sizeWithFont:FONT(13)  constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        UILabel *activityLabel = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(storeName_label.frame)+5, 0,mode_size.width+10, 20) text:model.groupName textColor:APP_NAV_COLOR font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        activityLabel.centerY = headView.centerY;
        [activityLabel lh_setCornerRadius:5 borderWidth:1 borderColor:APP_NAV_COLOR];
        [headView addSubview:activityLabel];
    }
    return headView;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HHproductsModel *model = self.model.stores[indexPath.section].products[indexPath.row];
        
        [self deleteGetDataWithCartIds:model.cartid];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";

}
//pid 数组
- (NSMutableArray *)getNewSelect_arr{
    
    NSMutableArray *select_idx_arr = [NSMutableArray array];
    
    [self.model.stores enumerateObjectsUsingBlock :^(HHstoreModel  *storeModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [storeModel.products enumerateObjectsUsingBlock:^(HHproductsModel * productModel, NSUInteger idx1, BOOL * _Nonnull stop) {
            
            [self.selectItems enumerateObjectsUsingBlock:^( HHSelectSectionItem *secItem, NSUInteger oneIdx, BOOL * _Nonnull stop) {
                [secItem.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger twoIdx, BOOL * _Nonnull stop) {
                    if ([rowItem.row_selected isEqual:@1]) {
                        if ((oneIdx == idx)&&(twoIdx == idx1)) {
                            [select_idx_arr addObject:productModel.pid];
                        }
                    }
                    
                }];
            }];
            
        }];
        
    }];
    
    return select_idx_arr;
}
//cartid数组
- (NSMutableArray *)getNewSelect_ids{
    
    NSMutableArray *select_ids_arr = [NSMutableArray array];

    [self.model.stores enumerateObjectsUsingBlock :^(HHstoreModel  *storeModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [storeModel.products enumerateObjectsUsingBlock:^(HHproductsModel * productModel, NSUInteger idx1, BOOL * _Nonnull stop) {
            
            [self.selectItems enumerateObjectsUsingBlock:^( HHSelectSectionItem *secItem, NSUInteger oneIdx, BOOL * _Nonnull stop) {
                [secItem.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger twoIdx, BOOL * _Nonnull stop) {
                    if ([rowItem.row_selected isEqual:@1]) {
                        if ((oneIdx == idx)&&(twoIdx == idx1)) {
                            [select_ids_arr addObject:productModel.cartid];
                        }
                    }
                    
                }];
            }];
            
        }];
        
    }];
    
    return select_ids_arr;
}
- (NSMutableArray *)getSelectGroupNameItems{
    
    NSMutableArray *selectGroupNameItems = [NSMutableArray array];
    
    [self.model.stores enumerateObjectsUsingBlock :^(HHstoreModel  *storeModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [storeModel.products enumerateObjectsUsingBlock:^(HHproductsModel * productModel, NSUInteger idx1, BOOL * _Nonnull stop) {
            
            [self.selectItems enumerateObjectsUsingBlock:^( HHSelectSectionItem *secItem, NSUInteger oneIdx, BOOL * _Nonnull stop) {
                [secItem.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger twoIdx, BOOL * _Nonnull stop) {
                    if ([rowItem.row_selected isEqual:@1]) {
                        if ((oneIdx == idx)&&(twoIdx == idx1)) {
                            if ([storeModel.groupName containsString:@"高管订货区"]) {
                                [selectGroupNameItems addObject:@1];
                            }else{
                                [selectGroupNameItems addObject:@0];
                            }
                        }
                    }
                    
                }];
            }];
        }];
        
    }];
    
    return selectGroupNameItems;
}
#pragma mark - 删除购物车

- (void)deleteGetDataWithCartIds:(NSString *)cartIds{
    
    [[[HHCartAPI postShopCartDeleteWithcart_id:cartIds] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                [self getDatas];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}

@end
