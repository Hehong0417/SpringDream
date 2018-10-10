//
//  SDTimeLineCell.m
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
#define ScreenW  ([UIScreen mainScreen].bounds.size.width)

#import "SDTimeLineCell.h"

#import "UIView+SDAutoLayout.h"

#import "SDTimeLineCellCommentView.h"

#import "SDWeiXinPhotoContainerView.h"

#import "SDTimeLineCellOperationView.h"

#import "SDTimeLineModel.h"

const CGFloat contentLabelFontSize = 13;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    SDWeiXinPhotoContainerView *_picContainerView;
    UIButton *_moreButton;
    UIButton *_operationButton;
    SDTimeLineCellCommentView *_commentView;
    
    SDTimeLineCellOperationView *_peration_view;
    UIView *_line;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    _iconView = [UIImageView new];
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont boldSystemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];

    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"展开全文" forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 20)];
    [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [_moreButton setTitleColor:[UIColor colorWithRed:251/255.0 green:75/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:11];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [SDTimeLineCellCommentView new];
    
    _peration_view = [SDTimeLineCellOperationView new];
    
    __weak typeof(self) weakSelf = self;

    [_peration_view setCommentButtonClickedOperation_new:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    
    [_peration_view setShareButtonClickedOperation_new:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcShareButtonInCell:)]) {
            
            [weakSelf.delegate didClickcShareButtonInCell:weakSelf];
        }
        
    }];
    [_peration_view setPriseButtonClickedOperation_new:^(UIButton *button) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:likeButton:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf likeButton:button];
        }
    }];
    
    _line = [UIView lh_viewWithFrame:CGRectZero backColor:KVCBackGroundColor];
    
    NSArray *views = @[_iconView, _nameLable, _timeLabel,_titleLabel, _contentLabel, _moreButton, _picContainerView, _peration_view, _commentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 15;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, 9)
    .heightIs(14);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _titleLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, margin+5)
    .heightIs(15);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:320];
    
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_titleLabel, 8)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(70);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置

    _peration_view.sd_layout
    .topSpaceToView(_picContainerView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(45)
    .widthIs(ScreenW/2);
    
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_peration_view, 5); // 已经在内部实现高度自适应所以不需要再设置高度
    
    _line.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(_commentView, 8)
    .heightIs(1);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(SDTimeLineModel *)model
{
    
    _model = model;
    
    [_commentView setupWithLikeItemsArray:@[] commentItemsArray:model.ContentECSubjectCommentModel];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.UserImage] placeholderImage:[UIImage imageWithColor:KVCBackGroundColor]];
    [_iconView lh_setRoundImageViewWithBorderWidth:1 borderColor:APP_NAV_COLOR];
    _nameLable.text = model.UserName;
    _contentLabel.text = model.SubjectContent;
    _picContainerView.picPathStringsArray = model.ContentECSubjectPicModel;
    _peration_view.model = model;
    
//    [_contentLabel setLineSpace:30];

    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起全文" forState:UIControlStateNormal];
            [_moreButton setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];

        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"展开全文" forState:UIControlStateNormal];
            [_moreButton setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];

        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.ContentECSubjectPicModel.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    if (!model.ContentECSubjectCommentModel.count) {
        bottomView = _peration_view;
    } else {
        bottomView = _commentView;
    }

    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = model.UploadDateTime;
    _titleLabel.text = model.Title;
    
}
- (void)setIsPraise:(BOOL)isPraise{
    _isPraise = isPraise;
    _peration_view.isPraise = isPraise;
}
#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}
@end

