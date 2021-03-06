//
//  SDTimeLineCellCommentView.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineCellCommentView.h"
#import "UIView+SDAutoLayout.h"
//#import "SDTimeLineCellModel.h"
#import "MLLinkLabel.h"
#import "SDTimeLineModel.h"

@interface SDTimeLineCellCommentView () <MLLinkLabelDelegate>

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;


@end

@implementation SDTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];

    }
    return self;
}

- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg_01"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _allComment_btn = [UIButton lh_buttonWithFrame:CGRectZero target:self action:@selector(allComment_btnAction) title:@"查看全部" titleColor:APP_NAV_COLOR font:FONT(11) backgroundColor:kClearColor];
    [self addSubview:_allComment_btn];
    
    _likeLableBottomLine = [UIView new];
    [self addSubview:_likeLableBottomLine];
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setCommentItemsArray:(NSArray <SDTimeLineCellCommentItemModel *>*)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = [UIColor colorWithRed:251/255.0 green:75/255.0 blue:77/255.0 alpha:1];
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.activeLinkTextAttributes = @{NSForegroundColorAttributeName : highLightColor,NSBackgroundColorAttributeName:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        SDTimeLineCellCommentItemModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        UIColor *highLightColor = [UIColor colorWithRed:251/255.0 green:75/255.0 blue:77/255.0 alpha:1];
        label.activeLinkTextAttributes = @{NSForegroundColorAttributeName : highLightColor,NSBackgroundColorAttributeName:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]};
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
        }
        label.attributedText = model.attributedContent;
    }
}
- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray <SDTimeLineCellCommentItemModel *>*)commentItemsArray
{
    
//    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
        [_allComment_btn sd_clearAutoLayoutSettings];
        _allComment_btn.hidden = YES;
    }
//    if (!commentItemsArray.count && !likeItemsArray.count)
    if (!commentItemsArray.count) {
        self.fixedWidth = @(0); // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
    }
    
//    CGFloat margin = 5;
    
    UIView *lastTopView = nil;
    
     if (self.commentItemsArray.count) {
        _likeLableBottomLine.sd_resetLayout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(0)
        .topSpaceToView(lastTopView, 6);
        
        lastTopView = _likeLableBottomLine;
    } else {
        _likeLableBottomLine.sd_resetLayout.heightIs(0);
    }

    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        CGFloat topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 5;
        label.sd_layout
        .leftSpaceToView(self, 8)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, topMargin)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    if (self.commentItemsArray.count>=5) {
        _allComment_btn.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(lastTopView, 0)
        .heightIs(20);
        lastTopView = _allComment_btn;
        _allComment_btn.hidden = NO;
    }else{
        [_allComment_btn sd_clearAutoLayoutSettings];
        _allComment_btn.hidden = YES;
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(SDTimeLineCellCommentItemModel *)model
{
    NSString *text = @"无名字";
    if (model.UserName) {
        text = model.UserName;
    }
//    if (model.secondUserName.length) {
//        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
//    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.Comment]];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.UserId} range:[text rangeOfString:model.UserName?model.UserName:@"无名字"]];

//    if (model.secondUserName) {
//        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
//    }
    return attString;
}

//- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(SDTimeLineCellLikeItemModel *)model
//{
//    NSString *text = model.userName;
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
//    UIColor *highLightColor = [UIColor blueColor];
//    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
//
//    return attString;
//}

- (void)allComment_btnAction{
    
    if (self.didClickAllButtonBlock) {
        self.didClickAllButtonBlock();
    }
    
}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"ClicklinkValue:%@,linkText:%@,linkLabel:%@", link.linkValue,linkText,linkLabel);
    
    
}

@end
