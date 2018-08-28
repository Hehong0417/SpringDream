//
//  HHGoodIntroduceCell.m
//  springDream
//
//  Created by User on 2018/8/23.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodIntroduceCell.h"

static CGFloat staticheight = 0;

@implementation HHGoodIntroduceCell

+(CGFloat)cellHeight
{
    return staticheight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bg_view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 20) backColor:KVCBackGroundColor];
        [self.contentView addSubview:bg_view];
        UIImageView *bg_imgV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, 20)image:[UIImage imageNamed:@"segmentation"]];
        bg_imgV.contentMode = UIViewContentModeCenter;
        [bg_view addSubview:bg_imgV];

        self.wkWebView.scrollView.scrollEnabled = NO;
        self.wkWebView.delegate = self;
        self.wkWebView.backgroundColor = kClearColor;
        [self.contentView addSubview:self.wkWebView];
        
 
    }
    
    return self;
}
- (void)setModel:(HHgooodDetailModel *)model{
    
    _model = model;
    NSLog(@"Description:%@",model.Description);
    if (model.Description.length>0) {
        NSString *content = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}p{font-size:16px}</style></head>%@",SCREEN_WIDTH-16,model.Description];
        [self.wkWebView loadHTMLString:content baseURL:nil];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    document.body.offsetHeight
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight"] floatValue]+20;
    self.wkWebView.frame = CGRectMake(0, 20, ScreenW, height);
    self.wkWebView.hidden = NO;
    if (staticheight != height+1) {
        staticheight = height+1;
        if (staticheight > 0) {
            if (_reloadBlock) {
                _reloadBlock();
            }
        }
    }

}
- (UIWebView *)wkWebView{
    
    if (!_wkWebView) {
        _wkWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 20, ScreenW, 0)];
        _wkWebView.userInteractionEnabled = NO;
        _wkWebView.hidden = YES;
    }
    return _wkWebView;
    
}

@end
