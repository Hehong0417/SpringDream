//
//  HHEvaluationListCell.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluationListCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "HHCellCommentView.h"
#import "HHAdditionalCommentView.h"

const CGFloat contentLabelFontSize1 = 15;
//CGFloat maxContentLabelHeight1 = 0; // 根据具体font而定

@implementation HHEvaluationListCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UIImageView *_gradeEmptyImgV;
    UIImageView *_gradeImgV;
    UILabel *_timeLabel;
    UILabel *_propertyLabel;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UIButton *_operationButton;
    HHCellCommentView *_commentView;
    HHAdditionalCommentView *_additionalCommentView;
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
    [_iconView lh_setCornerRadius:18 borderWidth:0 borderColor:nil];

    _nameLable = [UILabel new];
    _nameLable.font = FONT(13);
    _nameLable.textColor = RGB(51, 51, 51);
    
//    stoke_star
    UIImage *gradeImage = [UIImage imageNamed:@""];
    _gradeEmptyImgV = [[UIImageView alloc] init];
    _gradeEmptyImgV.image = [UIImage imageNamed:@""];
    _gradeEmptyImgV.hidden = NO;
    
    
//    solid_star
    _gradeImgV = [[UIImageView alloc] init];
    _gradeImgV.contentMode = UIViewContentModeLeft;
    _gradeImgV.clipsToBounds = YES;
    _gradeImgV.image = [UIImage imageNamed:@""];
    _gradeImgV.hidden = NO;

    _timeLabel = [UILabel new];
    _timeLabel.textColor = KA0LabelColor;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _propertyLabel = [UILabel new];
    _propertyLabel.textColor = KA0LabelColor;
    _propertyLabel.font = [UIFont systemFontOfSize:13];
    _propertyLabel.textAlignment = NSTextAlignmentLeft;
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize1];
    _contentLabel.numberOfLines = 0;
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [HHCellCommentView new];
    
    _additionalCommentView = [HHAdditionalCommentView new];
    
    NSArray *views = @[_iconView, _nameLable,_gradeEmptyImgV,_gradeImgV, _contentLabel, _picContainerView, _timeLabel,_propertyLabel, _commentView,_additionalCommentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 16;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(36)
    .heightIs(36);

    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .centerYEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:100];
    
    _gradeEmptyImgV.sd_layout
    .leftSpaceToView(_nameLable, margin)
    .centerYEqualToView(_nameLable)
    .widthIs(gradeImage.size.width)
    .heightIs(gradeImage.size.height);
    
    _gradeImgV.sd_layout
    .leftSpaceToView(_nameLable, margin)
    .centerYEqualToView(_nameLable)
    .widthIs(0)
    .heightIs(gradeImage.size.height);
    
    _timeLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, margin)
    .widthIs(150)
    .heightIs(20);
    
    _propertyLabel.sd_layout
    .leftSpaceToView(_timeLabel, 10)
    .centerYEqualToView(_timeLabel)
    .widthIs(100)
    .heightIs(20);
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_timeLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 10); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_picContainerView, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    //追评
    _additionalCommentView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_commentView, 10)
    .rightSpaceToView(contentView, margin);
    
}
- (void)setModel:(HHEvaluationListModel *)model{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.userImage]];
    _nameLable.text = model.userName;
    _timeLabel.text = model.createDate;
    _propertyLabel.text = model.skuName;
    _contentLabel.text = model.content.length>0?model.content:@"此用户没有填写评价";
    _picContainerView.picPathStringsArray = model.pictures;
    
    NSInteger grade = model.describeScore.integerValue;
    UIImage *gradeImage = [UIImage imageNamed:@"stoke_star"];
    CGFloat width = gradeImage.size.width/5*grade;

    _gradeImgV.sd_resetLayout
    .leftSpaceToView(_nameLable, 16)
    .centerYEqualToView(_nameLable)
    .widthIs(width)
    .heightIs(gradeImage.size.height);
    
    [_commentView setupWithCommentItems:model.adminReply];
    
    [_additionalCommentView setupAddition_time:model.addition_time addition_comment:model.addition_comment];
    if (model.adminReply.length==0) {
        _additionalCommentView.sd_resetLayout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_picContainerView, 10)
        .rightSpaceToView(self.contentView, 10);
    }else{
        _additionalCommentView.sd_resetLayout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_commentView, 5)
        .rightSpaceToView(self.contentView, 10);
    }

    UIView *bottomView;
    if (model.addition_comment.length == 0&&model.adminReply.length==0) {
        bottomView = _picContainerView;
    }else if (model.addition_comment.length == 0&&model.adminReply.length>0){
        bottomView = _commentView;
    }else if (model.addition_comment.length>0){
        bottomView = _additionalCommentView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];

}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

@end
