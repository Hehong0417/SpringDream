//
//  HHNewApplyFundCell.h
//  springDream
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHNewApplyFundCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icn_url_imgV;
@property (weak, nonatomic) IBOutlet UILabel *product_name_label;
@property (weak, nonatomic) IBOutlet UILabel *sku_label;
@property (weak, nonatomic) IBOutlet UILabel *price_label;
@property (weak, nonatomic) IBOutlet UITextField *num_text;

@property (nonatomic, strong) NSString *title_str;
@property (nonatomic, strong) NSString *order_id;

@property (nonatomic, strong) UIButton *plus_btn;
@property (nonatomic, strong) UIButton *minus_btn;

@property (nonatomic, strong) HHproducts_item_Model *item_model;

@end
