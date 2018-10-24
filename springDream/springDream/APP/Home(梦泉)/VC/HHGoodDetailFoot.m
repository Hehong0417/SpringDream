//
//  HHGoodDetailFoot.m
//  springDream
//
//  Created by User on 2018/9/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodDetailFoot.h"

static CGFloat staticheight = 0;

@implementation HHGoodDetailFoot

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        
        UIView *bg_view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 25) backColor:KVCBackGroundColor];
        [self addSubview:bg_view];
        UIImageView *bg_imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, 25)image:[UIImage imageNamed:@"segmentation"]];
        bg_imgV.contentMode = UIViewContentModeCenter;
        [bg_view addSubview:bg_imgV];

        self.wkWebView.scrollView.scrollEnabled = NO;
        self.wkWebView.delegate = self;
        self.wkWebView.backgroundColor = kWhiteColor;
        [self addSubview:self.wkWebView];
    }
    
    return self;
}
+ (CGFloat)cellHeight
{
    return staticheight;
}

- (void)setModel:(HHgooodDetailModel *)model{
    
    _model = model;
    NSLog(@"Description:%@",model.Description);
    if (model.Description.length>0) {
//        NSMutableString *nsm_str = [[NSMutableString alloc] initWithString:model.Description];
//        NSString *oc_str = @"iframe style=""width:100%; height:220px"" src";
//        NSString *Description =   [nsm_str stringByReplacingOccurrencesOfString:@"iframe src" withString:oc_str];
        
        NSString *content = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}p{font-size:16px}iframe{ width:%f;height:220px}</style></head>%@",SCREEN_WIDTH+5,SCREEN_WIDTH+5,model.Description];

        [self.wkWebView loadHTMLString:content baseURL:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // document.body.offsetHeight
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue]+45;
    self.wkWebView.frame = CGRectMake(-10, 45, ScreenW+30, height);
    self.wkWebView.hidden = NO;
    staticheight = height+1;
     if (_reloadBlock) {
            _reloadBlock();
        }
}
- (UIWebView *)wkWebView{
    
    if (!_wkWebView) {
        _wkWebView =[[UIWebView alloc]initWithFrame:CGRectMake(-10, 45, ScreenW+30, 0)];
        _wkWebView.userInteractionEnabled = YES;
        _wkWebView.hidden = YES;
    }
    return _wkWebView;
    
}
@end
