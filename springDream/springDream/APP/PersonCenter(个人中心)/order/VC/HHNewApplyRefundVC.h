//
//  HHNewApplyRefundVC.h
//  springDream
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewApplyRefundDelegate <NSObject>

- (void)backActionWithBtn:(UIButton *)btn;

@end

@interface HHNewApplyRefundVC : UITableViewController

@property (nonatomic, strong) NSString *title_str;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) HHproducts_item_Model *item_model;

@property(nonatomic,copy) id<NewApplyRefundDelegate> delegate;

@end
