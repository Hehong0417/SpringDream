//
//  HHMywalletCell.m
//  springDream
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMywalletCell.h"

@implementation HHMywalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *form_bg = [UIView lh_viewWithFrame:CGRectMake(25, 20, ScreenW-50, 150-40) backColor:kWhiteColor];
        [form_bg lh_setCornerRadius:0 borderWidth:1 borderColor:KDCLabelColor];
        NSArray *arr = @[@"时间：0000-00-00",@"积分：2323",@"变动类型：购物",@"单据：0834355"];
        [self.contentView addSubview:form_bg];
        
        CGFloat form_w = form_bg.mj_w/2-20;
        CGFloat form_h = form_bg.mj_h/3;
        for (NSInteger i = 0; i<4; i++) {
            NSInteger row = i/2;
            NSInteger line = i%2;
            UILabel *form_lab = [UILabel lh_labelWithFrame:CGRectMake(line*(form_w+20)+20,row*form_h, form_w, form_h) text:arr[i] textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
            [form_bg addSubview:form_lab];
        }
        UIView *h_line1 = [UIView lh_viewWithFrame:CGRectMake(0, form_h, form_bg.mj_w, 1) backColor:KDCLabelColor];
        [form_bg addSubview:h_line1];
        UIView *h_line2 = [UIView lh_viewWithFrame:CGRectMake(0, form_h*2, form_bg.mj_w, 1) backColor:KDCLabelColor];
        [form_bg addSubview:h_line2];
        UIView *v_line = [UIView lh_viewWithFrame:CGRectMake(form_w+20, 0, 1, form_h*2) backColor:KDCLabelColor];
        [form_bg addSubview:v_line];
        
        UILabel *remark_lab = [UILabel lh_labelWithFrame:CGRectMake(20, form_h*2, form_bg.mj_w-20, form_h) text:@"备注：东西轻拿轻放哦" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [form_bg addSubview:remark_lab];

    }
    return self;
}

@end
