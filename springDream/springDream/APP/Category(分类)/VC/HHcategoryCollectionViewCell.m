//
//  HHcategoryCollectionViewCell.m
//  springDream
//
//  Created by User on 2018/10/10.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHcategoryCollectionViewCell.h"

@implementation HHcategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.goodImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    self.product_nameLabel.font = BoldFONT(13);
    self.product_s_intergralLabel.font = FONT(10);
    self.product_min_priceLabel.font = SemiboldFONT(15);
    
}

- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    self.product_nameLabel.text = goodsModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.product_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.product_user_price.doubleValue];
    
    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价: ¥%.2f",goodsModel.product_market_price.doubleValue] rangeStr:[NSString stringWithFormat:@"原价: ¥%.2f",goodsModel.product_market_price.doubleValue] color:KA0LabelColor];
    
}

@end
