//
//  HHdelegateServiceCell.h
//  springDream
//
//  Created by User on 2018/10/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"

@protocol HHdelegateServiceCell_delagete<NSObject>

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell;

@end

@interface HHdelegateServiceCell : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,strong)  NSArray *message_arr;

@property(nonatomic,strong)  HHModelsView *models_view;

@property(nonatomic,strong)  NSArray *btn_image_arr;

@property(nonatomic,strong)  NSArray *btn_title_arr;

@property(nonatomic,weak) id<HHdelegateServiceCell_delagete>delegate;

@end
