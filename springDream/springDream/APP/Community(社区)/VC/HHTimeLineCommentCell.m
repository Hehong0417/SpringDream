//
//  HHTimeLineCommentCell.m
//  springDream
//
//  Created by User on 2018/10/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHTimeLineCommentCell.h"

@implementation HHTimeLineCommentCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}
- (void)setup{
    
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont boldSystemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_nameLable];
    [self.contentView addSubview:_contentLabel];
    
    [self addConstraint];

}
- (void)addConstraint{
    
    UIView *contentView = self.contentView;
    CGFloat margin = 15;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    [_iconView lh_setRoundImageViewWithBorderWidth:1 borderColor:APP_NAV_COLOR];

    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .centerYEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, 8)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:15];

}
- (void)setModel:(SDTimeLineCellCommentItemModel *)model{
    
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.UserImage] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    _contentLabel.text = model.Comment;
    _nameLable.text = model.UserName;
}
@end
