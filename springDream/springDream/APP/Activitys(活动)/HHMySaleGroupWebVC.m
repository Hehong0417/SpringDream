//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMySaleGroupWebVC.h"
#import <WebKit/WebKit.h>
#import "HHSubmitOrdersVC.h"
#import "HHOrderVC.h"
#import "HHnormalSuccessVC.h"
#import "HHNewApplyRefundVC.h"

@interface HHMySaleGroupWebVC ()<WKUIDelegate,WKNavigationDelegate>
{
    UIButton *rightBtn;
    NSString *url;
    NSString *webpageUrl;
    NSString *responseUrl;
    MBProgressHUD *_hud;

}
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HHMySaleGroupWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"降价团";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-Status_HEIGHT-44) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadData];
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"share_white"]];
    rightBtn.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self addHeadRefresh];
    
}
#pragma mark - 刷新控件

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([responseUrl containsString:@"Personal/CutGroup"]) {
            [self loadData];
        }else{
            if (_webView.scrollView.mj_header.isRefreshing) {
                [_webView.scrollView.mj_header endRefreshing];
            }
        }
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    _webView.scrollView.mj_header = refreshHeader;
}
- (void)loadData{
    
    HJUser *user = [HJUser sharedUser];
    
    NSString *token = [user.token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];

    url = [NSString stringWithFormat:@"%@/Personal/CutGroup?token=%@&cid=12",API_HOST1,token];
    
    WEAK_SELF();
        weakSelf.htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        if(weakSelf.htmlString == nil ||weakSelf.htmlString.length == 0){
            NSLog(@"load failed!");
        }else{
            [weakSelf.webView loadHTMLString:weakSelf.htmlString baseURL:[NSURL URLWithString:url]];
        }

    if (_webView.scrollView.mj_header.isRefreshing) {
        [_webView.scrollView.mj_header endRefreshing];
    }
}
- (void)backBtnAction{
    
    if ([responseUrl containsString:@"Personal/CutGroup"]) {
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([_webView canGoBack]) {
        if([responseUrl containsString:@"ActivityWeb/CutGroupBuy"]){
            rightBtn.hidden = YES;
        }
        [_webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"邀请好友参团" descr:@"" thumImage:nil];

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
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);
   //获取当前页面的title
    [_hud hideAnimated:YES];

    [_webView evaluateJavaScript: @"document.title" completionHandler:^(id data, NSError * _Nullable error) {
        self.title = data;
    }];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    NSLog(@"runJavaScriptConfirmPanelWithMessage:%@",message);
   
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"Redirect:%@",navigation);
   
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    [_hud hideAnimated:YES];

    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    responseUrl = navigationResponse.response.URL.absoluteString;
    if ([navigationResponse.response.URL.absoluteString containsString:@"Personal/CutGroup"]) {
        rightBtn.hidden = YES;
        decisionHandler(WKNavigationResponsePolicyAllow);
    }else if([navigationResponse.response.URL.absoluteString containsString:@"ActivityWeb/CutGroupBuy"]){
        rightBtn.hidden = NO;
        webpageUrl = navigationResponse.response.URL.absoluteString;
        decisionHandler(WKNavigationResponsePolicyAllow);
       
    }else if([navigationResponse.response.URL.absoluteString containsString:@"WeiXin/Pay"]){
        //微信支付
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];

        [[[HHMineAPI postOrder_AppPayAddrId:nil orderId:model.order_id money:nil]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    HHWXModel *model = [HHWXModel mj_objectWithKeyValues:api.Data];
                    [HHWXModel payReqWithModel:model];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else {
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
                
            }
        }];
        decisionHandler(WKNavigationResponsePolicyCancel);
       
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"MyOrder/RefundApply"]){
        //申请退款
//        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
//        HHNewApplyRefundVC *vc = [HHNewApplyRefundVC new];
//        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyAllow);

        
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"HttpError"]){
        
//        [SVProgressHUD showInfoWithStatus:@"商品已下架"];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}
#pragma mark-微信支付

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
    
}
- (void)wxPaySucesscount{
    
    HHnormalSuccessVC *vc = [HHnormalSuccessVC new];
    vc.enter_Num = 1;
    vc.title_str = @"支付成功";
    vc.discrib_str = @"";
    vc.title_label_str = @"支付成功";
    vc.backBlock = ^{
        [self loadData];
    };
    [self.navigationController pushVC:vc];
    
}

- (void)wxPayFailcount {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showErrorWithStatus:@"支付失败～"];
        
    });
}
@end

