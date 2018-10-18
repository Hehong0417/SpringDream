//
//  HHWithdrawCell.m
//  springDream
//
//  Created by User on 2018/10/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWithdrawCell.h"

@implementation HHWithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.withdrawLabel.font = FONT(16);
    self.moneyTag.font = FONT(16);
    self.moneyTextField.font = FONT(16);
    self.allMoneyBtn.titleLabel.font = FONT(14);
    
}


@end
