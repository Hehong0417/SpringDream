//
//  HHDistributeStatusCell.h
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"
@class HHDistributeStatusCell;
@protocol HHDistributeStatusCellDelagete<NSObject>

- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex StatusCell:(HHDistributeStatusCell *)cell;

@end

@interface HHDistributeStatusCell : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,strong)  NSArray *message_arr;

@property(nonatomic,strong)  HHModelsView *models_view;

@property(nonatomic,strong)  NSArray *btn_image_arr;

@property(nonatomic,strong)  NSArray *btn_title_arr;

@property(nonatomic,assign) id<HHDistributeStatusCellDelagete>delegate;

@end
