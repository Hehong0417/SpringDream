//
//  HHOrderStatusCell.h
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"

@interface HHOrderStatusCell : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,strong)  UINavigationController *nav;

@property(nonatomic,strong)  NSArray *message_arr;


@end
