//
//  HHHomeVC.m
//  springDream
//
//  Created by User on 2018/8/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHHomeVC.h"
#import <WebKit/WebKit.h>
#import "HHGoodDetailVC.h"
#import "HHUrlModel.h"
#import "HHGoodListVC.h"

@interface HHHomeVC ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    MBProgressHUD *_hud;
}
@end

@implementation HHHomeVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //    [userContentController addScriptMessageHandler:self name:@"closeMe"];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    [self loadData];
    
    [self addHeadRefresh];
    
}
- (void)loadData{
    //
    NSString  *url = [NSString stringWithFormat:@"%@/Home/Index",API_HOST1];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:req];
    
    [_webView loadRequest:req];
    
    if (_webView.scrollView.mj_header.isRefreshing) {
        [_webView.scrollView.mj_header endRefreshing];
    }
}
#pragma mark - 刷新控件

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    _webView.scrollView.mj_header = refreshHeader;
}

#pragma mark - webView Delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

    NSLog(@"Start:%@",navigation);

    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    NSLog(@"Finish:%@",navigation);
    [_hud hideAnimated:YES];

}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    [_hud hideAnimated:YES];

    NSString *responseUrl = navigationResponse.response.URL.absoluteString;
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);

    if ([responseUrl containsString:@"ProductDetail"]) {
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        HHGoodDetailVC *vc = [HHGoodDetailVC new];
        vc.Id = model.Id;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else if ([responseUrl containsString:@"Search"]) {
        HHGoodListVC *vc = [HHGoodListVC new];
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        vc.enter_Type = HHenter_itself_Type;
        NSString *string3 = [model.Name stringByRemovingPercentEncoding];
        vc.name = string3;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else if ([responseUrl containsString:@"Home/Index"]) {
        //当前页
        decisionHandler(WKNavigationResponsePolicyAllow);

    }else{
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
}

@end

