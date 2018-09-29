//
//  HHMineAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMineAPI.h"

@implementation HHMineAPI

#pragma mark - get

//获取用户详细
+ (instancetype)GetUserDetail{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserDetail;
    api.parametersAddToken = NO;
    return api;
}
//我的二维码
+ (instancetype)GetMyCode{
    HHMineAPI *api = [self new];
    api.subUrl = API_Mycode;
    api.parametersAddToken = NO;
    return api;
}
//粉丝列表
+ (instancetype)GetAgentListWithPage:(NSNumber *)page userName:(NSString *)userName{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetAgentList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (userName) {
        [api.parameters setObject:userName forKey:@"userName"];
    }
    api.parametersAddToken = NO;
    return api;
}
+ (instancetype)GetMyCouponListWithPage:(NSNumber *)page status:(NSNumber *)status{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetMyCouponList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (status) {
        [api.parameters setObject:status forKey:@"status"];
    }
    api.parametersAddToken = NO;
    return api;
}

//用户收货地址列表
+ (instancetype)GetAddressListWithpage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetAddressList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}

//获取一个收货地址
+ (instancetype)GetAddressWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取订单列表
+ (instancetype)GetOrderListWithstatus:(NSNumber *)status page:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderList;
    if (status) {
        [api.parameters setObject:status forKey:@"status"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取订单详情
+ (instancetype)GetOrderDetailWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderDetail;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderId"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//获取提现信息
+ (instancetype)GetUserApplyMessage{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserApplyMessage;
    api.parametersAddToken = NO;
    return api;
}

//获取消息列表
+ (instancetype)GetUserNoticeWithPage:(NSNumber *)page isRead:(NSNumber *)isRead{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserNotice;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (isRead) {
        [api.parameters setObject:isRead forKey:@"isRead"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取消息详情
+ (instancetype)GetNoticeDetailWithId:(NSNumber *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetNoticeDetail;
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
    api.parametersAddToken = NO;
    return api;
}
//退出登录
+ (instancetype)UserLogout{
    HHMineAPI *api = [self new];
    api.subUrl = API_Logout;
    api.parametersAddToken = NO;
    return api;
}
//获取代理信息
+ (instancetype)GetApplyAgent{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetApplyAgent;
    api.parametersAddToken = NO;
    return api;
}
//获取商品评价统计接口
+ (instancetype)GetProductEvaluateStatictisWithpid:(NSString *)pid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetProductEvaluateStatictis;
    if (pid) {
        [api.parameters setObject:pid forKey:@"pid"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//获取订单的物流信息
+ (instancetype)GetOrderExpressWithorderid:(NSString *)orderid giftId:(NSNumber *)giftId{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderExpress;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderId"];
    }
    if (giftId) {
        [api.parameters setObject:giftId forKey:@"giftId"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取未完成订单数
+ (instancetype)GetOrderStatusCount{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderStatusCount;
    api.parametersAddToken = NO;
    return api;
}

//我的门店
+ (instancetype)GetUserStore{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserStore;
    api.parametersAddToken = NO;
    return api;
    
}

//获取门店订单
+ (instancetype)GetStoreOrderWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetStoreOrder;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取分销总佣金
+ (instancetype)GetUserTotalCommission{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserCommission;
    api.parametersAddToken = NO;
    return api;
}
//获取分销佣金
+ (instancetype)GetFansSaleWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.subUrl = API_GetFansSale;
    api.parametersAddToken = NO;
    return api;
}
//获取分销商
+ (instancetype)GetDistributionBusinessWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserBusiness;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取分销订单
+ (instancetype)GetDistributionOrderWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetDistributionOrder;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
}

//我的下级会员总数接口
+ (instancetype)GetUserFanCount{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserFanCount;
    api.parametersAddToken = NO;
    return api;
}
//我的下级会员接口
+ (instancetype)GetUserFewFansWithFew:(NSNumber *)few page:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserFewFans;
    if (few) {
        [api.parameters setObject:few forKey:@"few"];
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
//代理商
+ (instancetype)GetSubAgentsWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetSubAgents;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取代理佣金
+ (instancetype)GetBonusWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.subUrl = API_GetBonus;
    api.parametersAddToken = NO;
    return api;
}
//团队下级的会员
+ (instancetype)GetSubUsersWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetSubUsers;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
}
//门店收益
+ (instancetype)GetUserStoreCommissionWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserStoreCommission;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
}
//门店总收益
+ (instancetype)GetUserStoreCommissionStatictis{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserStoreCommissionStatictis;
    api.parametersAddToken = NO;
    return api;
}

//我的积分
+ (instancetype)GetIntegralListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    api.subUrl = API_IntegralList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//会员积分排行榜
+ (instancetype)GetTopPointsLeaderboardWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    api.subUrl = API_TopPointsLeaderboard;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//获取推荐码
+ (instancetype)GetRecommendCode{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetRecommendCode;
    api.parametersAddToken = NO;
    return api;
    
}
//获取余额变更记录
+ (instancetype)GetBalanceChangeListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    HHMineAPI *api = [self new];
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.subUrl = API_BalanceChangeList;
    api.parametersAddToken = NO;
    return api;
}

#pragma mark - post

//修改登录密码
+ (instancetype)ModifyLoginPasswordWithold_pwd:(NSString *)old_pwd new_pwd:(NSString *)new_pwd repeat_new_pwd:(NSString *)repeat_new_pwd{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ModifyLoginPassword;
    if (old_pwd) {
        [api.parameters setObject:old_pwd forKey:@"old_pwd"];
    }
    if (new_pwd) {
        [api.parameters setObject:new_pwd forKey:@"new_pwd"];
    }
    if (repeat_new_pwd) {
        [api.parameters setObject:repeat_new_pwd forKey:@"repeat_new_pwd"];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//删除收货地址
+ (instancetype)postDeleteAddressWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_DeleteAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@""];
    }
   
    api.parametersAddToken = NO;
    return api;
}

//设置为默认收货地址
+ (instancetype)postSetDefaultAddressWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_SetDefaultAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
    
    api.parametersAddToken = NO;
    return api;
}

//编辑收货地址
+ (instancetype)postEditAddressWithId:(NSString *)Id district_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default{
    HHMineAPI *api = [self new];
    api.subUrl = API_EditAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
    if (district_id) {
        [api.parameters setObject:district_id forKey:@"regionId"];
    }
    if (address) {
        [api.parameters setObject:address forKey:@"address"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"name"];
    }
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"phone"];
    }
    if (is_default) {
        [api.parameters setObject:is_default forKey:@"isDefault"];
    }
    api.parametersAddToken = NO;
    return api;
}

