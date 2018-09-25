//
//  HHMystoreCell.h
//  springDream
//
//  Created by User on 2018/9/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMystoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *store_icon;
@property (weak, nonatomic) IBOutlet UILabel *store_name_label;
@property (weak, nonatomic) IBOutlet UILabel *store_address_label;
@property (weak, nonatomic) IBOutlet UILabel *call_label;

@property (nonatomic, strong) HHMineModel *store_model;

@end
