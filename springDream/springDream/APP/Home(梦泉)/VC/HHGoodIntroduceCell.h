//
//  HHGoodIntroduceCell.h
//  springDream
//
//  Created by User on 2018/8/23.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HHGoodIntroduceCell : UITableViewCell<WKUIDelegate,WKNavigationDelegate>

@property (strong , nonatomic)WKWebView *wkWebView;

@property (nonatomic, strong)  HHgooodDetailModel *model;

@end
