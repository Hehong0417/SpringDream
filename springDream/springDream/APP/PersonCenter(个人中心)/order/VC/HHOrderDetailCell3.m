//
//  HHOrderDetailCell3.m
//  springDream
//
//  Created by User on 2018/8/24.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderDetailCell3.h"

@implementation HHOrderDetailCell3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        
        [self.contentView addSubview:self.order_code_label];
        [self.contentView addSubview:self.pay_code_label];
        [self.contentView addSubview:self.create_time_label];
        [self.contentView addSubview:self.deal_time_label];
        [self.contentView addSubview:self.copy_btn];

    }
    
    return self;
    
}
- (UIButton *)copy_btn{
    if (!_copy_btn) {
        _copy_btn = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW-80, 10, 69, 25) target:self action:@selector(copyBtnAction) title:@"复制" titleColor:KTitleLabelColor font:FONT(12) backgroundColor:kWhiteColor];
        [_copy_btn lh_setCornerRadius:1 borderWidth:1 borderColor:KTitleLabelColor];
    }
    return _copy_btn;
    
}
- (UILabel *)order_code_label{
    
    if (!_order_code_label) {
        _order_code_label = [UILabel lh_labelWithFrame:CGRectMake(10, 5, 250, 25) text:@"" textColor:KTitleLabelColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    }
    return _order_code_label;
}
- (UILabel *)pay_code_label{
    
    if (!_pay_code_label) {
        _pay_code_label = [UILabel lh_labelWithFrame:CGRectMake(10, CGRectGetMaxY(self.order_code_label.frame)+5, ScreenW-30, 25) text:@"" textColor:KTitleLabelColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    }
    return _pay_code_label;
}
- (UILabel *)create_time_label{
    
    if (!_create_time_label) {
        _create_time_label = [UILabel lh_labelWithFrame:CGRectMake(10, CGRectGetMaxY(self.pay_code_label.frame), 250, 25) text:@"" textColor:KTitleLabelColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    }
    return _create_time_label;
}
- (UILabel *)deal_time_label{
    
    if (!_deal_time_label) {
        _deal_time_label = [UILabel lh_labelWithFrame:CGRectMake(10, CGRectGetMaxY(self.create_time_label.frame), 250, 25) text:@"" textColor:KTitleLabelColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    }
    return _deal_time_label;
}
- (void)setModel:(HHCartModel *)model{
    
    _model = model;
    self.order_code_label.text = [NSString stringWithFormat:@"订单编号：%@",model.orderid?model.orderid:@""];
    self.pay_code_label.text = [NSString stringWithFormat:@"支付宝交易号：%@",model.payDate?model.payDate:@""];
    self.create_time_label.text = [NSString stringWithFormat:@"创建时间：%@",model.orderDate?model.orderDate:@""];
    self.deal_time_label.text = [NSString stringWithFormat:@"成交时间：%@",model.payDate?model.payDate:@""];

    
}
- (void)copyBtnAction{
    
    
    
    
}
@end
