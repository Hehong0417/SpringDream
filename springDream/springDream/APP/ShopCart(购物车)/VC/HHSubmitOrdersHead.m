//
//  HHSubmitOrdersHead.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrdersHead.h"

@implementation HHSubmitOrdersHead

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIImageView *bg_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, 100) image:[UIImage imageNamed:@"addr_bg"]];
    [self insertSubview:bg_imagV atIndex:0];
}

- (void)setAddressModel:(HHCartModel *)addressModel{
    _addressModel = addressModel;
   
    self.usernameLabel.text = [NSString stringWithFormat:@"%@    %@",addressModel.userName,addressModel.mobile];
    self.full_addressLabel.text = [NSString stringWithFormat:@"%@",addressModel.fullAddress];
}
- (void)setModel:(HHMineModel *)model{
    
    _model = model;
    self.usernameLabel.text = [NSString stringWithFormat:@"%@    %@",model.Recipient,model.Moble];
    self.full_addressLabel.text = [NSString stringWithFormat:@"%@",model.FullAddressOnly];
}
@end
