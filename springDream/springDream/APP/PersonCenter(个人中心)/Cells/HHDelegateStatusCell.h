//
//  HHDelegateStatusCell.h
//  springDream
//
//  Created by User on 2018/9/26.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HHModelsView.h"

@class HHDelegateStatusCell;

@protocol HHDelegateStatusCellDelagete<NSObject>

- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex StatusCell:(HHDelegateStatusCell *)cell;

@end

@interface HHDelegateStatusCell : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,strong)  NSArray *message_arr;

@property(nonatomic,strong)  HHModelsView *models_view;

@property(nonatomic,strong)  NSArray *btn_image_arr;

@property(nonatomic,strong)  NSArray *btn_title_arr;

@property(nonatomic,weak) id<HHDelegateStatusCellDelagete>delegate;

@end
