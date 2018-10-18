//
//  HHWithdrawCell.h
//  springDream
//
//  Created by User on 2018/10/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHWithdrawCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTag;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UIButton *allMoneyBtn;
@end
