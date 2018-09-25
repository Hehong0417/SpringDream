//
//  HHPersonCenterHead.m
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterHead.h"
#import "HHCommonSetVC.h"

@implementation HHPersonCenterHead

- (instancetype)initWithFrame:(CGRect)frame notice_title:(NSString *)notice_title{
    
    if (self = [super initWithFrame:frame]) {
        
        //背景图
        self.bg_imageV = [UIImageView new];
        self.bg_imageV.backgroundColor = RGB(249, 233, 233);
        self.bg_imageV.image = [UIImage imageNamed:@"person_bg"];
        [self addSubview:self.bg_imageV];
        //消息按钮  --msg
        self.message_button = [UIButton lh_buttonWithFrame:CGRectZero target:self action:@selector(message_buttonAction:) image:[UIImage imageNamed:@"service_14"]];
        [self addSubview:self.message_button];
        //头像
        self.icon_view = [UIImageView new];
        self.icon_view.backgroundColor = KVCBackGroundColor;
        self.icon_view.image = [UIImage imageNamed:@"t4_selected"];
        [self addSubview:self.icon_view];
        self.icon_view.userInteractionEnabled = YES;
   
        //姓名
        self.name_label = [UILabel new];
        self.name_label.font = FONT(14);
        self.name_label.text = @"梦泉";
        [self addSubview:self.name_label];
        //会员
        self.vip_label = [UILabel new];
        self.vip_label.text = @"潜力会员";
        self.vip_label.font = BoldFONT(7);
        self.vip_label.textColor = kWhiteColor;
        self.vip_label.textAlignment = NSTextAlignmentCenter;
        self.vip_label.backgroundColor = kRedColor;
        [self addSubview:self.vip_label];
        //签到
        self.sign_button = [UIButton lh_buttonWithFrame:CGRectZero target:self action:@selector(sign_buttonAction:) image:[UIImage imageNamed:@"red_right_arrow"]];
        [self.sign_button lh_setBackgroundColor:RGB(255, 223, 224) forState:UIControlStateNormal];
        [self.sign_button setTitle:@"每日签到" forState:UIControlStateNormal];
        self.sign_button.titleLabel.font = FONT(13);
        [self.sign_button setTitleColor:kRedColor forState:UIControlStateNormal];
        [self.sign_button setImageEdgeInsets:UIEdgeInsetsMake(0, 67, 0, 0)];
        [self.sign_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [self addSubview:self.sign_button];
        //消费金额
        self.consumption_amount_label = [UILabel new];
        self.consumption_amount_label.textColor = kDarkGrayColor;
        self.consumption_amount_label.text = [NSString stringWithFormat:@"消费金额：0.00"];
        self.consumption_amount_label.font = FONT(13);
        [self addSubview:self.consumption_amount_label];
        
        //通知条
        self.notice_bgV  = [UIView new];
        self.notice_bgV.backgroundColor = RGB(255, 223, 224);
//        [self addSubview:self.notice_bgV];

        self.notice_icon = [UIImageView new];
        self.paoma_view = [[LSPaoMaView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-110, 20) title:notice_title];
        self.paoma_view.backgroundColor = RGB(255, 223, 224);

        [self.notice_bgV addSubview:self.notice_icon];
        [self.notice_bgV addSubview:self.paoma_view];
      
        //添加约束
        [self addContraint];
    }
    return self;
}
- (void)addContraint{
    
    //背景图
    self.bg_imageV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    //消息按钮
    self.message_button.sd_layout.rightSpaceToView(self, 24);
    self.message_button.sd_layout.topSpaceToView(self, 35);
    self.message_button.sd_layout.widthIs(30);
    self.message_button.sd_layout.heightIs(30);
    //头像
    self.icon_view.sd_layout.widthIs(70);
    self.icon_view.sd_layout.heightIs(70);
    self.icon_view.sd_layout.centerYIs(self.centerY);
    self.icon_view.sd_layout.leftSpaceToView(self, 15);
    [self.icon_view lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];

    //姓名
    self.name_label.sd_layout.leftSpaceToView(self.icon_view, 15);
    self.name_label.sd_layout.rightSpaceToView(self, 90);
    self.name_label.sd_layout.centerYIs(self.centerY-15);
    self.name_label.sd_layout.heightIs(30);
    //会员
    self.vip_label.sd_layout.heightIs(11);
    self.vip_label.sd_layout.widthIs(35);
    self.vip_label.sd_layout.centerXIs(CGRectGetMaxX(self.icon_view.frame)+5);
    self.vip_label.sd_layout.centerYIs(self.centerY+self.icon_view.height/2-10);
    [self.vip_label lh_setCornerRadius:self.vip_label.mj_h/2 borderWidth:0 borderColor:nil];


    //消费金额
    self.consumption_amount_label.sd_layout.leftSpaceToView(self.icon_view, 15);
    self.consumption_amount_label.sd_layout.topSpaceToView(self.name_label, 5);
    self.consumption_amount_label.sd_layout.rightSpaceToView(self, 90);
    self.consumption_amount_label.sd_layout.heightIs(20);
    self.consumption_amount_label.font = FONT(13);

    //签到
    self.sign_button.sd_layout.heightIs(25);
    self.sign_button.sd_layout.widthIs(80);
    self.sign_button.sd_layout.rightSpaceToView(self, 0);
    self.sign_button.sd_layout.centerYIs(self.consumption_amount_label.centerY);
    
    //通知条
    self.notice_bgV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(self.mj_h-20, 0, 0, 0));
    
    self.notice_icon.sd_layout.heightIs(20);
    self.notice_icon.sd_layout.widthIs(20);
    self.notice_icon.sd_layout.leftSpaceToView(self.notice_bgV, 23);
    self.notice_icon.sd_layout.topSpaceToView(self.notice_icon, 0);
    
    self.paoma_view.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 55, 0, 55));

}

/**
 消息
 */
- (void)message_buttonAction:(UIButton *)message_button{
    
    HHCommonSetVC *vc = [HHCommonSetVC new];
    [self.nav pushVC:vc];
}
/**
签到
 */
- (void)sign_buttonAction:(UIButton *)sign_button{

    
}
@end
