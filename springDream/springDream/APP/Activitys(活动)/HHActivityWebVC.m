//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHActivityWebVC.h"
#import <WebKit/WebKit.h>
#import "HHSubmitOrdersVC.h"

@interface HHActivityWebVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
{
    UIButton *rightBtn;
    NSString *webpageUrl;
}
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HHActivityWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // js配置
    self.title = @"拼团";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    HJUser *user = [HJUser sharedUser];
    webpageUrl = [NSString stringWithFormat:@"%@/SpellGroup/Index?gbId=%@",API_HOST1,self.gbId];
    
    NSString *token = [user.token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *url = [NSString stringWithFormat:@"%@/SpellGroup/Index?gbId=%@&token=%@",API_HOST1,self.gbId,token];
    
    WEAK_SELF();
            weakSelf.htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        if(weakSelf.htmlString == nil ||weakSelf.htmlString.length == 0){
            NSLog(@"load failed!");
        }else{
            [weakSelf.webView loadHTMLString:weakSelf.htmlString baseURL:[NSURL URLWithString:url]];
        }
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"share_white"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)backBtnAction{
    
    [self.navigationController popToRootVC];
}
-(void)shareAction{
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareVedioToPlatformType:platformType];
        
    }];
}
//分享到不同平台
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建Webpage内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"赶快来一起拼团啦！" descr:@"优惠多多" thumImage:nil];
    
    
    //设置Webpage地址
    shareObject.webpageUrl = webpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            
        }
    }];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Start:%@",navigation);
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);
    //获取当前页面的title
    [_webView evaluateJavaScript: @"document.title" completionHandler:^(id data, NSError * _Nullable error) {
        self.title = data;
    }];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"Redirect:%@",navigation);
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    
    if([navigationResponse.response.URL.absoluteString containsString:@"ShopCarWeb/PreviewOrder"]){
        rightBtn.hidden = YES;
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
        HHSubmitOrdersVC *vc = [HHSubmitOrdersVC  new];
        vc.mode = model.mode;
        vc.enter_type = HHaddress_type_Spell_group;
        vc.sku_Id = model.skuId;
        vc.gbId = model.gbId;
        vc.count = @"1";
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"HttpError"]){
        
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }  else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
}
#pragma mark-WKScriptMessageHandler


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self allowTurnAroundWithUsrlStr:message.body[@"url"]];
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"closeMe"];
    
}
//跳转
- (void)allowTurnAroundWithUsrlStr:(NSString *)urlStr{
    
    
}

@end
