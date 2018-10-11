//
//  HHPayTypeVC.h
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHSubmitOrderTool.h"

@protocol payTypeDelegate <NSObject>

- (void)commitActionWithBtn:(UIButton *)btn selectIndex:(NSInteger)selectIndex;

- (void)commitActionWithBtn:(UIButton *)btn selectIndex:(NSInteger)selectIndex select_model:(HHcouponsModel *)model total_money:(CGFloat )total_money submitOrderTool:(HHSubmitOrderTool *)submitOrderTool couponCell:(UITableViewCell *)couponCell lastConponValue:(CGFloat)lastConponValue last_total_money:(CGFloat)last_total_money;

@end
@interface HHPayTypeVC : UITableViewController

@property(nonatomic,weak) id<payTypeDelegate> delegate;
@property(nonatomic,copy) NSString *title_str;//标题
@property(nonatomic,copy) NSString *subtitle_str;//副标题
@property(nonatomic,copy) NSString *btn_title;

@property(nonatomic,strong) NSArray <HHcouponsModel *>*coupons;
@property(nonatomic,copy) NSString *total_money;
@property (nonatomic, strong)   HHSubmitOrderTool *submitOrderTool;
@property (nonatomic, strong)   UITableViewCell *couponCell;
@end
