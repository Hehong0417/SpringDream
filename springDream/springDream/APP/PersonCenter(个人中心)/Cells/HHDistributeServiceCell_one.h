//
//  HHDistributeServiceCell_one.h
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"

@protocol HHDistributeServiceCell_one_delagete<NSObject>

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell;

@end

@interface HHDistributeServiceCell_one : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,assign) id<HHDistributeServiceCell_one_delagete>delegate;

@property(nonatomic,strong)  NSArray *btn_image_arr;

@property(nonatomic,strong)  NSArray *btn_title_arr;

@property(nonatomic,strong)  HHModelsView *models_view;

@end
