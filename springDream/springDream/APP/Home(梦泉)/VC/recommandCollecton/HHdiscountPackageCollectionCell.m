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
        
        self.imag_bgView = [UIView new];
        
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
        
//        [self addSubview:self.goodImageV];
//        [self addSubview:self.price_bottom_view];
        [self addSubview:self.priceLabel];
        
        //商品名
        self.p_nameLabel = [UILabel new];
        self.p_nameLabel.textColor = RGB(51, 51, 51);
        self.p_nameLabel.font = BoldFONT(14);
        self.p_nameLabel.textAlignment = NSTextAlignmentLeft;
        self.p_nameLabel.numberOfLines=2;
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
 
//        // 购物车图标
        self.cartImageV = [UIImageView new];
        self.cartImageV.image = [UIImage imageNamed:@"add_cart"];
        self.cartImageV.contentMode = UIViewContentModeScaleAspectFit;
//
        
        [self addSubview:self.imag_bgView];
        [self addSubview:self.p_nameLabel];
        
//        [self addSubview:self.p_skuLabel];
//        [self addSubview:self.prePriceLabel];
//        [self addSubview:self.cartImageV];

        
        [self setConstraint];
        
    }
    return self;
}
- (void)setConstraint{
    
    CGFloat imag_bg_w = (ScreenW-40)*105/263;
    self.imag_bgView.sd_layout
    .topSpaceToView(self, 8)
    .leftSpaceToView(self, 8)
    .bottomSpaceToView(self, 8)
    .widthIs(imag_bg_w);
    
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
    .leftSpaceToView(self.imag_bgView, 15)
    .topSpaceToView(self, 30)
    .autoHeightRatio(0)
    .widthIs(150);
    
    
    self.p_skuLabel.sd_layout
    .leftSpaceToView(self.imag_bgView, 15)
    .topSpaceToView(self.p_nameLabel, 1)
    .heightIs(20)
    .widthIs(150);
    
    self.priceLabel.sd_layout
    .leftSpaceToView(self.imag_bgView, 15)
    .topSpaceToView(self.p_nameLabel, 1)
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
- (void)setPackagesProducts_models:(NSArray<HHPackagesProductsModel *> *)PackagesProducts_models{
    
    _PackagesProducts_models = PackagesProducts_models;
//    [PackagesProducts_models enumerateObjectsUsingBlock:^(HHPackagesProductsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
    self.p_nameLabel.text = @"立体三色+大红色鳄鱼子气垫cc";
    //[self.goodImageV sd_setImageWithURL:[NSURL URLWithString:guess_you_likeModel.icon] placeholderImage:[UIImage imageNamed:@"loadImag_default100"]];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.sale_price.floatValue];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",guess_you_likeModel.sale_price.floatValue];
//    self.prePriceLabel.attributedText = [self.prePriceLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"原价：¥%.2f",guess_you_likeModel.market_price.floatValue] rangeStr:[NSString stringWithFormat:@"原价：¥%.2f",guess_you_likeModel.market_price.floatValue] color:KA0LabelColor];
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.PackagesProducts_models.count == 2) {
        CGFloat w = (self.imag_bgView.mj_w-24)/2;
        [self.PackagesProducts_models enumerateObjectsUsingBlock:^(HHPackagesProductsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(idx*(w+24), 0,w, w) image:nil];
            [imgV sd_setImageWithURL:[NSURL URLWithString:obj.Image]];
            [self.imag_bgView addSubview:imgV];
            imgV.centerY = self.imag_bgView.centerY;
        }];
        UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(w, 0, 24, 24) text:@"+" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self.imag_bgView addSubview:label];
        label.centerY = self.imag_bgView.centerY;

    }
    
    if (self.PackagesProducts_models.count == 3) {
        CGFloat w = 40;
        CGFloat h_padding = (self.imag_bgView.mj_w-24-2*w)/2;
        CGFloat v_padding = (self.imag_bgView.mj_h-2*w)/3;
        [self.PackagesProducts_models enumerateObjectsUsingBlock:^(HHPackagesProductsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                UIImageView *imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(h_padding, v_padding,w, w) image:nil];
                [imgV sd_setImageWithURL:[NSURL URLWithString:obj.Image]];
                [self.imag_bgView addSubview:imgV];
                imgV.centerX = self.imag_bgView.centerX;
            }else{
            NSInteger index = idx-1;
            UIImageView *imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(index*(w+24+h_padding)+(1-index)*h_padding,w+2*v_padding,w, w) image:nil];
            [imgV sd_setImageWithURL:[NSURL URLWithString:obj.Image]];
            [self.imag_bgView addSubview:imgV];
                if (index == 0) {
                    UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), imgV.mj_y, 24, 24) text:@"+" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
                    [self.imag_bgView addSubview:label];
                    label.centerY = imgV.centerY;

                }
            }
        }];
    }
    
    if (self.PackagesProducts_models.count == 4) {
        CGFloat w = (self.imag_bgView.mj_w-24)/2;
        CGFloat v_padding = (self.imag_bgView.mj_h-2*w)/3;
        [self.PackagesProducts_models enumerateObjectsUsingBlock:^(HHPackagesProductsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               NSInteger row = idx/2;
               NSInteger line = idx%2;
                UIImageView *imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(line*(w+24),row*(w+v_padding)+v_padding,w, w) image:nil];
                [imgV sd_setImageWithURL:[NSURL URLWithString:obj.Image]];
                [self.imag_bgView addSubview:imgV];
            if (idx == 0) {
                UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), imgV.mj_y, 24, 24) text:@"+" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
                label.centerY = imgV.centerY;
                [self.imag_bgView addSubview:label];
            }
            if (idx == 2) {
                UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), imgV.mj_y, 24, 24) text:@"+" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
                label.centerY = imgV.centerY;
                [self.imag_bgView addSubview:label];
            }
        }];
       
    }
    if (self.PackagesProducts_models.count == 5) {
        
        CGFloat w = (self.imag_bgView.mj_w-24*2)/3;
        CGFloat v_padding = (self.imag_bgView.mj_h-2*w)/3;
        
        [self.PackagesProducts_models enumerateObjectsUsingBlock:^(HHPackagesProductsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if (idx<2) {
                CGFloat x_padding = (self.imag_bgView.mj_w-24-2*w)/2;
                UIImageView *imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(idx*(w+24+x_padding)+(1-idx)*x_padding,v_padding,w, w) image:nil];
                [imgV sd_setImageWithURL:[NSURL URLWithString:obj.Image]];
                [self.imag_bgView addSubview:imgV];
                if (idx == 0) {
                    UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), imgV.mj_y, 24, 24) text:@"+" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
                    label.centerY = imgV.centerY;
                    [self.imag_bgView addSubview:label];
                }
            }else{
                NSInteger index = idx-2;
                UIImageView *imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(index*(w+24),2*v_padding+w,w, w) image:nil];
                [imgV sd_setImageWithURL:[NSURL URLWithString:obj.Image]];
                [self.imag_bgView addSubview:imgV];
                if (index == 0||index == 1) {
                    UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), imgV.mj_y, 24, 24) text:@"+" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
                    label.centerY = imgV.centerY;
                    [self.imag_bgView addSubview:label];
                }
            }

        }];
        
    }
}

@end
