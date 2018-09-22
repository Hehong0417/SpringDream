
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
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",productsModel.price];
    self.namelabel.text = [NSString stringWithFormat:@"%@",productsModel.pname];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@",productsModel.quantity];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.sku_nameLabel.text = productsModel.skuName;

}
- (void)setOrderProductsModel:(HHproductsModel *)orderProductsModel{
    _orderProductsModel = orderProductsModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderProductsModel.price];
    self.namelabel.text = [NSString stringWithFormat:@"%@",orderProductsModel.prodcut_name];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@",orderProductsModel.quantity];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:orderProductsModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.sku_nameLabel.text = orderProductsModel.sku_name;

}



@end
