//
//  HHMyRightsVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyRightsVC.h"

@interface HHMyRightsVC ()

@end

@implementation HHMyRightsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的权益";
    
    self.view.backgroundColor = kWhiteColor;
    
    [self setUpView];
}
- (void)setUpView{
    
    
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(20, 25, ScreenW-40, 35) text:@"您当前是主管：享受如下权益" textColor:kDarkGrayColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [self.view addSubview:lab];

    UILabel *lab2 = [UILabel lh_labelWithFrame:CGRectMake(20, CGRectGetMaxY(lab.frame)+10, ScreenW-40, 35) text:@"1.分销佣金比例:" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [self.view addSubview:lab2];
    
    UIView *form_bg = [UIView lh_viewWithFrame:CGRectMake(25, CGRectGetMaxY(lab2.frame)+10, ScreenW-50, 80) backColor:kWhiteColor];
    [form_bg lh_setCornerRadius:0 borderWidth:1 borderColor:KDCLabelColor];
    NSArray *arr = @[@"1级",@"2级",@"3级",@"10%",@"9%",@"8%"];

    [self.view addSubview:form_bg];
    
    CGFloat form_w = form_bg.mj_w/3;
    CGFloat form_h = form_bg.mj_h/2;
    for (NSInteger i = 0; i<6; i++) {
        NSInteger row = i/3;
        NSInteger line = i%3;
        UILabel *form_lab = [UILabel lh_labelWithFrame:CGRectMake(line*form_w,row*form_h, form_w, form_h) text:arr[i] textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [form_bg addSubview:form_lab];
    }
    UIView *h_line1 = [UIView lh_viewWithFrame:CGRectMake(0, form_h, form_bg.mj_w, 1) backColor:KDCLabelColor];
    [form_bg addSubview:h_line1];

    UIView *v_line1 = [UIView lh_viewWithFrame:CGRectMake(form_w, 0, 1, form_h*2) backColor:KDCLabelColor];
    [form_bg addSubview:v_line1];
    UIView *v_line2 = [UIView lh_viewWithFrame:CGRectMake(form_w*2, 0, 1, form_h*2) backColor:KDCLabelColor];
    [form_bg addSubview:v_line2];
    
    
    UILabel *lab3 = [UILabel lh_labelWithFrame:CGRectMake(20, CGRectGetMaxY(form_bg.frame)+35, ScreenW-40, 35) text:@"您当前的职位是经理，享受销售奖励1.67%" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [self.view addSubview:lab3];
}

@end
