//
//  HHLoadingView.m
//  springDream
//
//  Created by User on 2018/10/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHLoadingView.h"

#define LoadingWidth 106   // 默认大小

@implementation HHLoadingView

/**
 实例化添加到视图上
 
 @param view 需要添加的view
 @param animated 是否启动动画
 @return WBLoadingViewHUD
 */
+(instancetype) showToView:(UIView *)view animated:(BOOL)animated{
    
    HHLoadingView *hud = [HHLoadingView new];
    hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.00];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[HHLoadingView class]]) {
            if (!animated) {
                [(HHLoadingView *)subView stop];
            }else{
                [(HHLoadingView *)subView start];
            }
            return (HHLoadingView *)subView;
        }
    }
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    if (!animated) {
        [hud stop];
    }else {
        [hud start];
    }
    return hud;
    
}


/**
 开始动画
 */
-(void) start{
    
    [self startAnimating];
}

/**
 只停止动画
 */
-(void) stop{
    
    [self stopAnimating];
}

/**
 停止动画并隐藏
 
 @param animated 是否开启动画隐藏
 */
#pragma mark - Hidden
- (void) hideAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
            [self stop];
             self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self stop];
        [self removeFromSuperview];
    }
}
#pragma mark - Clicye Life

-(instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initializeInterface];
    }
    return self;
}
- (void)initializeInterface {
    
    if (CGRectGetWidth(self.frame) == 0 || CGRectGetHeight(self.frame) == 0) {
        self.frame = CGRectMake((ScreenW - LoadingWidth) / 2, (ScreenH - LoadingWidth) / 2-64, LoadingWidth, LoadingWidth);
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i<10; i++) {
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",i+1]]];
    }
    self.contentMode = UIViewContentModeCenter;
    self.animationImages = array; //动画图片数组
    self.animationDuration = 1; //执行一次完整动画所需的时长
    
}
@end
