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
#import "HHGoodCategoryVC.h"
#import "HHWebVC.h"

@interface HHHomeVC ()<WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD *_hud;

}
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL isCanBack;

@end

@implementation HHHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //    [userContentController addScriptMessageHandler:self name:@"closeMe"];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];

//    [self.view addSubview:self.progressView];
//
//    [_webView addObserver:self
//               forKeyPath:@"estimatedProgress"
//                  options:NSKeyValueObservingOptionNew
//                  context:nil];
    [self loadData];
    
    [self addHeadRefresh];

    
}
- (void)loadData{
    //
        NSString  *url = [NSString stringWithFormat:@"%@/MiniPrograms/Index",API_HOST1];
        self.htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];

        if(self.htmlString == nil ||self.htmlString.length == 0){
            NSLog(@"load failed!");
        }else{
            [self.webView loadHTMLString:self.htmlString baseURL:[NSURL URLWithString:url]];
        }
    
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

//#pragma mark- KVO监听
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSString *,id> *)change
//                       context:(void *)context
//{
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//
//        self.progressView.progress = _webView.estimatedProgress;
//        // 加载完成
//        if (_webView.estimatedProgress  >= 1.0f ) {
//
//            [UIView animateWithDuration:0.25f animations:^{
//                self.progressView.alpha = 0.0f;
//                self.progressView.progress = 0.0f;
//            }];
//
//        }else{
//            self.progressView.alpha = 1.0f;
//        }
//    }
//}

#pragma mark - webView Delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

    NSLog(@"Start:%@",navigation);

//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    NSLog(@"Finish:%@",navigation);
//    [_hud hideAnimated:YES];
      [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

//    [_hud hideAnimated:YES];

    NSString *responseUrl = navigationResponse.response.URL.absoluteString;
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);

    if ([responseUrl containsString:@"orders/detail/detail"]) {
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        HHGoodDetailVC *vc = [HHGoodDetailVC new];
        vc.goodDetail_backBlock = ^{
            
        };
        vc.Id = model.Id;
        
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else if ([responseUrl containsString:@"ProductWeb/ProductDetail"]) {
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        HHGoodDetailVC *vc = [HHGoodDetailVC new];
        vc.goodDetail_backBlock = ^{
            
        };
        vc.Id = model.Id;
        
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"ProductWeb/Search?name"]) {
        //搜素
        HHGoodListVC *vc = [HHGoodListVC new];

        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        NSString *string3 = [model.Name stringByRemovingPercentEncoding];
        vc.name = string3;
        vc.enter_Type = HHenter_category_Type;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else if ([responseUrl containsString:@"Search?categoryId"]) {
        //分类
        HJUser *user = [HJUser sharedUser];
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        user.categoryId = model.categoryId;
        [user write];
        self.navigationController.tabBarController.selectedIndex = 1;
        
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"MiniPrograms/Index"]) {
        //当前页
        decisionHandler(WKNavigationResponsePolicyAllow);

    }else if ([responseUrl containsString:@"Personal/MallDiscountCoupon"]) {
        //优惠券
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"优惠券";
        vc.url_str = responseUrl;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"Personal/CollageGoods"]) {
        //拼团
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"拼团";
        vc.url_str = responseUrl;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"Personal/LowerPriceGroup"]) {
        //降价团
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"降价团";
        vc.url_str = responseUrl;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"Personal/Seckill"]) {
        //秒杀
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"秒杀";
        vc.url_str = responseUrl;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"Personal/BargainList"]) {
        //砍价
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"砍价";
        vc.url_str = responseUrl;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else{
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
}
- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
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

