//
//  HHModelsView.h
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHModelsViewDelegate<NSObject>

- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex;

@end

@interface HHModelsView : UIView


@property(nonatomic,assign) id<HHModelsViewDelegate>delegate;

/**
 创建上面是图片下面是文字的view
 @param frame  view 的 frame
 @param btn_image_arr 按钮的图片数组
 @param btn_title_arr 按钮的标题数组
 @param title_color 按钮的颜色
 @param lineCount 一行多少列
 @return modelView
 */
+ (instancetype)createModelViewWithFrame:(CGRect)frame btn_image_arr:(NSArray *)btn_image_arr btn_title_arr:(NSArray *)btn_title_arr title_color:(UIColor *)title_color  lineCount:(NSInteger)lineCount;

//含角标
+ (instancetype)createModelViewWithFrame:(CGRect)frame btn_image_arr:(NSArray *)btn_image_arr btn_title_arr:(NSArray *)btn_title_arr title_color:(UIColor *)title_color  lineCount:(NSInteger)lineCount message_arr:(NSArray *)message_arr title_image_padding:(CGFloat)title_image_padding top_padding:(CGFloat)top_padding;

@end
