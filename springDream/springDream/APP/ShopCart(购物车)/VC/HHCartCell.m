//
//  HHCartCell.m
//  Store
//
//  Created by User on 2017/12/29.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHCartCell.h"

@implementation HHCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self.plusBtn lh_setCornerRadius:0 borderWidth:1 borderColor:KA0LabelColor];
//     [self.minusBtn lh_setCornerRadius:0 borderWidth:1 borderColor:KA0LabelColor];
//    [self.plusBtn setTitleColor:APP_model_Color forState:UIControlStateNormal];
//    [self.minusBtn setTitleColor:APP_model_Color forState:UIControlStateNormal];
    
    [self.chooseBtn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
     [self.chooseBtn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
    
    [self.store_tag_label lh_setCornerRadius:0 borderWidth:1 borderColor:KVCBackGroundColor];
}
- (IBAction)chooseBtnAction:(UIButton *)sender {
    
    sender.selected = ! sender.selected;
 
    if (self.ChooseBtnSelectAction) {

        self.ChooseBtnSelectAction(self.indexPath,sender.selected);
    }
}

- (void)setProductModel:(HHproductsModel *)productModel{
    
    _productModel = productModel;
    
    [self.product_iconLabel sd_setImageWithURL:[NSURL URLWithString:productModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_nameLabel.text = productModel.name;
    self.product_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",productModel.price.floatValue];
    self.quantityTextField.text = productModel.quantity;
    self.sku_nameLabel.text = productModel.skuName;
    
}
- (void)setPModel:(HHproductsModel *)pModel{
    
    _pModel = pModel;
    
    [self.product_iconLabel sd_setImageWithURL:[NSURL URLWithString:pModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_nameLabel.text = pModel.prodcut_name;
    self.product_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",pModel.price.floatValue];
    self.sku_nameLabel.text = pModel.sku_name;
    
}
- (void)setLeftSelected:(BOOL)leftSelected {
    _leftSelected = leftSelected;
    self.chooseBtn.selected = leftSelected;
}
- (void)layoutSubviews{
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor=RGB(221, 221, 221);
            for (UIButton *btn in subView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    [btn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateNormal];
                 }
            }
        }
    }
}
@end
