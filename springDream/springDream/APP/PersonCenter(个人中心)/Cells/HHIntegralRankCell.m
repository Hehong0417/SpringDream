//
//  HHIntegralRankCell.m
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHIntegralRankCell.h"

@implementation HHIntegralRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.icon lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
}
- (void)setIntegral_model:(HHMineModel *)integral_model{
    
    _integral_model = integral_model;
    self.userName.text = integral_model.UserName;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:integral_model.UserImage]];
    self.integral_label.text = [NSString stringWithFormat:@"%.2f",integral_model.Ponits.floatValue];
    
}
@end
