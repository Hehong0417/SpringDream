
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
    self.goodsNameLab.font = FONT(14);
    self.sku_nameLab.font = FONT(13);
    self.quantityLab.font = FONT(14);


}
- (void)setProductModel:(HHproducts_item_Model *)productModel{
    _productModel = productModel;

    [self.goodsIco sd_setImageWithURL:[NSURL URLWithString:productModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    NSString *product_item_act_name = productModel.product_item_act_name.length>0?[NSString stringWithFormat:@"【%@】",productModel.product_item_act_name]:@"";
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",product_item_act_name,productModel.prodcut_name];
    self.goodsNameLab.attributedText = [NSString lh_attriStrWithprotocolStr:product_item_act_name content:contentStr protocolStrColor:APP_COMMON_COLOR contentColor:kBlackColor commonFont:FONT(14)];
    self.quantityLab.text = [NSString stringWithFormat:@"￥%.2f",productModel.product_item_price.doubleValue];
    
    self.priceLab.text = [NSString stringWithFormat:@"x%@",productModel.product_item_quantity];
    self.sku_nameLab.text = [NSString stringWithFormat:@"%@",productModel.product_item_sku_name?productModel.product_item_sku_name:@""];
    

}
@end
