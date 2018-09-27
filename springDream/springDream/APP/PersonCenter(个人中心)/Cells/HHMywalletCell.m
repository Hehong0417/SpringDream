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
    self.integral_label.text = [NSString stringWithFormat:@"%.2f",commission_model.UserCommission.floatValue];


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
    self.integral_label.text = [NSString stringWithFormat:@"%.2f",delegate_commission_model.bonus_result.floatValue];
}
@end
