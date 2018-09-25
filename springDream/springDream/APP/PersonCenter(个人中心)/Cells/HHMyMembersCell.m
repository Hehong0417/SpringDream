//
//  HHMyMembersCell.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyMembersCell.h"

@implementation HHMyMembersCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.icon_imagV lh_setRoundImageViewWithBorderWidth:1 borderColor:APP_COMMON_COLOR];
}

- (void)setTitle_str:(NSString *)title_str{
    
    _title_str = title_str;
    if ([title_str isEqualToString:@"我的分销商"]) {
        self.detail_label.hidden = YES;
        self.topAlig_constant.constant = 15;
    }else if ([title_str isEqualToString:@"我的代理"]){
        self.detail_label.hidden = YES;
        self.topAlig_constant.constant = 15;
    }else if ([title_str isEqualToString:@"我的会员"]){
        self.detail_label.hidden = NO;
        self.topAlig_constant.constant = 3;
    }else if ([title_str isEqualToString:@"下级会员"]){
        self.detail_label.hidden = YES;
        self.topAlig_constant.constant = 15;
    }
    
}
@end
