
//
//  HHSubmitOrderCell.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrderCell.h"

@implementation HHSubmitOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *bgView = [UIView lh_viewWithFrame:CGRectMake(10, 10, ScreenW-10, 90) backColor:KVCBackGroundColor];
    [self.contentView insertSubview:bgView belowSubview:self.iconImageV];
}
- (void)setProductsModel:(HHproductsModel *)productsModel{
    _productsModel = productsModel;
    
    NSString *product_item_act_name = productsModel.product_item_act_name.length>0?[NSString stringWithFormat:@"【%@】",productsModel.product_item_act_name]:@"";
    self.namelabel.text = [NSString stringWithFormat:@"%@%@",productsModel.pname,product_item_act_name];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",productsModel.price.doubleValue];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@",productsModel.quantity];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.sku_nameLabel.text = productsModel.skuName;

}
- (void)setOrderProductsModel:(HHproductsModel *)orderProductsModel{
    _orderProductsModel = orderProductsModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",orderProductsModel.price.doubleValue];
    self.namelabel.text = [NSString stringWithFormat:@"%@",orderProductsModel.prodcut_name];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@",orderProductsModel.quantity];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:orderProductsModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.sku_nameLabel.text = orderProductsModel.sku_name;

}



@end
