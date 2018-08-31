//
//  HHNewApplyFundHeadView.m
//  springDream
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHNewApplyFundHeadView.h"

@implementation HHNewApplyFundHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //全部 有图 追评
        NSArray *titles = @[@"申请退货",@"退货中",@"退货完成"];
        for (NSInteger i=0; i<3; i++) {
            XYQButton  *btn = [XYQButton ButtonWithFrame:CGRectMake((ScreenW-210)/6+i*(70+(ScreenW-210)/3),15, 70, 90) imgaeName:@"p_01" titleName:titles[i] contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:KTitleLabelColor fontsize:13] tapAction:nil];
            [btn setImage:[UIImage imageNamed:@"p_02"] forState:UIControlStateSelected];
            [btn setTitleColor:APP_COMMON_COLOR forState:UIControlStateSelected];
            btn.tag = 10000+i;
            [self addSubview:btn];
            if (i<2) {
                UIView *line = [UIView lh_viewWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)-15, 15, 100, 1) backColor:RGB(173, 0, 14)];
                line.centerY = btn.centerY-5;
                [self addSubview:line];
            }
        }
    }
    
    return self;
}
- (void)setCurrentSelectBtn_index:(NSInteger)currentSelectBtn_index{
    _currentSelectBtn_index = currentSelectBtn_index;
    UIButton *btn = [self viewWithTag:currentSelectBtn_index+10000];
    btn.selected = YES;
    
}
@end
