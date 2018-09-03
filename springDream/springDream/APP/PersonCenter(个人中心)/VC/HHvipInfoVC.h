//
//  HHvipInfoVC.h
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HJStaticGroupTableVC.h"

@interface HHvipInfoVC : HJStaticGroupTableVC
@property (nonatomic, strong)   NSString *userId;

@property(nonatomic,strong) HHMineModel  *mineModel;

@property(nonatomic,strong) NSString  *userLevelName;

@end
