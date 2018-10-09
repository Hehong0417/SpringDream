//
//  HHpreferentialModelCell.m
//  springDream
//
//  Created by User on 2018/9/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHpreferentialModelCell.h"
#import <Masonry/Masonry.h>

@implementation HHpreferentialModelCell
{
    UILabel *_full_redu_title_lab;
}
- (void)setModel:(HHpreferModel *)model{
    
    _model = model;
    self.tagsView.dataA = model.items;
    _full_redu_title_lab.text = model.act_name;
    [self.contentView layoutIfNeeded];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.tagsView =[[LXTagsView alloc]init];
        [self.contentView addSubview:self.tagsView];
        
        _full_redu_title_lab = [UILabel lh_labelWithFrame:CGRectZero text:self.model.act_name textColor:RGB(228, 168, 173) font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:RGB(255, 239, 239)];
        [self addSubview:_full_redu_title_lab];
        
        [self addConstaint];
        
    }
    return self;
}
- (void)addConstaint{
    
    CGFloat full_redu_w = [@"店铺优惠券" lh_sizeWithFont:FONT(12) constrainedToSize:CGSizeMake(ScreenW, 15)].width;
    _full_redu_title_lab.sd_layout
    .topSpaceToView(self, 5)
    .leftSpaceToView(self, 60)
    .heightIs(20)
    .widthIs(full_redu_w+20);
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_full_redu_title_lab.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(-5);
    }];
    
    [self setupAutoHeightWithBottomView:self.tagsView bottomMargin:5];
}

@end
