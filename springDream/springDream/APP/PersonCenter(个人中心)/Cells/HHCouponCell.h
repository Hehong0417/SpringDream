//
//  HHCouponCell.h
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHgooodDetailModel.h"

@interface HHCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UILabel *money_valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bg_imagV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_constant;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTimeLabel_topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataTimeLabel_w;

@property(nonatomic,strong) HHMineModel *model;

@property(nonatomic,strong) MeetActivityModel *activity_model;

@end
