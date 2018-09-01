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
-(void)setItem_model:(HHproducts_item_Model *)item_model{
    
    _item_model = item_model;
    if (item_model.product_item_status.integerValue == 2) {
        //申请退款
        _currentSelectBtn_index = 0;
        UIButton *btn0 = [self viewWithTag:_currentSelectBtn_index+10000];
        [btn0 setTitle:@"申请退款" forState:UIControlStateNormal];
        btn0.selected = YES;
        UIButton *btn1 = [self viewWithTag:1+10000];
        [btn1 setTitle:@"退款中" forState:UIControlStateNormal];
        UIButton *btn2 = [self viewWithTag:2+10000];
        [btn2 setTitle:@"退款完成" forState:UIControlStateNormal];
        
    }else if (item_model.product_item_status.integerValue == 3) {
        //申请退货
        _currentSelectBtn_index = 0;
        UIButton *btn0 = [self viewWithTag:_currentSelectBtn_index+10000];
        [btn0 setTitle:@"申请退货" forState:UIControlStateNormal];
        btn0.selected = YES;
        UIButton *btn1 = [self viewWithTag:1+10000];
        [btn1 setTitle:@"退货中" forState:UIControlStateNormal];
        UIButton *btn2 = [self viewWithTag:2+10000];
        [btn2 setTitle:@"退货完成" forState:UIControlStateNormal];
        
    }else if (item_model.product_item_status.integerValue == 6) {
        //退款中
        _currentSelectBtn_index = 1;
        UIButton *btn0 = [self viewWithTag:10000];
        [btn0 setTitle:@"申请退款" forState:UIControlStateNormal];
        UIButton *btn1 = [self viewWithTag:_currentSelectBtn_index+10000];
        [btn1 setTitle:@"退款中" forState:UIControlStateNormal];
        btn1.selected = YES;
        UIButton *btn2 = [self viewWithTag:2+10000];
        [btn2 setTitle:@"退款完成" forState:UIControlStateNormal];
        
    }else if (item_model.product_item_status.integerValue == 7) {
        //退货中
        _currentSelectBtn_index = 1;
        UIButton *btn0 = [self viewWithTag:10000];
        [btn0 setTitle:@"申请退货" forState:UIControlStateNormal];
        UIButton *btn1 = [self viewWithTag:_currentSelectBtn_index+10000];
        [btn1 setTitle:@"退货中" forState:UIControlStateNormal];
        btn1.selected = YES;
        UIButton *btn2 = [self viewWithTag:2+10000];
        [btn2 setTitle:@"退货完成" forState:UIControlStateNormal];
        
    }else if (item_model.product_item_status.integerValue == 9) {
        //已退款
        _currentSelectBtn_index = 2;
        UIButton *btn0 = [self viewWithTag:10000];
        [btn0 setTitle:@"申请退款" forState:UIControlStateNormal];
        UIButton *btn1 = [self viewWithTag:1+10000];
        [btn1 setTitle:@"退款中" forState:UIControlStateNormal];
        UIButton *btn2 = [self viewWithTag:_currentSelectBtn_index+10000];
        [btn2 setTitle:@"退款完成" forState:UIControlStateNormal];
        btn2.selected = YES;

    }else if (item_model.product_item_status.integerValue == 10) {
        //已退货
        _currentSelectBtn_index = 2;
        UIButton *btn0 = [self viewWithTag:10000];
        [btn0 setTitle:@"申请退货" forState:UIControlStateNormal];
        UIButton *btn1 = [self viewWithTag:1+10000];
        [btn1 setTitle:@"退货中" forState:UIControlStateNormal];
        UIButton *btn2 = [self viewWithTag:_currentSelectBtn_index+10000];
        [btn2 setTitle:@"退货完成" forState:UIControlStateNormal];
        btn2.selected = YES;
    }

}

@end
