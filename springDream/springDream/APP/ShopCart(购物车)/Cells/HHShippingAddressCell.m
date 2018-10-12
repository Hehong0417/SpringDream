//
//  HHShippingAddressCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHShippingAddressCell.h"

@implementation HHShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.usernameLabel.font = FONT(16);
    self.mobileLabel.font = FONT(16);
    self.full_addressLabel.font = FONT(13);
    
}

- (void)setShippingAddressModel:(HHMineModel *)shippingAddressModel{
    
    _shippingAddressModel = shippingAddressModel;
    
    self.usernameLabel.text = shippingAddressModel.Recipient;
    self.mobileLabel.text = shippingAddressModel.Moble;
    self.full_addressLabel.text = shippingAddressModel.FullAddressOnly;

    
}
@end
