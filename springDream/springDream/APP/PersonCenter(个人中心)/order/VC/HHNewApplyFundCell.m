//
//  HHNewApplyFundCell.m
//  springDream
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHNewApplyFundCell.h"

@implementation HHNewApplyFundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.plus_btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(plus_btn:) image:[UIImage imageNamed:@""]];
    self.num_text.rightViewMode = UITextFieldViewModeAlways;
    self.num_text.rightView = self.plus_btn;
    
    self.minus_btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(minus_btn:) image:[UIImage imageNamed:@""]];
    self.num_text.leftViewMode = UITextFieldViewModeAlways;
    self.num_text.leftView =  self.minus_btn;
    self.num_text.delegate = self;

}
- (void)setItem_model:(HHproducts_item_Model *)item_model{
    
    _item_model = item_model;
    
    [self.icn_url_imgV sd_setImageWithURL:[NSURL URLWithString:item_model.icon]];
    self.product_name_label.text = item_model.prodcut_name;
    self.sku_label.text = item_model.product_item_sku_name;
    self.price_label.text = [NSString stringWithFormat:@"¥%@",item_model.product_item_price];
    self.num_text.text = item_model.product_item_quantity;
    
    if (self.num_text.text.integerValue==1) {
        self.minus_btn.enabled = NO;
    }
    if (self.num_text.text.integerValue == item_model.product_item_quantity.integerValue) {
        self.plus_btn.enabled = NO;
    }
}
- (void)plus_btn:(UIButton *)btn{
    
    if (self.num_text.text.integerValue == self.item_model.product_item_quantity.integerValue-1) {
        btn.enabled = NO;
    }
    self.minus_btn.enabled = YES;
    NSInteger num_ = self.num_text.text.integerValue;
    self.num_text.text = [NSString stringWithFormat:@"%ld",++num_];

}
- (void)minus_btn:(UIButton *)btn{
    
    NSInteger num_ = self.num_text.text.integerValue;
    self.num_text.text = [NSString stringWithFormat:@"%ld",--num_];
    if (self.num_text.text.integerValue==1) {
        btn.enabled = NO;
    }
    self.plus_btn.enabled = YES;

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return NO;
}
@end
