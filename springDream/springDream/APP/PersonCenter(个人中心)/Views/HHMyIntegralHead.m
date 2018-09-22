//
//  HHMyIntegralHead.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyIntegralHead.h"

@implementation HHMyIntegralHead

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.vip_integral_label = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(70)) text:@"299分" textColor:kBlackColor font:FONT(20) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:self.vip_integral_label];
        
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, CGRectGetMaxY(self.vip_integral_label.frame), ScreenW,1) backColor:KVCBackGroundColor];
        [self addSubview:h_line];

        
      UILabel  *integral_detail_label= [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(h_line.frame), ScreenW, WidthScaleSize_H(40)) text:@"积分明细" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
     [self addSubview:integral_detail_label];

    }
    return self;
}

@end
