//
//  HHpreferIntegralCell.m
//  springDream
//
//  Created by User on 2018/10/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHpreferIntegralCell.h"
#import <Masonry/Masonry.h>

@implementation HHpreferIntegralCell
{
    UILabel *_full_redu_title_lab;
    UILabel *_integral_title_lab;
}
- (void)setModel:(HHpreferModel *)model{
    
    _model = model;
    _full_redu_title_lab.text = model.act_name;
    NSString *integral = model.items[0];
    NSString *content = [NSString stringWithFormat:@"购买得%.2f积分",integral.doubleValue];
    NSString *protocolStr =[NSString stringWithFormat:@"%.2f",integral.doubleValue];
    _integral_title_lab.attributedText = [NSString lh_attriStrWithprotocolStr:protocolStr content:content protocolStrColor:APP_NAV_COLOR contentColor:KTitleLabelColor commonFont:FONT(12)];
    [self.contentView layoutIfNeeded];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _full_redu_title_lab = [UILabel lh_labelWithFrame:CGRectZero text:self.model.act_name textColor:RGB(228, 168, 173) font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:RGB(255, 239, 239)];
        [self addSubview:_full_redu_title_lab];
        _integral_title_lab = [UILabel lh_labelWithFrame:CGRectZero text:self.model.act_name textColor:RGB(228, 168, 173) font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [self addSubview:_integral_title_lab];
        
        [self addConstaint];
        
    }
    return self;
}
- (void)addConstaint{
    
    CGFloat full_redu_w = [@"店铺" lh_sizeWithFont:FONT(12) constrainedToSize:CGSizeMake(ScreenW, 15)].width;
    CGFloat w = [@"好店铺" lh_sizeWithFont:FONT(12) constrainedToSize:CGSizeMake(ScreenW, 15)].width;
    
    _full_redu_title_lab.sd_layout
    .topSpaceToView(self, 5)
    .leftSpaceToView(self, 60+w)
    .heightIs(20)
    .widthIs(full_redu_w+20);
    

    _integral_title_lab.sd_layout
    .topSpaceToView(self, 5)
    .leftSpaceToView(_full_redu_title_lab, 15)
    .heightIs(20)
    .widthIs(200);
    
    [self setupAutoHeightWithBottomView:_full_redu_title_lab bottomMargin:5];
}

@end
