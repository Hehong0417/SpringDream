//
//  HHActivityModel.h
//  lw_Store
//
//  Created by User on 2018/6/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHActivityModel : BaseModel
@property(nonatomic,strong) NSString *Count;
@property(nonatomic,strong) NSNumber *IsJoin;
@property(nonatomic,strong) NSNumber *Price;
@property(nonatomic,strong) NSNumber *Mode;
@property(nonatomic,strong) NSString *EndSecond;
@property(nonatomic,strong) NSNumber *IsSecKill;
@property(nonatomic,strong) NSString *StartSecond;
@property(nonatomic,strong) NSString *LimitCount;
@property(nonatomic,strong) NSArray *JoinActivity;

@end
@interface HHJoinActivityModel : BaseModel

@end
