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
    self.product_nameLabel.font = BoldFONT(12);
    self.product_s_intergralLabel.font = FONT(10);
    self.product_min_priceLabel.font = SemiboldFONT(14);
    [self.collectButton setImage:[UIImage imageNamed:@"tip_03"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"tip_02"] forState:UIControlStateSelected];
    
    [self.goodImageV lh_setCornerRadius:0 borderWidth:1 borderColor:KVCBackGroundColor];
}
- (void)setProductsModel:(HHhomeProductsModel *)productsModel{
    _productsModel = productsModel;
    
    self.product_nameLabel.text = productsModel.product_name;
    
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.product_icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",productsModel.product_min_price.floatValue];
    self.product_s_intergralLabel.attributedText =  [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价: ¥%.2f",productsModel.product_s_intergral.floatValue] rangeStr:[NSString stringWithFormat:@"原价: ¥%.2f",productsModel.product_s_intergral.floatValue] color:KA0LabelColor];

}
- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    self.product_nameLabel.text = goodsModel.ProductName;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImageUrl1] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.MinShowPrice.floatValue];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价: ¥%.2f",goodsModel.MarketPrice.floatValue] rangeStr:[NSString stringWithFormat:@"原价: ¥%.2f",goodsModel.MarketPrice.floatValue] color:KA0LabelColor];
    if ([goodsModel.IsCollection isEqual:@1]) {
        self.collectButton.selected = YES;
    }else{
        self.collectButton.selected = NO;
    }
   
}
- (void)setCollectModel:(HHCategoryModel *)collectModel{
    
    _collectModel = collectModel;
    self.product_nameLabel.text = collectModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:collectModel.product_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",collectModel.product_cost_price?collectModel.product_cost_price.floatValue:0.00];
    
    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价: ¥%@",collectModel.product_market_price?collectModel.product_market_price:@"0"] rangeStr:[NSString stringWithFormat:@"原价: ¥%@",collectModel.product_market_price?collectModel.product_market_price:@"0"] color:KA0LabelColor];
        self.collectButton.selected = YES;
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
}
- (void)setGuess_you_likeModel:(HHGuess_you_likeModel *)guess_you_likeModel{
    
    _guess_you_likeModel = guess_you_likeModel;
    
    self.product_min_priceLabel.textColor = kBlackColor;

    self.product_nameLabel.text = guess_you_likeModel.name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:guess_you_likeModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.sale_price?guess_you_likeModel.sale_price.floatValue:0.00];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.market_price?guess_you_likeModel.market_price.floatValue:0.00] rangeStr:[NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.market_price?guess_you_likeModel.market_price.floatValue:0.00] color:KA0LabelColor];
    
}
- (IBAction)collectButton:(UIButton *)sender {
    
    if (sender.selected == YES) {
        //取消收藏
        NSString *pids =nil;
        if (self.goodsModel.Id) {
            pids = self.goodsModel.Id;
        }else{
            pids = self.collectModel.product_id;
        }
        [[[HHHomeAPI postDeleteProductCollectionWithpids:pids] netWorkClient] postRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    sender.selected = NO;
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showSuccessWithStatus:api.Msg];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(collectHandleComplete)]&&self.collectModel.product_id) {
                        [self.delegate collectHandleComplete];
                    }
                }else{
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
    }else{
        //添加收藏
        [[[HHHomeAPI postAddProductCollectionWithpids:self.goodsModel.Id] netWorkClient] postRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    
                    sender.selected = YES;
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showSuccessWithStatus:api.Msg];
                    
                }else{
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];

                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
    }
}

@end
