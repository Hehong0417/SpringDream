//
//  HHAddCartTool.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAddCartTool.h"
#import "HHShoppingVC.h"

@implementation HHAddCartTool

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
//        [self addSubview:self.cartIconBg];
        [self addSubview:self.collectBtn];
        [self addSubview:self.cartIconBtn];

//        UIView *line = [UIView lh_viewWithFrame:CGRectMake(self.cartIconImgV.mj_x, 0, 1, self.homeIconImgV.mj_h) backColor:RGB(220, 220, 220)];
//        [self.cartIconBg addSubview:line];
        
        [self addSubview:self.addCartBtn];

        [self addSubview:self.buyBtn];


    }
    
    return self;
    
}

- (void)addCartBtnAction{
    
    if (self.addCartBlock) {
        self.addCartBlock();
    }
}
- (void)buyCartBtnAction:(UIButton *)btn{
    if (self.buyBlock) {
        self.buyBlock(btn);
    }
}
- (void)collectAction:(UIButton *)button{
    button.selected = !button.selected;
    
}
- (void)cartIconBtnAction{
    HHShoppingVC *shop_vc = [HHShoppingVC new];
    shop_vc.cartType = HHcartType_goodDetail;
    [self.nav pushVC:shop_vc];
}
//购物车图标底图
- (UIView *)cartIconBg{
    
    if (!_cartIconBg) {
        
        _cartIconBg = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 50) backColor:kWhiteColor];
        
    }
    return _cartIconBg;
}
//收藏图标
- (UIButton *)collectBtn {
    
    if (!_collectBtn) {
        
        _collectBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3/2, 50) target:self action:@selector(collectAction:) image:[UIImage imageNamed:@"collect_01"] title:@"" titleColor:kWhiteColor font:FONT(15)];
        [_collectBtn setImage:[UIImage imageNamed:@"collect_02"] forState:UIControlStateSelected];
        [_collectBtn setBackgroundColor:kWhiteColor];
    }
    return _collectBtn;
    
}
//购物车图标
- (UIButton *)cartIconBtn {
  
    if (!_cartIconBtn) {
        
        _cartIconBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3/2, 0, SCREEN_WIDTH/3/2, 50) target:self action:@selector(cartIconBtnAction) image:[UIImage imageNamed:@"add_cart_pdetail"] title:@"" titleColor:kWhiteColor font:FONT(15)];
        [_cartIconBtn setBackgroundColor:kWhiteColor];

    }
    return _cartIconBtn;
    
}
- (UIButton *)addCartBtn{
    
    if (!_addCartBtn) {
        
        _addCartBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 50) target:self action:@selector(addCartBtnAction) image:nil title:@"加入购物车" titleColor:kWhiteColor font:FONT(15)];
        [_addCartBtn setBackgroundColor:kGrayColor];
    }
    return _addCartBtn;
    
}
- (UIButton *)buyBtn{
    
    if (!_buyBtn) {
        
        _buyBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50) target:self action:@selector(buyCartBtnAction:) image:nil title:@"立即付款" titleColor:kWhiteColor font:FONT(15)];
//        [_buyBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 75, 5, 10)];
//        [_buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 40)];
//        [_buyBtn setImage:[UIImage imageNamed:@"triangle2"] forState:UIControlStateSelected];
//        [_buyBtn setImage:[UIImage imageNamed:@"triangle1"] forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:APP_COMMON_COLOR];

    }
    return _buyBtn;
    
}

@end
