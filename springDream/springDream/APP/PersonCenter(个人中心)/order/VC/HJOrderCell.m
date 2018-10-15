
//
//  HJOrderCell.m
//  Mcb
//
//  Created by IMAC on 15/12/25.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJOrderCell.h"

@interface HJOrderCell ()
@property (strong, nonatomic) IBOutlet UIImageView *goodsIco;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *quantityLab;

@end

@implementation HJOrderCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIView *bgView = [UIView lh_viewWithFrame:CGRectMake(15, 5, ScreenW-10, 95) backColor:KVCBackGroundColor];
    [self.contentView insertSubview:bgView belowSubview:self.goodsIco];
    
    [self.goodsIco lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    [self.StandardLab lh_setCornerRadius:0 borderWidth:1 borderColor:KA0LabelColor];

}
- (void)setProductModel:(HHproducts_item_Model *)productModel{
    _productModel = productModel;

    [self.goodsIco sd_setImageWithURL:[NSURL URLWithString:productModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    NSString *product_item_act_name = productModel.product_item_act_name.length>0?[NSString stringWithFormat:@"【%@】",productModel.product_item_act_name]:@"";
    self.goodsNameLab.text = [NSString stringWithFormat:@"%@%@",productModel.prodcut_name,product_item_act_name];
    self.quantityLab.text = [NSString stringWithFormat:@"￥%.2f",productModel.product_item_price.floatValue];
    
    self.priceLab.text = [NSString stringWithFormat:@"x%@",productModel.product_item_quantity];
    self.sku_nameLab.text = [NSString stringWithFormat:@"%@",productModel.product_item_sku_name?productModel.product_item_sku_name:@""];
    

}
@end
