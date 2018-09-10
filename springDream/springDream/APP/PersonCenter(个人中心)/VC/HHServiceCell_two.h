//
//  HHServiceCell_two.h
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHModelsView.h"

@interface HHServiceCell_two : UITableViewCell<HHModelsViewDelegate>
@property(nonatomic,strong)  UINavigationController *nav;
- (void)setUserIcon:(NSString *)userIcon setAccount:(NSString *)account;
@end
