//
//  HHIntegralRankCell.h
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHIntegralRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *rank_button;
@property (weak, nonatomic) IBOutlet UILabel *rank_label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *integral_label;

@property (strong, nonatomic)  HHMineModel *integral_model;


@end
