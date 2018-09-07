//
//  HHWXLoginVC.m
//  CredictCard
//
//  Created by User on 2017/12/21.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHWXLoginVC.h"
#import "HHBandPhoneVc.h"
#import "WXApi.h"
#import "HHPhoneLoginVC.h"

@interface HHWXLoginVC ()
{
    MBProgressHUD  *hud;
}
@end

@implementation HHWXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = RGB(120, 159, 243);
    
    
    self.login_label.userInteractionEnabled = YES;
        
         if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
          //已安装微信
             [self.loginBtn setImage:[UIImage imageNamed:@"wx_login"] forState:UIControlStateNormal];
             self.login_label.text = @"微信登录";
             
             [self.login_label setTapActionWithBlock:^{
                 [self getAuthWithUserInfoFromWechat];

                }];
        }else{
          //未安装微信
            [self.loginBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
            self.login_label.text = @"登 录";
            [self.login_label setTapActionWithBlock:^{
                
                HHPhoneLoginVC *vc = [[HHPhoneLoginVC alloc] initWithNibName:@"HHPhoneLoginVC" bundle:nil];
                [self.navigationController pushVC:vc];
            }];
        
        }

    [self.login_label lh_setCornerRadius:2 borderWidth:0 borderColor:nil];

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
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat unionId: %@", resp.unionId);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);

            //账户是否存在 ？登录:注册
                           //NSString *openid = @"o8dxQ1s0Cr9bkYry3FNYVw0WUQcc";
                             NSString *openid = resp.openid;
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
                                        
                                        [self registerWithName:resp.name image:resp.iconurl openid:resp.openid unionId:resp.unionId];
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
            
        }
        
    }];
    

    
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
