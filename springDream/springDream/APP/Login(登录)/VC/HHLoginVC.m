//
//  HHLoginVC.m
//  springDream
//
//  Created by User on 2018/9/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHLoginVC.h"
#import "HHrigsterVC.h"
#import "WXApi.h"
#import "LHVerifyCodeButton.h"
#import "HHPhoneBandVC.h"
#import "HHForgetPasswordVC.h"

@interface HHLoginVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *_logo_imagV;
    UIImageView *_phone_imagV;
    UIImageView *_code_imagV;
    UIButton *_login_button;
    UIButton *_wx_login_button;
    UITextField *_phone_textfield;
    UILabel *_new_account_Label;
    MBProgressHUD  *hud;
}
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;
@property(nonatomic,strong) UILabel *msg_code_label;
@property (nonatomic, assign) BOOL isCanBack;
@property(nonatomic,strong) UITextField *code_textfield;

@end

@implementation HHLoginVC

 BOOL flag=0;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = kWhiteColor;
    
    _logo_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*431/750) image:[UIImage imageNamed:@"login_bg"]];

    [self.view addSubview:_logo_imagV];
    
    _phone_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(_logo_imagV.frame)+WidthScaleSize_H(40), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"phone"]];
    _phone_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_phone_imagV];
    
    _phone_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_phone_imagV.frame)+10, _phone_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入手机号" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _phone_textfield.keyboardType = UIKeyboardTypeNumberPad;
    _phone_textfield.delegate = self;
    [self.view addSubview:_phone_textfield];
    
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(_phone_imagV.mj_x,CGRectGetMaxY(_phone_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line];

    flag = NO;
    
    _code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(_phone_textfield.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"password"]];
    _code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_code_imagV];
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_code_imagV.frame)+10, _code_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _code_textfield.secureTextEntry = YES;
    _code_textfield.delegate = self;

    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_imagV.mj_x,CGRectGetMaxY(_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_1];

    self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(h_line.frame)-WidthScaleSize_W(15)-WidthScaleSize_W(100), CGRectGetMaxY(h_line.frame)+WidthScaleSize_H(10), WidthScaleSize_W(100), WidthScaleSize_H(30))];
    [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn lh_setBackgroundColor:APP_NAV_COLOR forState:UIControlStateNormal];
    [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.verifyCodeBtn.hidden = YES;
    [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = FONT(13);
    [self.view addSubview:self.verifyCodeBtn];
    
    UILabel *forPwd_label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(h_line_1.frame)-150, CGRectGetMaxY(h_line_1.frame), 150, WidthScaleSize_H(30)) text:@"忘记密码？" textColor:APP_NAV_COLOR font:FONT(13) textAlignment:NSTextAlignmentRight backgroundColor:kClearColor];
    forPwd_label.userInteractionEnabled = YES;
    [forPwd_label setTapActionWithBlock:^{
        HHForgetPasswordVC *vc = [HHForgetPasswordVC new];
        [self.navigationController pushVC:vc];
    }];
    
    [self.view addSubview:forPwd_label];

    _login_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(55), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(loginAction:) title:@"登录" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [_login_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_login_button];

    self.msg_code_label = [UILabel lh_labelWithFrame:CGRectMake(_login_button.mj_x+WidthScaleSize_W(15), CGRectGetMaxY(_login_button.frame)+WidthScaleSize_W(15), WidthScaleSize_W(120), WidthScaleSize_H(20)) text:@"短信验证码登录" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.view addSubview:self.msg_code_label];
    self.msg_code_label.userInteractionEnabled = YES;
    WEAKSELF
    
    _new_account_Label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(_login_button.frame)-WidthScaleSize_W(140), CGRectGetMaxY(_login_button.frame)+WidthScaleSize_H(15), WidthScaleSize_W(120), WidthScaleSize_W(20)) text:@"新账号注册" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentRight backgroundColor:kClearColor];
    [self.view addSubview:_new_account_Label];
    
    _new_account_Label.userInteractionEnabled = YES;
    [_new_account_Label setTapActionWithBlock:^{
        HHrigsterVC *vc = [HHrigsterVC new];
        [weakSelf.navigationController pushVC:vc];
    }];
    
    UILabel *other_loginWay_label = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(_new_account_Label.frame)+WidthScaleSize_H(30), WidthScaleSize_W(110), WidthScaleSize_H(30)) text:@"其他登录方式" textColor:kDarkGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    other_loginWay_label.centerX = self.view.centerX;
    [self.view addSubview:other_loginWay_label];

    
    UIView *left_short_line = [UIView lh_viewWithFrame:CGRectMake(other_loginWay_label.mj_x-WidthScaleSize_W(40), 0, WidthScaleSize_H(40), 1) backColor:KVCBackGroundColor];
    left_short_line.centerY = other_loginWay_label.centerY;
    [self.view addSubview:left_short_line];

    
    UIView *right_short_line = [UIView lh_viewWithFrame:CGRectMake(CGRectGetMaxX(other_loginWay_label.frame), 0, WidthScaleSize_H(40), 1) backColor:KVCBackGroundColor];
    right_short_line.centerY = other_loginWay_label.centerY;
    [self.view addSubview:right_short_line];
    
    
    _wx_login_button = [UIButton lh_buttonWithFrame:CGRectMake(0, CGRectGetMaxY(other_loginWay_label.frame)+WidthScaleSize_W(5), WidthScaleSize_W(150), WidthScaleSize_H(80)) target:self action:@selector(wx_login_buttonAction:) image:[UIImage imageNamed:@"wx_login2"]];
    _wx_login_button.centerX = self.view.centerX;
    [self.view addSubview:_wx_login_button];
    
    [self.msg_code_label setTapActionWithBlock:^{
        flag = !flag;
        if (flag) {
            weakSelf.msg_code_label.text = @"密码登录";
            weakSelf.verifyCodeBtn.hidden = NO;
            weakSelf.code_textfield.placeholder = @"输入验证码";
        }else{
            weakSelf.msg_code_label.text = @"短信验证码登录";
            weakSelf.verifyCodeBtn.hidden = YES;
            weakSelf.code_textfield.placeholder = @"输入密码";

        }
    }];
    
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
        //已安装微信
        other_loginWay_label.hidden = NO;
        left_short_line.hidden = NO;
        right_short_line.hidden = NO;
        _wx_login_button.hidden = NO;
    }else{
        //未安装微信
        other_loginWay_label.hidden = YES;
        left_short_line.hidden = YES;
        right_short_line.hidden = YES;
        _wx_login_button.hidden = YES;
    }
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

