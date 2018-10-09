//
//  HHBankListCell.m
//  springDream
//
//  Created by User on 2018/10/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBankListCell.h"

@implementation HHBankListCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.contentView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(10, 10, 10, 10));
    
    [self.contentView lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    self.contentView.backgroundColor = kWhiteColor;
    self.backgroundColor = KVCBackGroundColor;
}

- (void)setModel:(HHMineModel *)model{
    _model = model;
    
    self.bank_name_label.text = model.BankName;
    self.bank_numer_label.text = model.BankAccountNo;
    
}

@end
