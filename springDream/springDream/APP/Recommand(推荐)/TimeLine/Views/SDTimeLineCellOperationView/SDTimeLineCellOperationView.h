//
//  SDTimeLineCellOperationView.h
//  GSD_WeiXin(wechat)
//
//  Created by User on 2018/9/11.
//  Copyright © 2018年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTimeLineCellOperationView : UIView

@property (nonatomic, copy) void (^commentButtonClickedOperation_new)();
@property (nonatomic, copy) void (^shareButtonClickedOperation_new)();

@end
