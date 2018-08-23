//
//  HXHomeCollectionCell.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HXHomeCollectionCell.h"

@implementation HXHomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.goodImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    self.product_nameLabel.font = FONT(12);
    self.product_s_intergralLabel.font = FONT(10);
    
}
- (void)setProductsModel:(HHhomeProductsModel *)productsModel{
    _productsModel = productsModel;
    
    self.product_nameLabel.text = productsModel.product_name;
    
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.product_icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",productsModel.product_min_price];
    self.product_s_intergralLabel.attributedText =  [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价：¥%@",productsModel.product_s_intergral] rangeStr:[NSString stringWithFormat:@"原价：¥%@",productsModel.product_s_intergral] color:KA0LabelColor];

}
- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    self.product_nameLabel.text = goodsModel.ProductName;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImageUrl1] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.MinShowPrice];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价：¥%@",goodsModel.MarketPrice] rangeStr:[NSString stringWithFormat:@"原价：¥%@",goodsModel.MarketPrice] color:KA0LabelColor];
    
   
}
- (void)setGuess_you_likeModel:(HHGuess_you_likeModel *)guess_you_likeModel{
    
    _guess_you_likeModel = guess_you_likeModel;
    
    self.product_min_priceLabel.textColor = kBlackColor;

    self.product_nameLabel.text = guess_you_likeModel.name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:guess_you_likeModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",guess_you_likeModel.sale_price];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%@",guess_you_likeModel.market_price] rangeStr:[NSString stringWithFormat:@"¥%@",guess_you_likeModel.market_price] color:KA0LabelColor];
    
}

@end
