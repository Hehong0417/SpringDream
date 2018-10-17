//
//  HHMydistributorsVC.h
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMydistributorsVC : UITableViewController

@property(nonatomic,strong)   NSString *title_str;

@property(nonatomic,strong)   NSNumber *few;

@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;

//代理中心的分销商，分销中心的分销商
@property(nonatomic,assign)   BOOL  isDelegateDistributors;

- (void)getUserFewFans;

@end
