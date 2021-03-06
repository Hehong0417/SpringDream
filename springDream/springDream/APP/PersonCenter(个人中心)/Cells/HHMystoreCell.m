//
//  HHMystoreCell.m
//  springDream
//
//  Created by User on 2018/9/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMystoreCell.h"

@implementation HHMystoreCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.store_icon lh_setCornerRadius:0 borderWidth:1 borderColor:KVCBackGroundColor];
}
- (void)setStore_model:(HHMineModel *)store_model{
    
    _store_model = store_model;
    [self.store_icon sd_setImageWithURL:[NSURL URLWithString:store_model.store_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.store_name_label.text = store_model.store_name;
    self.store_address_label.text = store_model.store_address;
    self.call_label.text = store_model.store_phone;

}
@end
