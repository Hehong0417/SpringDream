//
//  HHMywalletCell.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMywalletCell.h"

@implementation HHMywalletCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.left_title_label.text = @"购物";
    self.left_detail_label.text = @"单据：234567890456456745";
    self.date_time_label.text = @"2018-02-19 10:00";
    self.integral_label.text = @"积分：-23";

    
}


@end
