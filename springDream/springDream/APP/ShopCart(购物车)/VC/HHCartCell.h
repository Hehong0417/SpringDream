//
//  HHCartCell.h
//  Store
//
//  Created by User on 2017/12/29.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCartModel.h"

typedef void(^ChooseBtnSelectAction)(NSIndexPath *indexPath,BOOL leftButtonSelected);

@interface HHCartCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic)  UIButton *minusBtn;
@property (strong, nonatomic)  UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *product_iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sku_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (weak, nonatomic) IBOutlet UILabel *store_tag_label;


@property (nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic,strong) HHproductsModel *productModel;
@property(nonatomic,strong) HHproductsModel *pModel;

@property (nonatomic, copy) ChooseBtnSelectAction ChooseBtnSelectAction;
@property (nonatomic, assign) BOOL leftSelected;

@end
