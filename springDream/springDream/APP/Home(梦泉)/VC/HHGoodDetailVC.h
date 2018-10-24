//
//  HHGoodDetailVC.h
//  springDream
//
//  Created by User on 2018/8/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGoodDetailVC : UITableViewController

@property(nonatomic,strong) NSString *Id;

@property(nonatomic,copy)  voidBlock goodDetail_backBlock;

/* 通知 */
@property (weak ,nonatomic) id dcObj;

/* 删除加入购物车和立即购买的通知 */
@property (weak ,nonatomic) id deleteDcObj;

@end
