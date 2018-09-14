//
//  HHDistributeStatusCell.h
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"

@interface HHDistributeStatusCell : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,strong)  UINavigationController *nav;

@property(nonatomic,strong)  NSArray *message_arr;

@property(nonatomic,strong)  HHModelsView *models_view;

@property(nonatomic,strong)  NSArray *btn_image_arr;

@property(nonatomic,strong)  NSArray *btn_title_arr;


@end