//添加地址
+ (instancetype)postAddAddressWithdistrict_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default{
    HHMineAPI *api = [self new];
    api.subUrl = API_AddAddress;
    if (district_id) {
        [api.parameters setObject:district_id forKey:@"regionId"];
    }
    if (address) {
        [api.parameters setObject:address forKey:@"address"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"name"];
    }
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"phone"];
    }
    if (is_default) {
        [api.parameters setObject:is_default forKey:@"IsDefault"];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//上传用户头像
+ (instancetype)UploadUserIconWithImageData:(NSData *)imageData{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_UploadUserIcon;
    if (imageData) {
        NetworkClientFile *file = [NetworkClientFile imageFileWithFileData:imageData name:@"file"];
        
        api.uploadFile = @[file];
    }
    
    api.parametersAddToken = NO;
    return api;
    
}

//保存用户头像
+ (instancetype)SaveUserIconWithfilename:(NSString *)filename{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_SaveUserIcon;
    if (filename) {
        [api.parameters setObject:filename forKey:@"filename"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//取消订单
+ (instancetype)postOrder_CloseWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_order_Close;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@""];
    }
    api.parametersAddToken = NO;
    return api;

}

//支付订单
+ (instancetype)postPayOrderWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_PayOrder;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"order_id"];
    }
    api.parametersAddToken = NO;
    return api;
}

