//
//  AppDelegate.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "HHLoginVC.h"
#import "UncaughtExceptionHandler.h"

//优选君
#define USHARE_DEMO_APPKEY  @"5a5f10bfa40fa34719000128"
#define Wechat_AppKey  @"wx33876b8653ae654a"
#define Wechat_appSecret  @"202317c588688ebc058099ab101603fa"

//梦泉
//#define USHARE_DEMO_APPKEY  @"5b90a1808f4a9d121b000037"
//#define Wechat_AppKey  @"wxa40e7d9b1283c27c"
//#define Wechat_appSecret  @"538eaa42ff2f80f87f631f59c9126f4f"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UncaughtExceptionHandler installUncaughtExceptionHandler:YES showAlert:YES];

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[HJTabBarController alloc] init];
    
    HJUser *user = [HJUser sharedUser];
    if (user.token) {
    }else{
        self.window.rootViewController = [[HJNavigationController alloc] initWithRootViewController:[[HHLoginVC alloc] init]];
    }
    [self IQKeyboardManagerConfig];
    
    [WXApi registerApp:Wechat_AppKey];
        
  
    //配置友盟
    [self UMSocialConfig];
    [self.window makeKeyAndVisible];

    return YES;
}
- (void)IQKeyboardManagerConfig {
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    keyboardManager.toolbarDoneBarButtonItemText = @"确定";
}
#pragma mark - 配置友盟

- (void)UMSocialConfig{
    
    /* 打开调试日志 */
    [UMConfigure setLogEnabled:YES];
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:USHARE_DEMO_APPKEY channel:@"App Store"];
    
    [self configUSharePlatforms];
    
    
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:Wechat_AppKey appSecret:Wechat_appSecret redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:Wechat_AppKey appSecret:Wechat_appSecret redirectURL:@"http://mobile.umeng.com/social"];
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:self];

    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:self];

    }
    return result;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}
//微信支付回调
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]){
        
        PayResp *response = (PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:{
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [[NSNotificationCenter defaultCenter]postNotificationName:KWX_Pay_Sucess_Notification object:@""];
                NSLog(@"支付成功");
            }
                break;
            default:{
                [[NSNotificationCenter defaultCenter]postNotificationName:KWX_Pay_Fail_Notification object:@""];
                NSLog(@"支付失败，retcode=%d",resp.errCode);
            }
                break;
        }
    }
}






@end
