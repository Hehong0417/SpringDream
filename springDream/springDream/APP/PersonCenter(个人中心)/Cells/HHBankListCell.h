//
//  HHBankListCell.h
//  springDream
//
//  Created by User on 2018/10/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBankListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bank_name_label;
@property (weak, nonatomic) IBOutlet UILabel *bank_numer_label;
@property (strong, nonatomic)  HHMineModel *model;

@end
