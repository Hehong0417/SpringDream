//
//  HHStoreServiceCell.h
//  springDream
//
//  Created by User on 2018/10/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"

@protocol HHStoreServiceCell_delagete<NSObject>

- (void)serviceModelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex cell:(UITableViewCell *)cell;

@end

@interface HHStoreServiceCell : UITableViewCell<HHModelsViewDelegate>

@property(nonatomic,weak) id<HHStoreServiceCell_delagete>delegate;

@property(nonatomic,strong)  NSArray *btn_image_arr;

@property(nonatomic,strong)  NSArray *btn_title_arr;

@property(nonatomic,strong)  HHModelsView *models_view;

@end
