//
//  HHMyWalletHead.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyWalletHead.h"

@implementation HHMyWalletHead

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = RGB(255, 239, 239);
        UILabel *title_label = [UILabel lh_labelWithFrame:CGRectMake(0, 30, ScreenW, 20) text:@"总金额" textColor:kDarkGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:title_label];
        self.total_price_label = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(title_label.frame), ScreenW, 25) text:@"9999.00" textColor:RGB(170, 0, 0) font: BoldFONT(22) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:self.total_price_label];
       
        UIView *form_bg = [UIView lh_viewWithFrame:CGRectMake(0, 100, ScreenW, 30) backColor:kClearColor];
        [self addSubview:form_bg];
        [form_bg lh_setCornerRadius:0 borderWidth:1 borderColor:RGB(255, 202, 202)];
        
        
        NSArray *arr = @[@"时间：0000-00-00",@"类型：选择类型"];
        CGFloat form_w = form_bg.mj_w/2-40;

        for (NSInteger i = 0; i<2; i++) {
            UILabel *form_lab = [UILabel lh_labelWithFrame:CGRectMake(i*(form_w+40)+40,0, form_w, 30) text:arr[i] textColor:kDarkGrayColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
            [form_bg addSubview:form_lab];
        }
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(ScreenW/2, 0, 1, 30) backColor:RGB(255, 202, 202)];
        [form_bg addSubview:h_line];

    }
    return self;
}
@end
