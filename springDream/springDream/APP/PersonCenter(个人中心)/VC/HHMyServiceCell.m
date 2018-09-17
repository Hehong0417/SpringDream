//
//  HHMyServiceCell.m
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyServiceCell.h"

@interface HHMyServiceCell ()

@end

@implementation HHMyServiceCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        XYQButton *model_button = [XYQButton ButtonWithFrame:CGRectMake(0, 0, ScreenW/4, 95) imgaeName:@"service_12" titleName:@"会员权益" contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:kDarkGrayColor fontsize:11] title_img_padding:0 tapAction:nil];
        model_button.userInteractionEnabled = NO;
        model_button.tag = 10000;
        [self addSubview:model_button];
        }
    return self;
}
- (void)setTitle_str:(NSString *)title_str{
    _title_str = title_str;
    XYQButton *model_button = [self viewWithTag:10000];
    [model_button setTitle:title_str forState:UIControlStateNormal];
}
- (void)setImage_str:(NSString *)image_str{
    _image_str = image_str;
    XYQButton *model_button = [self viewWithTag:10000];
    [model_button setImage:[UIImage imageNamed:image_str] forState:UIControlStateNormal];

}
@end
