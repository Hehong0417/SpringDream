//
//  HHdiscountPackageTabCell.m
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageCollectionCell.h"

@implementation HHdiscountPackageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.goodImageV = [UIImageView new];
        self.goodImageV.image = [UIImage imageNamed:@"icon0"];
        self.goodImageV.contentMode = UIViewContentModeScaleAspectFit;
        
        self.priceLabel = [UILabel new];
        self.priceLabel.textColor = APP_COMMON_COLOR;
        self.priceLabel.font = BoldFONT(14);
        self.priceLabel.textAlignment = NSTextAlignmentLeft;

//        self.price_bottom_view = [UIView new];
//        self.price_bottom_view.backgroundColor = kWhiteColor;
//        self.price_bottom_view.alpha = 0;
        
        [self addSubview:self.goodImageV];
//        [self addSubview:self.price_bottom_view];
        [self addSubview:self.priceLabel];
        
        //商品名
        self.p_nameLabel = [UILabel new];
        self.p_nameLabel.textColor = RGB(51, 51, 51);
        self.p_nameLabel.font = BoldFONT(14);
        self.p_nameLabel.textAlignment = NSTextAlignmentLeft;
        //属性名
        self.p_skuLabel = [UILabel new];
        self.p_skuLabel.textColor = RGB(153, 153, 153);
        self.p_skuLabel.font = MediumFONT(11);
        self.p_skuLabel.textAlignment = NSTextAlignmentLeft;

        //原价
        self.prePriceLabel = [UILabel new];
        self.prePriceLabel.textColor = RGB(153, 153, 153);
        self.prePriceLabel.font = MediumFONT(11);
        self.prePriceLabel.textAlignment = NSTextAlignmentLeft;
 
        // 购物车图标
        self.cartImageV = [UIImageView new];
        self.cartImageV.image = [UIImage imageNamed:@"add_cart"];
        self.cartImageV.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.p_nameLabel];
        [self addSubview:self.p_skuLabel];
        [self addSubview:self.prePriceLabel];
        [self addSubview:self.goodImageV];
        [self addSubview:self.cartImageV];

        
        [self setConstraint];
        
    }
    return self;
}
- (void)setConstraint{
    
    self.goodImageV.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 30)
    .bottomSpaceToView(self, 30)
    .widthEqualToHeight();
    
//    self.price_bottom_view.sd_layout
//    .leftSpaceToView(self, 0)
//    .rightSpaceToView(self, 0)
//    .bottomSpaceToView(self, 0)
//    .heightIs(20);
    
    self.p_nameLabel.sd_layout
    .leftSpaceToView(self.goodImageV, 15)
    .topSpaceToView(self, 30)
    .heightIs(25)
    .widthIs(150);
    
    self.p_skuLabel.sd_layout
    .leftSpaceToView(self.goodImageV, 15)
    .topSpaceToView(self.p_nameLabel, 1)
    .heightIs(20)
    .widthIs(150);
    
    self.priceLabel.sd_layout
    .leftSpaceToView(self.goodImageV, 15)
    .topSpaceToView(self.p_skuLabel, 1)
    .heightIs(20);
    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    
    self.prePriceLabel.sd_layout
    .leftSpaceToView(self.priceLabel, 10)
    .topSpaceToView(self.p_skuLabel, 1)
    .heightIs(20)
    .maxWidthIs(100);
    
    self.cartImageV.sd_layout
    .rightSpaceToView(self, 30)
    .centerYEqualToView(self)
    .heightIs(50)
    .widthIs(50);
    
}
- (void)setGuess_you_likeModel:(HHGuess_you_likeModel *)guess_you_likeModel{
    
    _guess_you_likeModel = guess_you_likeModel;
    self.p_nameLabel.text = guess_you_likeModel.name;
//    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:guess_you_likeModel.icon] placeholderImage:[UIImage imageNamed:@"loadImag_default100"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.sale_price.floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.sale_price.floatValue];
    self.prePriceLabel.attributedText = [self.prePriceLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价：¥%.2f",guess_you_likeModel.market_price.floatValue] rangeStr:[NSString stringWithFormat:@"原价：¥%.2f",guess_you_likeModel.market_price.floatValue] color:KA0LabelColor];

}

@end