- (void)loginAction:(UIButton *)button{

    if (flag == YES) {
        // 短信验证码登录
        NSString *isvalid =  [self isValidWithphoneStr:_phone_textfield.text verifyCodeStr:_code_textfield.text];
        if (!isvalid) {
            [self loginWithUseWay:@3 Pwd:nil VerificationCode:_code_textfield.text];
        }else{
            [SVProgressHUD showInfoWithStatus:isvalid];
        }
    }else{
        
        // 密码登录
       NSString *isvalid =  [self isValidWithphoneStr:_phone_textfield.text newPwdStr:_code_textfield.text];
        if (!isvalid) {
            [self loginWithUseWay:@1 Pwd:_code_textfield.text VerificationCode:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:isvalid];
        }
    }
    
}
- (void)loginWithUseWay:(NSNumber *)UseWay Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode{
    
    [[[HHUserLoginAPI postApiLoginWithUseWay:UseWay Phone:_phone_textfield.text OpenId:nil Pwd:Pwd VerificationCode:VerificationCode unionId:nil] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
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
- (NSString *)isValidWithphoneStr:(NSString *)phoneStr newPwdStr:(NSString *)newPwdStr{
    
    if (phoneStr.length == 0) {
        return @"请输入手机号！";
    }else if (newPwdStr.length == 0){
        return @"请输入密码！";
    }
    return nil;
}
- (NSString *)isValidWithphoneStr:(NSString *)phoneStr verifyCodeStr:(NSString *)verifyCodeStr{
    if (phoneStr.length == 0) {
        return @"请输入手机号！";
    }else if (verifyCodeStr.length == 0){
        return @"请输入验证码！";
    }
    return nil;
    
}
 - (void)wx_login_buttonAction:(UIButton *)button{
     
    [self getAuthWithUserInfoFromWechat];

                            
 }
#pragma mark - 微信授权，获取微信信息

- (void)getAuthWithUserInfoFromWechat
{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    
    
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
    
            if (error) {
                NSLog(@"error--%@",error);
    
            } else {
    
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.color = KA0LabelColor;
                hud.detailsLabelText = @"授权中，请稍后...";
                hud.detailsLabelColor = kWhiteColor;
                hud.detailsLabelFont = FONT(14);
                hud.activityIndicatorColor = kWhiteColor;
                [hud showAnimated:YES];
    
                UMSocialUserInfoResponse *resp = result;
                // 授权信息 resp.uid,resp.unionId,resp.openid,resp.accessToken,resp.refreshToken
                // 用户信息 resp.name,resp.iconurl,resp.gender
              
    
//    账户是否存在 ？登录:注册
//    NSString *openid = @"o8dxQ1s0Cr9bkYry3FNYVw0WUQcc";
         NSString *openid = resp.openid;
//    ***************//
    [[[HHUserLoginAPI postApiLoginWithUseWay:@2 Phone:nil OpenId:openid Pwd:nil VerificationCode:nil unionId:resp.unionId] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {

        if (!error) {
            if (api.State == 1) {
                
                NSString *token = api.Data;
                HJUser *user = [HJUser sharedUser];
                user.token = token;
                [user write];
                kKeyWindow.rootViewController = [[HJTabBarController alloc] init];

            }else if (api.State == -1) {

                HHPhoneBandVC *vc = [HHPhoneBandVC new];
                vc.openId = openid;
                vc.UserImage = resp.iconurl;
                vc.unionId = resp.unionId;
                [self.navigationController pushVC:vc];
                [hud hideAnimated:YES];
                
            }else{
                [hud hideAnimated:YES];
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }else{
            [hud hideAnimated:YES];
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
            }
        }

    }];
//    *********************//
    
            }
    
        }];
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _phone_textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (textField == _code_textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 20 && range.length!=1){
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack{
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}
@end
