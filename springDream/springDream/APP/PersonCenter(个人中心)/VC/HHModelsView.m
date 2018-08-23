//
//  HHModelsView.m
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHModelsView.h"
#import "UIView+Badge.h"

@implementation HHModelsView

+ (instancetype)createModelViewWithFrame:(CGRect)frame btn_image_arr:(NSArray *)btn_image_arr btn_title_arr:(NSArray *)btn_title_arr title_color:(UIColor *)title_color  lineCount:(NSInteger)lineCount{
    
    return [self createModelViewWithFrame:frame btn_image_arr:btn_image_arr btn_title_arr:btn_title_arr title_color:title_color lineCount:lineCount message_arr:@[] title_image_padding:5 top_padding:5];

}

//含角标
+ (instancetype)createModelViewWithFrame:(CGRect)frame btn_image_arr:(NSArray *)btn_image_arr btn_title_arr:(NSArray *)btn_title_arr title_color:(UIColor *)title_color  lineCount:(NSInteger)lineCount message_arr:(NSArray *)message_arr title_image_padding:(CGFloat)title_image_padding top_padding:(CGFloat)top_padding{
    
    HHModelsView *models_view = [[HHModelsView alloc] initWithFrame:frame];
    
    CGFloat imagW = 60;
    CGFloat imagH = 60;
    CGFloat margin = (ScreenW-btn_title_arr.count*imagW)/(btn_title_arr.count+1);
    
    for (NSInteger i = 0; i < btn_image_arr.count;i++) {
        
        CGFloat imageX = i*(imagW+margin)+margin;
        CGFloat imageY = top_padding;
        XYQButton *model_btn  = [XYQButton ButtonWithFrame:CGRectMake(imageX, imageY, imagW, imagH) imgaeName:btn_image_arr[i] titleName:btn_title_arr[i] contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:APP_COMMON_COLOR fontsize:11] title_img_padding:title_image_padding tapAction:^(XYQButton *button) {
            [models_view modelButtonSelectWithIndex:i];
        }];
        if (message_arr.count>0) {
            NSString *message_count = message_arr[i];
            if (message_count.integerValue>0) {
                [model_btn  yee_MakeBadgeText:message_count textColor:[UIColor redColor] backColor:[UIColor whiteColor] Font:[UIFont systemFontOfSize:11]];
            }
        }
        [model_btn setTitleColor:title_color forState:UIControlStateNormal];
        [models_view addSubview:model_btn];
        
    }
    
    
    return models_view;
    
}
- (void)modelButtonSelectWithIndex:(NSInteger)index{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(modelButtonDidSelectWithButtonIndex:)]) {
        [self.delegate modelButtonDidSelectWithButtonIndex:index];
    }
    
}
@end
