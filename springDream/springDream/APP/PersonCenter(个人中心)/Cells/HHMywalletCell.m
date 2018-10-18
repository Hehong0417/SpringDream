//
//  HHMywalletCell.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMywalletCell.h"

@implementation HHMywalletCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.left_title_label.text = @"购物";
    self.left_detail_label.text = @"单据：234567890456456745";
    self.date_time_label.text = @"2018-02-19 10:00";
    self.integral_label.text = @"积分：-23";
    
}
- (void)setCommission_model:(HHMineModel *)commission_model{
    _commission_model = commission_model;
    self.left_title_label.font = FONT(12);
    self.left_detail_label.font = FONT(12);
    self.date_time_label.font = FONT(12);
    self.integral_label.font = FONT(12);
    self.left_title_label.textColor = kDarkGrayColor;
    self.left_detail_label.textColor = kDarkGrayColor;
    self.date_time_label.textColor = kDarkGrayColor;
    self.integral_label.textColor = kDarkGrayColor;
    
    self.left_title_label.text = [NSString stringWithFormat:@"订单号:%@",commission_model.OrderInfo_Id];
    self.left_detail_label.text = [NSString stringWithFormat:@"收益时间:%@",commission_model.TradeTime];
    self.date_time_label.text = [NSString stringWithFormat:@"+%@",commission_model.CommTotal];
    self.integral_label.text = [NSString stringWithFormat:@"%.2f",commission_model.UserCommission.doubleValue];


}
- (void)setDelegate_commission_model:(HHMineModel *)delegate_commission_model{
    _delegate_commission_model = delegate_commission_model;
    
    self.left_title_label.font = FONT(12);
    self.left_detail_label.font = FONT(12);
    self.date_time_label.font = FONT(12);
    self.integral_label.font = FONT(12);
    self.left_title_label.textColor = kDarkGrayColor;
    self.left_detail_label.textColor = kDarkGrayColor;
    self.date_time_label.textColor = kDarkGrayColor;
    self.integral_label.textColor = kDarkGrayColor;
    
    self.left_title_label.text = [NSString stringWithFormat:@"订单号:%@",delegate_commission_model.oid];
    self.left_detail_label.text = [NSString stringWithFormat:@"收益时间:%@",delegate_commission_model.time];
    self.date_time_label.text = [NSString stringWithFormat:@"%@",delegate_commission_model.bonus_value];
    self.integral_label.text = [NSString stringWithFormat:@"%.2f",delegate_commission_model.bonus_result.doubleValue];
}
- (void)setStore_commission_model:(HHMineModel *)store_commission_model{
    _store_commission_model = store_commission_model;
    
    self.left_title_label.font = FONT(16);
    self.left_detail_label.font = FONT(10);
    self.date_time_label.font = FONT(12);
    self.integral_label.font = FONT(12);
    self.left_title_label.textColor = kDarkGrayColor;
    self.left_detail_label.textColor = kDarkGrayColor;
    self.date_time_label.textColor = kDarkGrayColor;
    self.integral_label.textColor = kDarkGrayColor;
    
    self.left_title_label.text = [NSString stringWithFormat:@"%@",store_commission_model.product_name];
    self.left_detail_label.text = [NSString stringWithFormat:@"订单号:%@",store_commission_model.order_id];
    self.date_time_label.text = [NSString stringWithFormat:@"%@",store_commission_model.order_date];
    self.integral_label.text = [NSString stringWithFormat:@"规格:%@",store_commission_model.product_sku_name];
    
}
- (void)setIntegral_model:(HHMineModel *)integral_model{
    
    _integral_model = integral_model;
    self.left_title_label.font = FONT(16);
    self.left_detail_label.font = FONT(10);
    self.date_time_label.font = FONT(12);
    self.integral_label.font = FONT(12);
    self.left_title_label.textColor = kDarkGrayColor;
    self.left_detail_label.textColor = kDarkGrayColor;
    self.date_time_label.textColor = kDarkGrayColor;
    self.integral_label.textColor = kDarkGrayColor;
    
    self.left_title_label.text = [NSString stringWithFormat:@"%@",integral_model.integraType];
    self.left_detail_label.text = [NSString stringWithFormat:@"单据:%@",integral_model.oid.length>0?integral_model.oid:@"无"];
    self.date_time_label.text = [NSString stringWithFormat:@"%@",integral_model.datetime];
    self.integral_label.text = [NSString stringWithFormat:@"积分:%.2f",integral_model.integra.doubleValue];
}
- (void)setWallet_model:(HHMineModel *)wallet_model{
    _wallet_model = wallet_model;
    
    self.left_title_label.font = FONT(14);
    self.left_detail_label.font = FONT(12);
    self.date_time_label.font = FONT(14);
    self.integral_label.font = FONT(10);
    self.left_title_label.textColor = kDarkGrayColor;
    self.left_detail_label.textColor = kDarkGrayColor;
    self.date_time_label.textColor = kDarkGrayColor;
    self.integral_label.textColor = kDarkGrayColor;
    
    self.left_title_label.text = [NSString stringWithFormat:@"%@",wallet_model.Remarks];
    self.left_detail_label.text = [NSString stringWithFormat:@"订单号:%@",wallet_model.oid.length>0?wallet_model.oid:@"无"];
    self.date_time_label.text = [NSString stringWithFormat:@"%@",wallet_model.ChangeMoney];
    self.integral_label.text = [NSString stringWithFormat:@"%@",wallet_model.CreateDate];
}
@end
