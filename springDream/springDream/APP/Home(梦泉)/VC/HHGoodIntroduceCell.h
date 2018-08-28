//
//  HHGoodIntroduceCell.h
//  springDream
//
//  Created by User on 2018/8/23.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void (^ReloadBlock)();

@interface HHGoodIntroduceCell : UITableViewCell<UIWebViewDelegate>

@property (strong , nonatomic)UIWebView *wkWebView;

@property(nonatomic,copy)ReloadBlock reloadBlock;

@property (nonatomic, strong)  HHgooodDetailModel *model;

+(CGFloat)cellHeight;

@end
