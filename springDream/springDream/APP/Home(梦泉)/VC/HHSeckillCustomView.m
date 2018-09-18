//
//  HHSeckillCustomView.m
//  springDream
//
//  Created by User on 2018/9/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSeckillCustomView.h"

@implementation HHSeckillCustomView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = APP_COMMON_COLOR;
        
        self.price_label = [UILabel lh_labelWithFrame:CGRectZero text:@"¥200.00" textColor:kWhiteColor font:SemiboldFONT(20) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [self addSubview:self.price_label];
        
        
        self.pre_price_label = [UILabel lh_labelWithFrame:CGRectZero text:@"¥400.00" textColor:kWhiteColor font:FONT(11) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [self addSubview:self.pre_price_label];
        
        self.activity_button = [UIButton lh_buttonWithFrame:CGRectZero target:self action:nil backgroundColor:kClearColor];
        [self.activity_button  setBackgroundImage:[UIImage imageNamed:@"secKill"] forState:UIControlStateNormal];
        
        [self addSubview:self.activity_button];
        
        self.limit_purchase_label = [UILabel lh_labelWithFrame:CGRectZero text:@"每人限购3件！" textColor:RGB(250, 152, 27) font:FONT(11) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [self addSubview:self.limit_purchase_label];
        
        self.limit_time_label = [UILabel lh_labelWithFrame:CGRectZero text:@"距离结束时间" textColor:kWhiteColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:self.limit_time_label];
        
        self.v_line = [UIView lh_viewWithFrame:CGRectZero backColor:RGB(190, 35, 29)];
        [self addSubview:self.v_line];
        
        self.countDown = [CZCountDownView new];
        self.countDown.backgroundImageName = @"";
        self.countDown.timerStopBlock = ^{
            NSLog(@"时间停止");
        };
        [self addSubview:self.countDown];
        
        [self addConstraint];
        
        self.countDown.timestamp = 30*60*60;
    }
    return self;
}
- (void)addConstraint{
    
    self.price_label.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self, 10)
    .heightIs(20)
    .widthIs(100);
    
    self.pre_price_label.sd_layout
    .leftSpaceToView(self.price_label, 8)
    .heightIs(12)
    .widthIs(120)
    .bottomEqualToView(self.price_label);
    
    
    self.activity_button.sd_layout
    .leftEqualToView(self.price_label)
    .topSpaceToView(self.price_label, 3)
    .heightIs(25)
    .widthIs(64);
    
    
    self.limit_purchase_label.sd_layout
    .leftSpaceToView(self.activity_button, 8)
    .heightIs(14)
    .maxWidthIs(130)
    .bottomEqualToView(self.activity_button);
    
    CGFloat  x = (ScreenW-10)*205/365;
    self.v_line.sd_layout
    .topSpaceToView(self, 5)
    .heightIs(55)
    .widthIs(1)
    .centerXIs(x);
    
    
    CGFloat  w = (ScreenW-10)*155/365;
    self.limit_time_label.sd_layout
    .leftSpaceToView(self.v_line, 0)
    .heightIs(16)
    .widthIs(w)
    .bottomEqualToView(self.pre_price_label);
    
    CGFloat  c_w = (ScreenW-10)*160/365;
    self.countDown.sd_layout
    .topSpaceToView(self.limit_time_label, 5)
    .leftSpaceToView(self.v_line, 10)
    .heightIs(30)
    .widthIs(c_w);
    
}
@end
