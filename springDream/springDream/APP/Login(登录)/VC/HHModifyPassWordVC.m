//
//  HHLoginVC.m
//  springDream
//
//  Created by User on 2018/9/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHModifyPassWordVC.h"
#import "HHLoginVC.h"

@interface HHModifyPassWordVC ()<UITextFieldDelegate>
{
    UIImageView *_code_imagV;
    UIButton *_rigster_button;
    UITextField *_code_textfield;
    UITextField *_pw_textfield;
    UITextField *_cpw_textfield;
    UIButton *_protocol_btn;
}

@end

@implementation HHModifyPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    self.title = @"修改密码";
    
    _code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), WidthScaleSize_H(40), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"password"]];
    _code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_code_imagV];
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_code_imagV.frame)+10, _code_imagV.mj_y, ScreenW-CGRectGetMaxX(_code_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"请输入原始密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _code_textfield.secureTextEntry = YES;
    _code_textfield.delegate = self;
    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_imagV.mj_x,CGRectGetMaxY(_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_1];
    
    
    UIImageView *pw_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"new_pwd"]];
    pw_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:pw_imagV];
    
    _pw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(pw_imagV.frame)+10, pw_imagV.mj_y, ScreenW-CGRectGetMaxX(pw_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"请输入新密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _pw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _pw_textfield.secureTextEntry = YES;
    _pw_textfield.delegate = self;
    [self.view addSubview:_pw_textfield];
    
    UIView *h_line_2 = [UIView lh_viewWithFrame:CGRectMake(pw_imagV.mj_x,CGRectGetMaxY(pw_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_2];
    
    
    UIImageView *c_pw_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(h_line_2.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"c_password"]];
    c_pw_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:c_pw_imagV];
    
    _cpw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(c_pw_imagV.frame)+10, c_pw_imagV.mj_y, ScreenW-CGRectGetMaxX(c_pw_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"再次输入新密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _cpw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _cpw_textfield.secureTextEntry = YES;
    _cpw_textfield.delegate = self;
    [self.view addSubview:_cpw_textfield];
    
    UIView *h_line_3 = [UIView lh_viewWithFrame:CGRectMake(c_pw_imagV.mj_x,CGRectGetMaxY(c_pw_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_3];
    
    
    _rigster_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_3.frame)+WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(rigsterAction:) title:@"确认" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [_rigster_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_rigster_button];
    
    
}
- (void)rigsterAction:(UIButton *)button{
    
    NSString *isValid =  [self isValidWithPwdStr:_code_textfield.text newPwdStr:_pw_textfield.text commitPwdStr:_cpw_textfield.text];
    NSString *pw_str = _code_textfield.text;
    NSString *commitPwdStr = _cpw_textfield.text;

    if (!isValid) {
        
         [[[HHUserLoginAPI postUpdatePasswordWithOldPassword:pw_str Password:commitPwdStr] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showSuccessWithStatus:@"修改密码成功，请重新登录！"];
                    HJUser *user = [HJUser sharedUser];
                    user.token = nil;
                    [user write];
                    kKeyWindow.rootViewController = [[HJNavigationController alloc] initWithRootViewController:[HHLoginVC new]];

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

- (NSString *)isValidWithPwdStr:(NSString *)pwdStr  newPwdStr:(NSString *)newPwdStr commitPwdStr:(NSString *)commitPwdStr{
    
     if (pwdStr.length == 0){
        return @"请输入原始密码！";
    }
    else if (newPwdStr.length == 0){
        return @"请输入新密码！";
    }else if (commitPwdStr.length == 0){
        return @"请再次输入新密码！";
    }else if (![commitPwdStr isEqualToString:newPwdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 20 && range.length!=1){
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    
    return YES;
}
@end
