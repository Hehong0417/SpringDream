//
//  HHActivityModel.h
//  lw_Store
//
//  Created by User on 2018/6/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHJoinActivityModel;

@interface HHActivityModel : BaseModel
@property(nonatomic,strong) NSString *Count;
@property(nonatomic,strong) NSNumber *IsJoin;
@property(nonatomic,strong) NSNumber *Price;
@property(nonatomic,strong) NSNumber *Mode;
@property(nonatomic,strong) NSString *EndSecond;
@property(nonatomic,strong) NSNumber *IsSecKill;
@property(nonatomic,strong) NSString *StartSecond;
@property(nonatomic,strong) NSString *LimitCount;
@property(nonatomic,strong) NSArray <HHJoinActivityModel *>*JoinActivity;
@property(nonatomic,strong) NSString *UserJoinCount;

@end
@interface HHJoinActivityModel : BaseModel

//正在拼团列表
@property(nonatomic,strong) NSString *ActivityId;
@property(nonatomic,strong) NSString *UserName;
@property(nonatomic,strong) NSString *UserImage;
@property(nonatomic,strong) NSString *LackCount;

@end
