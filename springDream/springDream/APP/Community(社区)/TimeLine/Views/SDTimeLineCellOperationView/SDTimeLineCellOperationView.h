//
//  SDTimeLineCellOperationView.h
//  GSD_WeiXin(wechat)
//
//  Created by User on 2018/9/11.
//  Copyright © 2018年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTimeLineModel.h"

@interface SDTimeLineCellOperationView : UIView
{
    UIButton *_likeButton;
}
@property (nonatomic, copy) void (^priseButtonClickedOperation_new)(UIButton *button);
@property (nonatomic, copy) void (^commentButtonClickedOperation_new)();
@property (nonatomic, copy) void (^shareButtonClickedOperation_new)();

@property (nonatomic, strong) SDTimeLineModel *model;
@property (nonatomic, assign) BOOL isPraise;

@end
