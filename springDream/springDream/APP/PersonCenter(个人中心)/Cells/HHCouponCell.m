//
//  HHCouponCell.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponCell.h"

@implementation HHCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.left_constant.constant = ScreenW*127/375;
    self.top_constant.constant =  ScreenH*29/667;
    self.width_constant.constant = ScreenW* 80/375;
    self.height_constant.constant = ScreenH* 60/667;
    self.money_valueLabel.font = FONT(45);
    
    self.dateTimeLabel.font = FONT(10);
    self.dateTimeLabel_topConstant.constant = ScreenH*40/667;
    self.dataTimeLabel_w.constant = ScreenW* 67/375;
}
- (void)setModel:(HHMineModel *)model{

    _model = model;
    
    self.money_valueLabel.text = model.CouponValue;
    
    NSString *StartTime = nil;
    if (model.StartTime.length>10) {
        StartTime = [model.StartTime substringToIndex:10];
    }else{
        StartTime = model.StartTime;
    }
    NSString *EndTime = nil;
    if (model.EndTime.length>10) {
        EndTime = [model.EndTime substringToIndex:10];
    }else{
        EndTime = model.EndTime;
    }
    self.dateTimeLabel.text = [NSString stringWithFormat:@"使用期限:%@至%@",StartTime,EndTime];
}

- (void)setActivity_model:(MeetActivityModel *)activity_model{
    
    _activity_model = activity_model;
    
    
}

@end
