//
//  HHdiscountPackageTabCell.h
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHdiscountPackageCollectionCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *goodImageV;
@property(strong,nonatomic) UILabel *priceLabel;
@property(strong,nonatomic) UIView *price_bottom_view;
//商品名
@property(strong,nonatomic) UILabel *p_nameLabel;
//属性名
@property(strong,nonatomic) UILabel *p_skuLabel;
//原价
@property(strong,nonatomic) UILabel *prePriceLabel;
// 购物车图标
@property(strong,nonatomic) UIImageView *cartImageV;

@property(nonatomic,strong) HHGuess_you_likeModel *guess_you_likeModel;

@end
