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
@interface HHLoginVC ()
{
    UIImageView *_logo_imagV;
    UIImageView *_phone_imagV;
    UIImageView *_code_imagV;
    UIButton *_login_button;
    UIButton *_wx_login_button;
    UITextField *_phone_textfield;
    UITextField *_code_textfield;
    UILabel *_new_account_Label;
    MBProgressHUD  *hud;
}
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;
@property(nonatomic,strong) UILabel *msg_code_label;

@end

@implementation HHLoginVC

static BOOL flag=0;

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
    [self.view addSubview:_phone_textfield];
    
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(_phone_imagV.mj_x,CGRectGetMaxY(_phone_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line];

    self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(h_line.frame)-WidthScaleSize_W(15)-WidthScaleSize_W(100), CGRectGetMaxY(h_line.frame)+WidthScaleSize_H(10), WidthScaleSize_W(100), WidthScaleSize_H(30))];
    [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn lh_setBackgroundColor:APP_NAV_COLOR forState:UIControlStateNormal];
    [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = FONT(13);
    [self.view addSubview:self.verifyCodeBtn];
    
    
    _code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(_phone_textfield.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"password"]];
    _code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_code_imagV];
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_code_imagV.frame)+10, _code_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_imagV.mj_x,CGRectGetMaxY(_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_1];
    
    
    _login_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(loginAction:) title:@"登录" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
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
        }else{
            weakSelf.msg_code_label.text = @"验证码登录";
            weakSelf.verifyCodeBtn.hidden = YES;
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
    
    
    
}
- (void)loginAction:(UIButton *)button{

    
    
}
 - (void)wx_login_buttonAction:(UIButton *)button{
                            
                            
    [self getAuthWithUserInfoFromWechat];

                            
 }
#pragma mark - 微信授权，获取微信信息

- (void)getAuthWithUserInfoFromWechat
{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    
    //
    //    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
    //
    //        if (error) {
    //            NSLog(@"error--%@",error);
    //
    //        } else {
    //
    //            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            hud.color = KA0LabelColor;
    //            hud.detailsLabelText = @"授权中，请稍后...";
    //            hud.detailsLabelColor = kWhiteColor;
    //            hud.detailsLabelFont = FONT(14);
    //            hud.activityIndicatorColor = kWhiteColor;
    //            [hud showAnimated:YES];
    //
    //            UMSocialUserInfoResponse *resp = result;
    //            // 授权信息
    //            NSLog(@"Wechat uid: %@", resp.uid);
    //            NSLog(@"Wechat unionId: %@", resp.unionId);
    //            NSLog(@"Wechat openid: %@", resp.openid);
    //            NSLog(@"Wechat accessToken: %@", resp.accessToken);
    //            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
    //            NSLog(@"Wechat expiration: %@", resp.expiration);
    //            // 用户信息
    //            NSLog(@"Wechat name: %@", resp.name);
    //            NSLog(@"Wechat iconurl: %@", resp.iconurl);
    //            NSLog(@"Wechat gender: %@", resp.gender);
    
    //账户是否存在 ？登录:注册
    NSString *openid = @"o8dxQ1s0Cr9bkYry3FNYVw0WUQcc";
    //                             NSString *openid = resp.openid;
    //***************//
    [[[HHUserLoginAPI postApiLoginWithopenId:openid] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSString *token = api.Data;
                HJUser *user = [HJUser sharedUser];
                user.token = token;
                [user write];
                kKeyWindow.rootViewController = [[HJTabBarController alloc] init];
                
            }else if (api.State == -99) {
                
                //                                        [self registerWithName:resp.name image:resp.iconurl openid:resp.openid unionId:resp.unionId];
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
    //*********************//
    
    //        }
    //
    //    }];
    
    
    
}
#pragma mark- 注册

- (void)registerWithName:(NSString *)name image:(NSString *)image openid:(NSString *)openid  unionId:(NSString *)unionId{
    
    //注册
    [[[HHUserLoginAPI postRegsterWithopenId:openid name:name image:image unionId:unionId] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSString *token = api.Data;
                HJUser *user = [HJUser sharedUser];
                user.token = token;
                [user write];
                kKeyWindow.rootViewController = [[HJTabBarController alloc] init];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
                [hud hideAnimated:YES];
                
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            [hud hideAnimated:YES];
        }
    }];
    
}
@end
