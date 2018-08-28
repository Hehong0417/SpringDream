//
//  HHOrderDetailCell3.h
//  springDream
//
//  Created by User on 2018/8/24.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHOrderDetailCell3 : UITableViewCell

@property (nonatomic, strong) UILabel *order_code_label;
@property (nonatomic, strong) UILabel *pay_code_label;
@property (nonatomic, strong) UILabel *create_time_label;
@property (nonatomic, strong) UILabel *deal_time_label;
@property (nonatomic, strong) UIButton *copy_btn;

@property (nonatomic, strong)   HHCartModel *model;

@end
