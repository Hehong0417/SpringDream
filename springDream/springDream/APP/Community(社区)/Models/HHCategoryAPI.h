//
//  HHCategoryAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHCategoryAPI : BaseAPI

#pragma mark - get

//获取商品分组列表
+ (instancetype)GetProductGroup;

//获取商品列表
+ (instancetype)GetProductListWithType:(NSNumber *)type storeId:(NSString *)storeId categoryId:(NSString *)categoryId name:(NSString *)name orderby:(NSNumber *)orderby page:(NSNumber *)page pageSize:(NSNumber *)pageSize  IsCommission:(NSNumber *)isCommission groupId:(NSString *)groupId;

//获取可领取优惠券列表
+ (instancetype)GetProductCouponWithpid:(NSString *)pid;

//猜你喜欢
+ (instancetype)GetAlliancesProductsWithpids:(NSString *)pids;

//获取商品分类列表
+ (instancetype)GetNewCategoryList;


//领取优惠券
+ (instancetype)postReceiveCouponWithcoupId:(NSString *)coupId;


@end
