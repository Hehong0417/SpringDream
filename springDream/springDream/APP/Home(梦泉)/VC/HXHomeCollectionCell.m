//
//  HXHomeCollectionCell.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HXHomeCollectionCell.h"

@implementation HXHomeCollectionCell
{
    UILabel *_tag_label;
}
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
    
    NSString *text = @"分享赚10元 自购省10元";
    CGFloat width = [text lh_sizeWithFont:FONT(10) constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    _tag_label = [UILabel lh_labelWithFrame:CGRectMake(20, 207, width, 10) text:text textColor:APP_NAV_COLOR font:FONT(10) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [self.contentView addSubview:_tag_label];
    
}
- (void)setProductsModel:(HHhomeProductsModel *)productsModel{
    _productsModel = productsModel;
    _tag_label.hidden = YES;
    self.product_nameLabel.text = productsModel.product_name;
    
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.product_icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",productsModel.product_min_price.doubleValue];
    self.product_s_intergralLabel.attributedText =  [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价: ¥%.2f",productsModel.product_s_intergral.doubleValue] rangeStr:[NSString stringWithFormat:@"原价: ¥%.2f",productsModel.product_s_intergral.doubleValue] color:KA0LabelColor];

}
- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    _tag_label.hidden = YES;
    self.product_nameLabel.text = goodsModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.product_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.product_activity_price.doubleValue];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价: ¥%.2f",goodsModel.product_market_price.doubleValue] rangeStr:[NSString stringWithFormat:@"原价: ¥%.2f",goodsModel.product_market_price.doubleValue] color:KA0LabelColor];
    if ([goodsModel.product_is_collection isEqual:@1]) {
        self.collectButton.selected = YES;
    }else{
        self.collectButton.selected = NO;
    }
   
}
- (void)setCollectModel:(HHCategoryModel *)collectModel{
    
    _collectModel = collectModel;
    _tag_label.hidden = YES;

    self.product_nameLabel.text = collectModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:collectModel.product_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",collectModel.product_cost_price?collectModel.product_cost_price.doubleValue:0.00];
    
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
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.sale_price?guess_you_likeModel.sale_price.doubleValue:0.00];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.market_price?guess_you_likeModel.market_price.doubleValue:0.00] rangeStr:[NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.market_price?guess_you_likeModel.market_price.doubleValue:0.00] color:KA0LabelColor];
    
}
- (IBAction)collectButton:(UIButton *)sender {
    
    if (sender.selected == YES) {
        //取消收藏
        NSString *pids =nil;
        if (self.goodsModel.Id) {
            pids = self.goodsModel.Id;
        }else if (self.goodsModel.Id) {
            pids = self.collectModel.product_id;
        }else{
            pids = self.goodsModel.product_id;
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
        NSString *pids =nil;
        if (self.goodsModel.Id) {
            pids = self.goodsModel.Id;
        }else if(self.collectModel.product_id){
            pids = self.collectModel.product_id;
        }else{
            pids = self.goodsModel.product_id;
        }
        [[[HHHomeAPI postAddProductCollectionWithpids:pids] netWorkClient] postRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
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
