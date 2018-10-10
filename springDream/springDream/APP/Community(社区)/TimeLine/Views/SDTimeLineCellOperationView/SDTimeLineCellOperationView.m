//
//  SDTimeLineCellOperationView.m
//  GSD_WeiXin(wechat)
//
//  Created by User on 2018/9/11.
//  Copyright © 2018年 GSD. All rights reserved.
//

#import "SDTimeLineCellOperationView.h"
#import "UIView+SDAutoLayout.h"
#import "SDTimeLineAPI.h"

@implementation SDTimeLineCellOperationView
{
    UIButton *_commentButton;
    UIButton *_shareButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _likeButton =  [self creatButtonWithTitle:@"点赞(0)" image:[UIImage imageNamed:@"tip_01"] selImage:[UIImage imageNamed:@"tip_02"] target:self selector:@selector(likeButtonAction:)];
        _commentButton =  [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"comments"] selImage:[UIImage imageNamed:@"comments"] target:self selector:@selector(commentButtonAction:)];
        _shareButton =  [self creatButtonWithTitle:@"分享" image:[UIImage imageNamed:@"share_gray"] selImage:[UIImage imageNamed:@"share_gray"] target:self selector:@selector(shareButtonAction:)];
        [self sd_addSubviews:@[ _shareButton,_commentButton,_likeButton]];

        _shareButton.sd_layout
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(45);
        CGFloat left_edge = 45/4;
        [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(left_edge, -left_edge, -left_edge, left_edge)];
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(-left_edge+5, left_edge, left_edge, -left_edge)];
        
        _commentButton.sd_layout
        .rightSpaceToView(_shareButton, 10)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(50);
        [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(left_edge, -left_edge+5, -left_edge, left_edge)];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(-left_edge+5, left_edge, left_edge, -left_edge)];
        
        
        _likeButton.sd_layout
        .rightSpaceToView(_commentButton,5)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(75);
        CGFloat left_edge1 = 75/4;
        [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(left_edge, -left_edge1+5, -left_edge, left_edge1-5)];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(-left_edge+5, left_edge1, left_edge, -left_edge1)];

    }
    return self;
}
- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;

    return btn;
}
- (void)likeButtonAction:(UIButton *)button{
    
    if (self.priseButtonClickedOperation_new) {
        self.priseButtonClickedOperation_new(button);
    }

}
- (void)commentButtonAction:(UIButton *)button{
    
    if (self.commentButtonClickedOperation_new) {
        self.commentButtonClickedOperation_new();
    }
}
- (void)shareButtonAction:(UIButton *)button{
    
    if (self.shareButtonClickedOperation_new) {
        self.shareButtonClickedOperation_new();
    }
    
}
- (void)setModel:(SDTimeLineModel *)model{
    _model = model;
    
    _likeButton.selected = model.IsPraise.boolValue;
    [_likeButton setTitle:[NSString stringWithFormat:@"点赞(%@)",model.PraiseCount] forState:UIControlStateNormal];
}
- (void)setIsPraise:(BOOL)isPraise{
    _isPraise = isPraise;
    _likeButton.selected = isPraise;
}
@end
