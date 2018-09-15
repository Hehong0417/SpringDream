//
//  HHOrderDetailVC.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderDetailVC.h"
#import "HHSubmitOrderCell.h"
#import "HHOrderDetailCellOne.h"
#import "HHOrderDetailHead.h"
#import "HHOrderDetailCell3.h"

@interface HHOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   UILabel *title_label;
@property (nonatomic, strong)   UILabel *state_label;
@property (nonatomic, strong)   NSMutableArray *datas;

@end

@implementation HHOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT - 44 ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderDetailCellOne" bundle:nil] forCellReuseIdentifier:@"HHOrderDetailCellOne"];
    [self.tableView registerClass:[HHOrderDetailCell3 class] forCellReuseIdentifier:@"HHOrderDetailCell3"];

    
//    20w   2 + 10 + 4
    //添加头部
    [self addTableHeader];
    
    //获取数据
    [self getDatas];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetOrderDetailWithorderid:self.orderid] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
        
                    self.model = [HHCartModel mj_objectWithKeyValues:api.Data];
//                    orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.model.orderid];
//                    createdateLabel.text = [NSString stringWithFormat:@"下单时间：%@",self.model.orderDate];
                    self.state_label.text = self.model.statusName;
                  [self.model.prodcuts enumerateObjectsUsingBlock:^(HHproductsModel *  product_model, NSUInteger idx, BOOL * _Nonnull stop) {
                    [product_model.skuid  enumerateObjectsUsingBlock:^(HHskuidModel *  sku_model, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        HHproductsModel *model = [HHproductsModel new];
                        model.icon = product_model.icon;
                        model.pname = product_model.pname;
                        model.price = sku_model.Price;
                        model.quantity = sku_model.Quantity;
                        model.sku_name = sku_model.Value;
                        [self.datas addObject:model];
                        
                    }];
                    
                }];
                    [self.tableView reloadData];
                
                    
            }else{

                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];

        }
    }];
    
}
- (void)addTableHeader{
    
    UIView *tableHead = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    //店铺名称
    UIButton *button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 220, 50 ) target:self action:nil image:[UIImage imageNamed:@"logo"] title:@" MOON CHERRY 梦泉时尚" titleColor:kBlackColor font:FONT(13)];
    [tableHead addSubview:button];

    //订单状态
    self.state_label = [UILabel lh_labelWithFrame:CGRectMake(ScreenW-100, 0, 90, 50) text:@"" textColor:APP_COMMON_COLOR font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
    [tableHead addSubview:self.state_label];
    
    self.tableView.tableHeaderView = tableHead;
}
- (void)addPayBtn{
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, ScreenH - 50-Status_HEIGHT-44, SCREEN_WIDTH, 50) backColor:kWhiteColor];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-140, 10, 60, 30) target:self action:@selector(oneAction:) title:@"取消" titleColor:APP_COMMON_COLOR font:FONT(16) backgroundColor:kWhiteColor];
    [oneBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:oneBtn];
    
    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 30) target:self action:@selector(twoAction:) title:@"去支付" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_COMMON_COLOR];
    [twoBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];
    
    [self.view addSubview:footView];
    
}
- (void)oneAction:(UIButton *)btn{
    
    
}
- (void)twoAction:(UIButton *)btn{
    
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    if (indexPath.section == 0) {
        
        HHOrderDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderDetailCellOne"];
        cell.addressModel = self.model;
        gridCell = cell;
        
    }else if (indexPath.section == 1){
        
        HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
        cell.productsModel =  self.datas[indexPath.row];
        gridCell = cell;
        
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.textColor = KTitleLabelColor;
        cell.textLabel.font = FONT(12);
        cell.detailTextLabel.font = FONT(12);
        if (indexPath.row == 0) {
            cell.textLabel.text = @"商品数量";
            cell.detailTextLabel.text = @"1";
            
        }else  if (indexPath.row == 1){
            cell.textLabel.text = @"原价";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",self.model.payTotal?self.model.payTotal.floatValue:0.00];

        }else if (indexPath.row == 2){
            cell.textLabel.text = @"优惠价";
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.model.payTotal?self.model.payTotal:@""];
        }else{
            cell.textLabel.text = @"商品运费";
          NSString *detailText;
            if ([self.model.freight isEqualToString:@"0"]) {
                detailText  = @"包邮";
            }else{
                detailText  = self.model.freight;
            }
            cell.detailTextLabel.text = detailText;

        }
        gridCell = cell;
    }else if (indexPath.section == 3){
        HHOrderDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderDetailCell3"];
        cell.model = self.model;
        gridCell = cell;
    }
    
    gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
    gridCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    return gridCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return 1;
    }else if (section == 1)
   {
     return self.datas.count;
    } else if (section == 2){
        return 4;
    }else if (section == 3){
        
        return 1;
    }
    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 80;
    }else  if(indexPath.section == 1){
        return 100;
    }else  if(indexPath.section == 2){
        return 25;
    }else{
        return 120;
    }
    return 0.01;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
//    headView.backgroundColor = kWhiteColor;
//    HHOrderDetailHead *head = [[[NSBundle mainBundle] loadNibNamed:@"HHOrderDetailHead" owner:self options:nil] lastObject];
//    if (section == 0) {
//        head.iconImageV.image = [UIImage imageNamed:@"icon_address_default"];
//        head.titleLabel.text = @"收货信息";
//    }else if (section == 1){
//        head.iconImageV.image = [UIImage imageNamed:@"icon_mark_default"];
//        head.titleLabel.text = @"商品信息";
//    }else{
//        head.iconImageV.image = [UIImage imageNamed:@""];
//        head.titleLabel.text = @"";
//    }
//    [headView addSubview:head];
//    return headView;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    headView.backgroundColor = kWhiteColor;
    if (section == 1) {
        UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW-20, 50) text:[NSString stringWithFormat:@"共%ld件商品 合计:¥%.2f",self.datas.count,self.model.payTotal.floatValue] textColor:KTitleLabelColor font:FONT(13) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
        [headView addSubview:label];
        return headView;
    }
    if (section == 2) {
        
        UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(15, 0, 80, 50) text:@"合计" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [headView addSubview:label];
        UILabel *label2 = [UILabel lh_labelWithFrame:CGRectMake(ScreenW-120, 0, 100, 50) text:[NSString stringWithFormat:@"¥%.2f",self.model.payTotal.floatValue] textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
        [headView addSubview:label2];
        return headView;

    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }if (section == 2) {
        return 50;
    }else{
      return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 5;
}

@end
