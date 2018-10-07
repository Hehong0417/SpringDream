//
//  HHMyMembersCell.h
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMyMembersCell : UITableViewCell

@property(nonatomic,strong)   NSString *title_str;
@property (weak, nonatomic) IBOutlet UIImageView *icon_imagV;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *detail_label;
@property (weak, nonatomic) IBOutlet UILabel *price_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAlig_constant;

@property(nonatomic,strong)   HHMineModel *business_model;
@property(nonatomic,strong)   HHMineModel *delegate_business_model;
//下级会员
@property(nonatomic,strong)   HHMineModel *junior_member_model;
//代理会员
@property(nonatomic,strong)   HHMineModel *delegate_member_model;

@end
