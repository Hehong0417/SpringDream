//
//  HHSeckillCustomView.m
//  springDream
//
//  Created by User on 2018/9/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSeckillCustomView.h"

@implementation HHSeckillCustomView
{
    UIImageView *imag1;
    UIImageView *imag2;
    UIImageView *group_imag;
    UILabel *group_label;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = APP_COMMON_COLOR;
        
        self.price_label = [UILabel lh_labelWithFrame:CGRectZero text:@"¥200.00" textColor:kWhiteColor font:SemiboldFONT(20) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [self addSubview:self.price_label];
        
        self.pre_price_label = [UILabel lh_labelWithFrame:CGRectZero text:@"原价:400.00" textColor:RGB(222, 204, 206) font:FONT(11) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [self addSubview:self.pre_price_label];
        
        self.skill_bg_view = [UIView new];
        [self addSubview:self.skill_bg_view];
        [self.skill_bg_view lh_setCornerRadius:7 borderWidth:1 borderColor:RGB(215, 86, 16)];
        
        
        imag1 = [UIImageView lh_imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"skill_ clock"]];
        imag1.contentMode = UIViewContentModeCenter;
        imag1.hidden = YES;
        [self.skill_bg_view addSubview:imag1];
        
        imag2 = [UIImageView lh_imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"skill_title"]];
        imag2.contentMode = UIViewContentModeLeft;
        imag2.hidden = YES;
        [self.skill_bg_view addSubview:imag2];
        
        group_imag = [UIImageView lh_imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"spell_group"]];;
        group_imag.contentMode = UIViewContentModeCenter;
        group_imag.hidden = YES;
        [self.skill_bg_view addSubview:group_imag];
        
        group_label = [UILabel lh_labelWithFrame:CGRectZero text:@"" textColor:RGB(250, 152, 27) font:FONT(10) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        group_label.hidden = YES;
        group_label.adjustsFontSizeToFitWidth = YES;
        [self.skill_bg_view addSubview:group_label];

        
        self.limit_purchase_label = [UILabel lh_labelWithFrame:CGRectZero text:@"" textColor:RGB(250, 152, 27) font:FONT(10) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
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
    .heightIs(20);
    //label宽度自适应
    [self.price_label setSingleLineAutoResizeWithMaxWidth:140];
    
    
    self.pre_price_label.sd_layout
    .leftSpaceToView(self.price_label, 8)
    .heightIs(12)
    .widthIs(100)
    .bottomEqualToView(self.price_label);
    
    
    self.skill_bg_view.sd_layout
    .leftEqualToView(self.price_label)
    .topSpaceToView(self.price_label, 3)
    .heightIs(25)
    .widthIs(64);
    
    
    imag1.sd_layout
    .leftSpaceToView(self.skill_bg_view, 0)
    .topSpaceToView(self.skill_bg_view, 0)
    .bottomSpaceToView(self.skill_bg_view, 0)
    .widthIs(24);
    
    imag2.sd_layout
    .leftSpaceToView(imag1, 0)
    .topSpaceToView(self.skill_bg_view, 0)
    .rightSpaceToView(self.skill_bg_view, 0)
    .bottomSpaceToView(self.skill_bg_view, 0);

    group_imag.sd_layout
    .leftSpaceToView(self.skill_bg_view, 3)
    .topSpaceToView(self.skill_bg_view, 0)
    .widthIs(15)
    .bottomSpaceToView(self.skill_bg_view, 0);
    
    group_label.sd_layout
    .leftSpaceToView(group_imag,2)
    .topSpaceToView(self.skill_bg_view, 0)
    .rightSpaceToView(self.skill_bg_view, 0)
    .bottomSpaceToView(self.skill_bg_view, 0);
    
    
    self.limit_purchase_label.sd_layout
    .leftSpaceToView(self.skill_bg_view, 8)
    .heightIs(14)
    .maxWidthIs(130)
    .bottomEqualToView(self.skill_bg_view);
    
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
- (void)setActivity_m:(HHActivityModel *)activity_m{
    
    _activity_m = activity_m;
    
    if ([_activity_m.IsSecKill isEqual:@1]) {
        imag1.hidden = NO;
        imag2.hidden = NO;
        group_label.hidden = YES;
        group_imag.hidden = YES;
        
        self.limit_purchase_label.text = [NSString stringWithFormat:@"每人限购%@件！",activity_m.LimitCount];
    }
    if ([_activity_m.IsJoin isEqual:@1]) {
        imag1.hidden = YES;
        imag2.hidden = YES;
        group_label.hidden = NO;
        group_imag.hidden = NO;
        group_label.text = [NSString stringWithFormat:@"%@人成团",activity_m.Count];
        self.limit_purchase_label.text = @"";
    }
}
@end
