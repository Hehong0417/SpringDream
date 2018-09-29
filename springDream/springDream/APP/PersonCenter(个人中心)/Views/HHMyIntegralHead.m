//
//  HHMyIntegralHead.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyIntegralHead.h"
#import "HHSendIntegralVC.h"

@implementation HHMyIntegralHead

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.vip_integral_label = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW/2, WidthScaleSize_H(70)) text:@"" textColor:kBlackColor font:FONT(20) textAlignment:NSTextAlignmentRight backgroundColor:kClearColor];
        [self addSubview:self.vip_integral_label];
        
        UIButton *send_btn = [UIButton lh_buttonWithFrame:CGRectMake(CGRectGetMaxX(self.vip_integral_label.frame)+10, 0, 70, 25) target:self action:@selector(sendAction) title:@"赠送积分" titleColor:kWhiteColor font:FONT(14) backgroundColor:APP_NAV_COLOR];
        send_btn.centerY = self.vip_integral_label.centerY;
        [send_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        [self addSubview:send_btn];
        
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, CGRectGetMaxY(self.vip_integral_label.frame), ScreenW,1) backColor:KVCBackGroundColor];
        [self addSubview:h_line];

        
      UILabel  *integral_detail_label= [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(h_line.frame), ScreenW, WidthScaleSize_H(40)) text:@"积分明细" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
     [self addSubview:integral_detail_label];

    }
    return self;
}
- (void)sendAction{
    
    //赠送积分
    HHSendIntegralVC *vc = [HHSendIntegralVC new];
    [self.nav pushVC:vc];
    
}
@end
