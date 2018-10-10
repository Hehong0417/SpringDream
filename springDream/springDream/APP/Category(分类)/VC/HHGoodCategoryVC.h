//
//  HHGoodCategoryVC.h
//  springDream
//
//  Created by User on 2018/9/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGoodCategoryVC : UIViewController

@property(nonatomic,strong)   NSNumber *type;
@property(nonatomic,strong)   NSString *categoryId;
@property(nonatomic,strong)   NSString *name;
@property(nonatomic,strong)   NSNumber *orderby;
@property(nonatomic,assign)   HHenter_Type enter_Type;
@property(nonatomic,strong)   NSString *groupId;

@end
