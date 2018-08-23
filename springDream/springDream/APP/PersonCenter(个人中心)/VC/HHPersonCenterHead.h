//
//  HHPersonCenterHead.h
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPaoMaView.h"

@interface HHPersonCenterHead : UIView

- (instancetype)initWithFrame:(CGRect)frame notice_title:(NSString *)notice_title;

/**
 背景图
 */
@property(nonatomic,strong) UIImageView *bg_imageV;
/**
 消息按钮
 */
@property(nonatomic,strong) UIButton *message_button;
/**
 头像
 */
@property(nonatomic,strong) UIImageView *icon_view;
/**
 会员标签
 */
@property(nonatomic,strong) UILabel *vip_label;
/**
 姓名
 */
@property(nonatomic,strong) UILabel *name_label;
/**
 消费金额
 */
@property(nonatomic,strong) UILabel *consumption_amount_label;
/**
 签到按钮
 */
@property(nonatomic,strong) UIButton *sign_button;

/**
 通知背景条
 */
@property(nonatomic,strong) UIView *notice_bgV;

/**
 通知滚动条
 */
@property(nonatomic,strong) LSPaoMaView *paoma_view;
/**
 通知图标
 */
@property(nonatomic,strong) UIImageView *notice_icon;


@end
