//
//  HHForgetPasswordVC.m
//  springDream
//
//  Created by User on 2018/10/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHForgetPasswordVC.h"

@interface HHForgetPasswordVC ()<UITextFieldDelegate>
{
    UIImageView *_code_imagV;
    UIButton *_rigster_button;
    UITextField *_code_textfield;
    UITextField *_pw_textfield;
    UITextField *_cpw_textfield;
    UIButton *_protocol_btn;
}
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;

@end

@implementation HHForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"忘记密码";
    self.view.backgroundColor = kWhiteColor;
    _code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), WidthScaleSize_H(40), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"phone"]];
    _code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_code_imagV];
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_code_imagV.frame)+10, _code_imagV.mj_y, ScreenW-CGRectGetMaxX(_code_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"请输入手机号" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeNumberPad;
    _code_textfield.delegate = self;
    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_imagV.mj_x,CGRectGetMaxY(_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_1];
    
    
    UIImageView *pw_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"v_code"]];
    pw_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:pw_imagV];
    
    _pw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(pw_imagV.frame)+10, pw_imagV.mj_y, ScreenW-CGRectGetMaxX(pw_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"请输入验证码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _pw_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pw_textfield];
    
    UIView *h_line_2 = [UIView lh_viewWithFrame:CGRectMake(pw_imagV.mj_x,CGRectGetMaxY(pw_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_2];
    
    self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(h_line_1.frame)-WidthScaleSize_W(15)-WidthScaleSize_W(100), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(10), WidthScaleSize_W(100), WidthScaleSize_H(30))];
    [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn lh_setBackgroundColor:APP_NAV_COLOR forState:UIControlStateNormal];
    [self.verifyCodeBtn lh_setBackgroundColor:KDCLabelColor forState:UIControlStateSelected];
    [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = FONT(13);
    [self.view addSubview:self.verifyCodeBtn];
    
    
    UIImageView *c_pw_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_2.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"password"]];
    c_pw_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:c_pw_imagV];
    
    _cpw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(c_pw_imagV.frame)+10, c_pw_imagV.mj_y, ScreenW-CGRectGetMaxX(c_pw_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"请输入新密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _cpw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _cpw_textfield.secureTextEntry = YES;
    _cpw_textfield.delegate = self;
    [self.view addSubview:_cpw_textfield];
    
    UIView *h_line_3 = [UIView lh_viewWithFrame:CGRectMake(c_pw_imagV.mj_x,CGRectGetMaxY(c_pw_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_3];
    
    
    _rigster_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_3.frame)+WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(forgetAction:) title:@"重置密码" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [_rigster_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_rigster_button];
    
}
- (void)forgetAction:(UIButton *)button{
    
    NSString *isValid =  [self isValidWithPhoneStr:_code_textfield.text v_codeStr:_pw_textfield.text pwdStr:_cpw_textfield.text];
    NSString *phone_str = _code_textfield.text;
    NSString *verification_str = _pw_textfield.text;
    NSString *password_str = _cpw_textfield.text;

    if (!isValid) {
        
                 [[[HHUserLoginAPI postUpdatePasswordToPhoneWithPhone:phone_str Password:password_str VerificationCode:verification_str] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
                    if (!error) {
                        if (api.State == 1) {
                            
                            [self.navigationController popVC];
                            [SVProgressHUD showSuccessWithStatus:@"重置密码成功，请重新登录！"];
        
                        }else{
                            [SVProgressHUD showInfoWithStatus:@"重置密码失败！"];
                        }
                    }
                }];
        
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:isValid];
    }
    
}

- (NSString *)isValidWithPhoneStr:(NSString *)phoneStr  v_codeStr:(NSString *)v_codeStr pwdStr:(NSString *)pwdStr{
    
    if (phoneStr.length == 0){
        return @"请输入手机号！";
    } else if (v_codeStr.length == 0){
        return @"请输入验证码！";
    }else if (pwdStr.length == 0){
        return @"请输入新密码！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _code_textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (textField == _code_textfield||textField == _cpw_textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 20 && range.length!=1){
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    
    return YES;
}
- (void)sendVerifyCode:(LHVerifyCodeButton *)button{
    if (_code_textfield.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请先填写手机号"];
    }else{
        [[[HHUserLoginAPI postSmsSendCodeWithmobile:_code_textfield.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
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
@end
