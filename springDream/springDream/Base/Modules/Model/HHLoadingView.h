//
//  HHLoadingView.h
//  springDream
//
//  Created by User on 2018/10/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHLoadingView : UIImageView


/**
 开始动画
 */
-(void) start;

/**
 只停止动画
 */
-(void) stop;

/**
 停止动画并隐藏
 
 @param animated 是否开启动画隐藏
 */
-(void) hideAnimated:(BOOL)animated;

/**
 实例化添加到视图上
 
 @param view 需要添加的view
 @param animated 是否启动动画
 @return WBLoadingViewHUD
 */
+(instancetype) showToView:(UIView *)view animated:(BOOL)animated;


@end
