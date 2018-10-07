//
//  HHDistributionCommissionHead.h
//  springDream
//
//  Created by User on 2018/9/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHDistributionCommissionHead : UIView
@property (weak, nonatomic) IBOutlet UILabel *commission_title_label;
@property (weak, nonatomic) IBOutlet UILabel *commission_price_label;
@property (weak, nonatomic) IBOutlet UIButton *commission_balance_button;
@property (weak, nonatomic) IBOutlet UILabel *yestoday_commission_label;
@property (weak, nonatomic) IBOutlet UILabel *history_commission_label;

@property (weak, nonatomic) IBOutlet UILabel *commissionDetail_label;
@property (weak, nonatomic) IBOutlet UIView *commission_bg_view;
@property (weak, nonatomic) IBOutlet UIView *commission_detail_bgView;


@property (nonatomic, strong) UIViewController *vc;

@end
