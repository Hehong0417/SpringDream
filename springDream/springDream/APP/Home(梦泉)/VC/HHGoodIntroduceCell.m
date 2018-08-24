//
//  HHGoodIntroduceCell.m
//  springDream
//
//  Created by User on 2018/8/23.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodIntroduceCell.h"

@implementation HHGoodIntroduceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        self.wkWebView.scrollView.scrollEnabled = NO;
        self.wkWebView.UIDelegate = self;
        self.wkWebView.backgroundColor = kClearColor;
        self.wkWebView.navigationDelegate = self;
        [self.contentView addSubview:self.wkWebView];
        
        [self setupAutoHeightWithBottomView:self.wkWebView bottomMargin:30];

        self.wkWebView.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,5)
        .rightSpaceToView(self.contentView,10)
        .heightIs(200);
    }
    
    return self;
}
- (void)setModel:(HHgooodDetailModel *)model{
    
    _model = model;
    
    /*- 在加载网页时添加代码 -*/
    // 手动改变图片适配问题，拼接html代码后，再加载html代码
    NSString *myStr = [NSString stringWithFormat:@"<head><style>img{max-    width:%f !important;}</style></head>", [UIScreen mainScreen].bounds.size.width - 20];
    NSString *str = [NSString stringWithFormat:@"%@%@",myStr,model.Description?model.Description:@""];
    [self.wkWebView loadHTMLString:str baseURL:nil];
    /*- 在加载网页时添加代码 -*/
  
}

@end
