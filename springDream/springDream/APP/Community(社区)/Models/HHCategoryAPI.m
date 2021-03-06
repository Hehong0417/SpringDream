//
//  HHCategoryAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCategoryAPI.h"

@implementation HHCategoryAPI

#pragma mark - get
//获取商品分组列表
+ (instancetype)GetProductGroup{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetProductGroup;
    api.parametersAddToken = NO;
    return api;
}
//获取商品列表
+ (instancetype)GetProductListWithType:(NSNumber *)type storeId:(NSString *)storeId categoryId:(NSString *)categoryId name:(NSString *)name orderby:(NSNumber *)orderby page:(NSNumber *)page pageSize:(NSNumber *)pageSize  IsCommission:(NSNumber *)isCommission groupId:(NSString *)groupId{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_Product_search;
    if (categoryId) {
        [api.parameters setObject:categoryId forKey:@"categoryId"];
    }
    if (isCommission) {
        [api.parameters setObject:isCommission forKey:@"isCommission"];
    }
    if (storeId) {
       [api.parameters setObject:storeId forKey:@"storeId"];
    }
    if (groupId) {
        [api.parameters setObject:groupId forKey:@"groupId"];
    }
    if (name) {
        [api.parameters setObject:name forKey:@"name"];
    }
    if (orderby) {
        [api.parameters setObject:orderby forKey:@"order"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    
    return api;
}


//获取商品分类列表
+ (instancetype)GetNewCategoryList{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetNewCategoryList;
    api.parametersAddToken = NO;
    
    return api;
}
//获取可领取优惠券列表
+ (instancetype)GetProductCouponWithpid:(NSString *)pid{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetProductCoupon;
    if (pid) {
        [api.parameters setObject:pid forKey:@"pid"];
    }
    api.parametersAddToken = NO;
    return api;
}

//猜你喜欢
+ (instancetype)GetAlliancesProductsWithpids:(NSString *)pids{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetAlliancesProducts;
    if (pids) {
        [api.parameters setObject:pids forKey:@"pids"];
    }
    
    api.parametersAddToken = NO;
    
    return api;
}

//领取优惠券
+ (instancetype)postReceiveCouponWithcoupId:(NSString *)coupId{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_ReceiveCoupon;
    if (coupId) {
        [api.parameters setObject:coupId forKey:@""];
    }
    
    api.parametersAddToken = NO;
    
    return api;
    
}

@end
