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
@property (weak, nonatomic) IBOutlet UIImageView *bg_imagV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderleft_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponwidth_constant;
@property (weak, nonatomic) IBOutlet UILabel *money_valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *failureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic,strong) HHMineModel *model;

@property(nonatomic,strong) HHMineModel *get_model;


@end
