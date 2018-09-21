//
//  HHSeckillCustomView.h
//  springDream
//
//  Created by User on 2018/9/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZCountDownView.h"
#import "HHActivityModel.h"

@interface HHSeckillCustomView : UIView

@property (nonatomic, strong)  UILabel *price_label;
@property (nonatomic, strong)  UILabel *pre_price_label;
@property (nonatomic, strong)  UILabel *limit_purchase_label;
@property (nonatomic, strong)  UILabel *limit_time_label;
@property (nonatomic, strong)  UIView *v_line;
@property (nonatomic, strong) CZCountDownView *countDown;
@property (nonatomic, strong)  UIView *skill_bg_view;
@property (nonatomic, strong)  HHActivityModel *activity_m;

@end
