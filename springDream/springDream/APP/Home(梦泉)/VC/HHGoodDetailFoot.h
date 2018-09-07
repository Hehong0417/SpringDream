//
//  HHGoodDetailFoot.h
//  springDream
//
//  Created by User on 2018/9/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReloadBlock)(void);

@interface HHGoodDetailFoot : UIView<UIWebViewDelegate>

@property (strong ,nonatomic)UIWebView *wkWebView;

@property(nonatomic,copy)ReloadBlock reloadBlock;

@property (nonatomic,copy)  HHgooodDetailModel *model;

+(CGFloat)cellHeight;

@end
