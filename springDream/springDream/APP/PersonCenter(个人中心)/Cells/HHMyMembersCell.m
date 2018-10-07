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
    self.price_label.font = FONT(13);
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
- (void)setBusiness_model:(HHMineModel *)business_model{
    
    _business_model = business_model;
    [self.icon_imagV sd_setImageWithURL:[NSURL URLWithString:business_model.HeadLogo] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.name_label.text = business_model.Name;
    self.price_label.text = [NSString stringWithFormat:@"手机号:%@",business_model.Phone?business_model.Phone:@"暂未提供"];
   
}
- (void)setDelegate_business_model:(HHMineModel *)delegate_business_model{
    _delegate_business_model = delegate_business_model;
    [self.icon_imagV sd_setImageWithURL:[NSURL URLWithString:delegate_business_model.icon]];
    
    self.name_label.text = delegate_business_model.Name;
    self.price_label.text = [NSString stringWithFormat:@"手机号:%@",delegate_business_model.mobile?delegate_business_model.mobile:@"暂未提供"];
    
}
- (void)setJunior_member_model:(HHMineModel *)junior_member_model{
    _junior_member_model = junior_member_model;
    self.name_label.text = junior_member_model.Name;
    [self.icon_imagV sd_setImageWithURL:[NSURL URLWithString:junior_member_model.HeadLogo] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.price_label.text = [NSString stringWithFormat:@"消费:%@",junior_member_model.BuyTotal?junior_member_model.BuyTotal:@"0.00"];
}
- (void)setDelegate_member_model:(HHMineModel *)delegate_member_model{
    
    _delegate_member_model = delegate_member_model;
    self.name_label.text = delegate_member_model.Name;
    [self.icon_imagV sd_setImageWithURL:[NSURL URLWithString:delegate_member_model.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.price_label.text = [NSString stringWithFormat:@"消费:%@",delegate_member_model.BuyTotal?delegate_member_model.BuyTotal:@"0.00"];
    self.detail_label.text = [NSString stringWithFormat:@"手机号:%@",delegate_member_model.mobile?delegate_member_model.mobile:@"暂未提供"];
}

@end