//申请退款
+ (instancetype)postConfirmOrderWithorderid:(NSString *)orderId orderItemId:(NSString *)orderItemId quantity:(NSString *)quantity comments:(NSString *)comments{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_RefundMoney;
    if (orderId) {
        [api.parameters setObject:orderId forKey:@"orderId"];
    }
    if (orderItemId) {
        [api.parameters setObject:orderItemId forKey:@"orderItemId"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    if (comments) {
        [api.parameters setObject:quantity forKey:@"comments"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//确认收货
+ (instancetype)postConfirmOrderWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ConfirmOrder;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@""];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//佣金申请
+ (instancetype)postCommissionApplyWithCommission:(NSString *)commission{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_CommissionApply;
    if (commission) {
        [api.parameters setObject:commission forKey:@""];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//设置全部已读
+ (instancetype)postSetReadNotice{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_SetReadNotice;
    api.parametersAddToken = NO;
    return api;
}
//申请代理不支付
+ (instancetype)postApplyAgentWithagnetId:(NSString *)agnetId smsCode:(NSString *)smsCode mobile:(NSString *)mobile{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ApplyAgent;
    if (agnetId) {
        [api.parameters setObject:agnetId forKey:@"agnetId"];
    }
    if (smsCode) {
        [api.parameters setObject:smsCode forKey:@"smsCode"];
    }
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    api.parametersAddToken = NO;
    return api;
}
//申请代理并支付
+ (instancetype)postAgentApplyPayWithagnetId:(NSString *)agnetId smsCode:(NSString *)smsCode mobile:(NSString *)mobile{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_AgentApplyPay;
    if (agnetId) {
        [api.parameters setObject:agnetId forKey:@"applyId"];
    }
    if (smsCode) {
        [api.parameters setObject:smsCode forKey:@"smsCode"];
    }
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    api.parametersAddToken = NO;
    return api;
}
// 验证手机号
+ (instancetype)postVerifyMobile:(NSString *)mobile{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_VerifyMobile;
    if (mobile) {
        [api.parameters setObject:mobile forKey:@""];
    }
    api.parametersAddToken = NO;
    return api;
}
// 发送短信验证码
+ (instancetype)postSms_SendCode:(NSString *)mobile code:(NSString *)code {
    
    HHMineAPI *api = [self new];
    api.subUrl = API_Sms_SendCode;
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    if (code) {
        [api.parameters setObject:code forKey:@"code"];
    }
        [api.parameters setObject:@"0" forKey:@"smsCodeType"];
    
    api.parametersAddToken = NO;
    return api;
}
//订单支付
+ (instancetype)postOrder_AppPayAddrId:(NSString *)addrId orderId:(NSString *)orderId money:(NSString *)money{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_Order_AppPay;
    if (addrId) {
        [api.parameters setObject:addrId forKey:@"addrId"];
    }
    if (orderId) {
        [api.parameters setObject:orderId forKey:@"orderId"];
    }
    if (money) {
        [api.parameters setObject:money forKey:@"money"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//创建订单
+ (instancetype)postOrder_CreateWithAddrId:(NSString *)addr_id skuId:(NSString *)skuId count:(NSString *)count mode:(NSNumber *)mode gbId:(NSString *)gbId couponId:(NSString *)couponId integralTempIds:(NSString *)integralTempIds message:(NSString *)message cartIds:(NSString *)cartIds storeId:(NSString *)storeId{
    HHMineAPI *api = [self new];
    api.subUrl = API_Order_Create;
    if (addr_id) {
        [api.parameters setObject:addr_id forKey:@"addr_id"];
    }
    if (skuId) {
        [api.parameters setObject:skuId forKey:@"skuId"];
    }
    if (count) {
        [api.parameters setObject:count forKey:@"count"];
    }
    if (mode) {
        [api.parameters setObject:mode forKey:@"mode"];
    }
    if (couponId) {
        [api.parameters setObject:couponId forKey:@"couponId"];
    }
    if (cartIds) {
        [api.parameters setObject:cartIds forKey:@"cartIds"];
    }
    if (gbId) {
        [api.parameters setObject:gbId forKey:@"gbId"];
    }
    if (storeId) {
        [api.parameters setObject:storeId forKey:@"toStoreId"];
    }
    if (integralTempIds) {
        [api.parameters setObject:integralTempIds forKey:@"integralTempIds"];
    }
    api.parametersAddToken = NO;
    return api;
}
//发布评价
+ (instancetype)postOrderEvaluateWithOrderId:(NSString *)orderId level:(NSNumber *)level logisticsScore:(NSNumber *)logisticsScore serviceScore:(NSNumber *)serviceScore productEvaluate:(NSString *)productEvaluate{
    HHMineAPI *api = [self new];
    api.subUrl = API_OrderEvaluate;
    if (orderId) {
        [api.parameters setObject:orderId forKey:@"orderId"];
    }
    if (level) {
        [api.parameters setObject:level forKey:@"level"];
    }
    if (logisticsScore) {
        [api.parameters setObject:logisticsScore forKey:@"logisticsScore"];
    }
    if (serviceScore) {
        [api.parameters setObject:serviceScore forKey:@"serviceScore"];
    }
    if (productEvaluate) {
        [api.parameters setObject:productEvaluate forKey:@"evaluate"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//上传多张图片
+ (instancetype)postUploadManyImageWithimageDatas:(NSArray *)imageDatas{
    HHMineAPI *api = [self new];
    api.subUrl = API_UploadManyImage;
    NSMutableArray *uploadFile = [NSMutableArray array];
    if (imageDatas) {
        for (NSData *imageData  in imageDatas) {
            NetworkClientFile *file = [NetworkClientFile imageFileWithFileData:imageData name:@"file"];
            [uploadFile addObject:file];
        }
        api.uploadFile = uploadFile;
    }
    api.parametersAddToken = NO;
    return api;
    
}
+ (instancetype)postBonusToBalanceWithmoney:(NSString *)money bonusType:(NSNumber *)bonusType{
    HHMineAPI *api = [self new];
    api.subUrl = API_BonusToBalance;
    if (money) {
        [api.parameters setObject:money forKey:@"money"];
    }
    if (bonusType) {
        [api.parameters setObject:bonusType forKey:@"bonusType"];
    }
    api.parametersAddToken = NO;
    return api;

}
//转送积分
+ (instancetype)postGiveAwayPointsWithgetUserId:(NSString *)getUserId points:(NSString *)points{
    HHMineAPI *api = [self new];
    api.subUrl = API_GiveAwayPoints;
    if (getUserId) {
        [api.parameters setObject:getUserId forKey:@"getUserId"];
    }
    if (points) {
        [api.parameters setObject:points forKey:@"points"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//校验推荐码并绑定上下级关系
+ (instancetype)ValidateRecommendCodeWithCode:(NSString *)code{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ValidateRecommendCode;
    if (code) {
        [api.parameters setObject:code forKey:@"code"];
    }
    api.parametersAddToken = NO;
    return api;
}
@end
