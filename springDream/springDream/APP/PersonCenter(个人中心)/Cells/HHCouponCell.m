//
//  HHCouponCell.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponCell.h"

@implementation HHCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.couponwidth_constant.constant = ScreenW*110/375;
    self.orderleft_constant.constant = ScreenW*33/375;
    self.money_valueLabel.font = FONT(24);
    
    self.effectTimeLabel.font = FONT(13);
    self.failureTimeLabel.font = FONT(13);
    self.valueLabel.font = FONT(13);

}
- (void)setModel:(HHMineModel *)model{

    _model = model;
    self.money_valueLabel.attributedText = [NSString lh_attriStrWithprotocolStr:@"¥" content:[NSString stringWithFormat:@"¥%@",model.CouponValue] protocolFont:FONT(14) contentFont:FONT(24) comonColor:kWhiteColor];
    self.nameLabel.text = model.CouponsName;
    self.effectTimeLabel.text = [NSString stringWithFormat:@"生效时间：%@",model.StartTime];
    self.failureTimeLabel.text = [NSString stringWithFormat:@"到期时间：%@",model.EndTime];
    self.valueLabel.text = [NSString stringWithFormat:@"满%@减%@",model.ConditionValue,model.CouponValue];
}
- (void)setGet_model:(HHMineModel *)get_model{
    
    _get_model = get_model;
    self.money_valueLabel.attributedText = [NSString lh_attriStrWithprotocolStr:@"¥" content:[NSString stringWithFormat:@"¥%@",get_model.value] protocolFont:FONT(14) contentFont:FONT(24) comonColor:kWhiteColor];
    self.nameLabel.text = get_model.Name;
    self.effectTimeLabel.text = [NSString stringWithFormat:@"生效时间：%@",get_model.begin_time];
    self.failureTimeLabel.text = [NSString stringWithFormat:@"到期时间：%@",get_model.end_time];
    self.valueLabel.text = @"不限订单金额";
}
@end
