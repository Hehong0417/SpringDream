//
//  HHLoginVC.m
//  springDream
//
//  Created by User on 2018/9/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPhoneBandVC.h"
#import "LHVerifyCodeButton.h"

@interface HHPhoneBandVC ()<UITextFieldDelegate>
{
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

@implementation HHPhoneBandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;

    self.title = @"手机号绑定";
    
    _phone_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25),WidthScaleSize_H(30), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"phone"]];
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
    [self.verifyCodeBtn lh_setBackgroundColor:APP_NAV_COLOR forState:UIControlStateNormal];
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
    _pw_textfield.secureTextEntry = YES;
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
    _inv_code_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:_inv_code_textfield];
    
    UIView *h_line_4 = [UIView lh_viewWithFrame:CGRectMake(inv_code_imagV.mj_x,CGRectGetMaxY(inv_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_4];
    
    
    _rigster_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_4.frame)+WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(rigsterAction:) title:@"验证" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [_rigster_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_rigster_button];
    
}
- (void)rigsterAction:(UIButton *)button{
    
    NSString *isValid =  [self isValidWithphoneStr:_phone_textfield.text verifyCodeStr:_code_textfield.text newPwdStr:_pw_textfield.text commitPwdStr:_cpw_textfield.text];
    NSString *pw_str = _pw_textfield.text;
    NSString *verification_str = _code_textfield.text;

    if (!isValid) {
        [[[HHUserLoginAPI postRegsterWithUseWay:@1 Phone:_phone_textfield.text OpenId:self.openId Pwd:_pw_textfield.text VerificationCode:_code_textfield.text InviteCode:_inv_code_textfield.text UserImage:self.UserImage] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    
                    [self loginWithUseWay:@1 Pwd:pw_str  VerificationCode:verification_str];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
        }];
        
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:isValid];
    }
    
}
- (void)loginWithUseWay:(NSNumber *)UseWay Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode{
    
    [[[HHUserLoginAPI postApiLoginWithUseWay:UseWay Phone:_phone_textfield.text OpenId:nil Pwd:Pwd VerificationCode:VerificationCode] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSString *token = api.Data;
                HJUser *user = [HJUser sharedUser];
                user.token = token;
                [user write];
                HJTabBarController *tabBarVC = [[HJTabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }
    }];
    
}

- (NSString *)isValidWithphoneStr:(NSString *)phoneStr verifyCodeStr:(NSString *)verifyCodeStr  newPwdStr:(NSString *)newPwdStr commitPwdStr:(NSString *)commitPwdStr{
    
    if (phoneStr.length == 0) {
        return @"请输入手机号！";
    }else if (verifyCodeStr.length == 0){
        return @"请输入验证码！";
    }else if (newPwdStr.length == 0){
        return @"请输入密码！";
    }else if (commitPwdStr.length == 0){
        return @"请输入确认密码！";
    }else if (![commitPwdStr isEqualToString:newPwdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
}
- (void)agreeAction:(UIButton *)button{
    
    button.selected = !button.selected;
}
- (void)sendVerifyCode{
    
    if (_phone_textfield.text.length==0) {
           [SVProgressHUD showInfoWithStatus:@"请先填写手机号"];
    }else{
        [[[HHUserLoginAPI postSmsSendCodeWithmobile:_phone_textfield.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    NSNumber *time = api.Data[@"expires"];
                    [self.verifyCodeBtn startTimer:time.integerValue];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
        }];
    }
    
}
- (void)backAction{
    
    [self.navigationController popVC];
}

@end
