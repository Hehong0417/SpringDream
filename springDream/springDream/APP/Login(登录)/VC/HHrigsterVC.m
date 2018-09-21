//
//  HHLoginVC.m
//  springDream
//
//  Created by User on 2018/9/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHrigsterVC.h"
#import "LHVerifyCodeButton.h"
#import "HHPhoneBandVC.h"

@interface HHrigsterVC ()
{
    UIImageView *_logo_imagV;
    UIImageView *_phone_imagV;
    UIImageView *_code_imagV;
    UIButton *_rigster_button;
    UITextField *_phone_textfield;
    UITextField *_code_textfield;
    UITextField *_pw_textfield;
    UITextField *_cpw_textfield;
    UITextField *_inv_code_textfield;
    UIButton *_protocol_btn;
    UILabel *_msg_code_label;
    UILabel *_new_account_Label;
}
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;

@end

@implementation HHrigsterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
        _logo_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*431/750) image:[UIImage imageNamed:@"login_bg"]];
    
    [self.view addSubview:_logo_imagV];
    
    UIButton *back_btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 30, 50, 45) target:self action:@selector(backAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [self.view addSubview:back_btn];
    
    _phone_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(_logo_imagV.frame)+WidthScaleSize_H(40), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"phone"]];
    _phone_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_phone_imagV];
    
    _phone_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_phone_imagV.frame)+10, _phone_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入手机号" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _phone_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phone_textfield];
    
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(_phone_imagV.mj_x,CGRectGetMaxY(_phone_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line];
    
    
    _code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(_phone_textfield.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"v_code"]];
    _code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_code_imagV];
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_code_imagV.frame)+10, _code_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入验证码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_imagV.mj_x,CGRectGetMaxY(_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_1];
    
    self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(h_line_1.frame)-WidthScaleSize_W(15)-WidthScaleSize_W(100), CGRectGetMaxY(h_line.frame)+WidthScaleSize_H(10), WidthScaleSize_W(100), WidthScaleSize_H(30))];
    [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn lh_setBackgroundColor:KDCLabelColor forState:UIControlStateNormal];
    [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = FONT(13);
    [self.view addSubview:self.verifyCodeBtn];

    
    UIImageView *pw_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"password"]];
    pw_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:pw_imagV];
    
    _pw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(pw_imagV.frame)+10, pw_imagV.mj_y, ScreenW-CGRectGetMaxX(pw_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _pw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:_pw_textfield];
    
    UIView *h_line_2 = [UIView lh_viewWithFrame:CGRectMake(pw_imagV.mj_x,CGRectGetMaxY(pw_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_2];
    
    
    UIImageView *c_pw_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_2.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"c_password"]];
    c_pw_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:c_pw_imagV];
    
    _cpw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(c_pw_imagV.frame)+10, c_pw_imagV.mj_y, ScreenW-CGRectGetMaxX(c_pw_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"确认密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _cpw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:_cpw_textfield];
    
    UIView *h_line_3 = [UIView lh_viewWithFrame:CGRectMake(c_pw_imagV.mj_x,CGRectGetMaxY(c_pw_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_3];
    
    
    UIImageView *inv_code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_3.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"inv_code"]];
    inv_code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:inv_code_imagV];
    
    _inv_code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(inv_code_imagV.frame)+10, inv_code_imagV.mj_y, ScreenW-CGRectGetMaxX(inv_code_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入邀请码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _inv_code_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_inv_code_textfield];
    
    UIView *h_line_4 = [UIView lh_viewWithFrame:CGRectMake(inv_code_imagV.mj_x,CGRectGetMaxY(inv_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_4];
    
    
    _rigster_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_4.frame)+WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(rigsterAction:) title:@"注册" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [_rigster_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_rigster_button];
    
    
    _protocol_btn = [UIButton lh_buttonWithFrame:CGRectMake(15, CGRectGetMaxY(_rigster_button.frame)+WidthScaleSize_H(5), 30, 30) target:self  action:@selector(agreeAction:) image:[UIImage imageNamed:@"agree_normal"]];
    [_protocol_btn setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateSelected];
    [self.view addSubview:_protocol_btn];
    
    
    UILabel *protocol_label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(_protocol_btn.frame), 0, WidthScaleSize_W(150), WidthScaleSize_H(30)) text:@"我已阅读了《梦泉合约》" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    protocol_label.centerY = _protocol_btn.centerY;
    [self.view addSubview:protocol_label];
    
    
}
- (void)rigsterAction:(UIButton *)button{
    
    HHPhoneBandVC *vc = [HHPhoneBandVC new];
    [self.navigationController pushVC:vc];
    
    
}
- (void)agreeAction:(UIButton *)button{
    
    button.selected = !button.selected;
}
- (void)sendVerifyCode{
    
    
    
}
- (void)backAction{
    
    [self.navigationController popVC];
}

@end
