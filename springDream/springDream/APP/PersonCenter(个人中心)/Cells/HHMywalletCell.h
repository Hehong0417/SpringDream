//
//  HHMywalletCell.h
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMywalletCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *left_title_label;
@property (weak, nonatomic) IBOutlet UILabel *left_detail_label;
@property (weak, nonatomic) IBOutlet UILabel *date_time_label;
@property (weak, nonatomic) IBOutlet UILabel *integral_label;

@property (strong, nonatomic)  HHMineModel *commission_model;

@property (strong, nonatomic)  HHMineModel *delegate_commission_model;

@property (strong, nonatomic)  HHMineModel *store_commission_model;

@property (strong, nonatomic)  HHMineModel *integral_model;

@property (strong, nonatomic)  HHMineModel *wallet_model;

@end
