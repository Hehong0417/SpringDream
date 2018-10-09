//
//  HHMineAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHMineAPI : BaseAPI

#pragma mark - get

//获取用户详细
+ (instancetype)GetUserDetail;

//我的二维码
+ (instancetype)GetMyCode;

//粉丝列表
+ (instancetype)GetAgentListWithPage:(NSNumber *)page userName:(NSString *)userName;

//优惠券
+ (instancetype)GetMyCouponListWithPage:(NSNumber *)page status:(NSNumber *)status;

//退出登录
+ (instancetype)UserLogout;


//用户收货地址列表
+ (instancetype)GetAddressListWithpage:(NSNumber *)page;

//获取一个收货地址
+ (instancetype)GetAddressWithId:(NSString *)Id;

//提现记录
+ (instancetype)GetWithdrawalsListWithpage:(NSNumber *)page;

//收款银行卡列表
+ (instancetype)GetBankListWithpage:(NSNumber *)page;

//获取一个收款地址
+ (instancetype)GetBankDetailWithId:(NSString *)Id;


//获取订单列表
+ (instancetype)GetOrderListWithstatus:(NSNumber *)status page:(NSNumber *)page;

//获取订单详情
+ (instancetype)GetOrderDetailWithorderid:(NSString *)orderid;

//获取提现信息
+ (instancetype)GetUserApplyMessage;

//获取消息列表
+ (instancetype)GetUserNoticeWithPage:(NSNumber *)page isRead:(NSNumber *)isRead;

//获取消息详情
+ (instancetype)GetNoticeDetailWithId:(NSNumber *)Id;

//获取代理信息
+ (instancetype)GetApplyAgent;

//获取商品评价统计接口
+ (instancetype)GetProductEvaluateStatictisWithpid:(NSString *)pid;

//获取订单的物流信息
+ (instancetype)GetOrderExpressWithorderid:(NSString *)orderid giftId:(NSNumber *)giftId;

//获取未完成订单数
+ (instancetype)GetOrderStatusCount;

//我的门店
+ (instancetype)GetUserStore;

//获取门店订单
+ (instancetype)GetStoreOrderWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;

//获取分销总佣金
+ (instancetype)GetUserTotalCommission;
//获取分销佣金
+ (instancetype)GetFansSaleWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//获取分销商
+ (instancetype)GetDistributionBusinessWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//获取分销订单
+ (instancetype)GetDistributionOrderWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//我的下级会员总数接口
+ (instancetype)GetUserFanCount;
//我的下级会员接口
+ (instancetype)GetUserFewFansWithFew:(NSNumber *)few page:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//代理商
+ (instancetype)GetSubAgentsWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//获取代理佣金
+ (instancetype)GetBonusWithpage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//团队下级的会员
+ (instancetype)GetSubUsersWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//代理订单
+ (instancetype)GetAgentOrdersWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;


//门店收益
+ (instancetype)GetUserStoreCommissionWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//门店总收益
+ (instancetype)GetUserStoreCommissionStatictis;
//我的积分
+ (instancetype)GetIntegralListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//会员积分排行榜
+ (instancetype)GetTopPointsLeaderboardWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//获取推荐码
+ (instancetype)GetRecommendCode;
//获取余额变更记录
+ (instancetype)GetBalanceChangeListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;
//获取分销说明
+ (instancetype)GetDistributionContent;
//获取银行卡列表
+ (instancetype)GetUserBankAccountList;
#pragma mark - post

//修改登录密码
+ (instancetype)ModifyLoginPasswordWithold_pwd:(NSString *)old_pwd new_pwd:(NSString *)new_pwd repeat_new_pwd:(NSString *)repeat_new_pwd;


//删除收货地址
+ (instancetype)postDeleteAddressWithId:(NSString *)Id;

//设置为默认收货地址
+ (instancetype)postSetDefaultAddressWithId:(NSString *)Id;

//编辑收货地址
+ (instancetype)postEditAddressWithId:(NSString *)Id district_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default;

//添加地址
+ (instancetype)postAddAddressWithdistrict_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default;

//上传用户头像
+ (instancetype)UploadUserIconWithImageData:(NSData *)imageData;
//保存用户头像
+ (instancetype)SaveUserIconWithfilename:(NSString *)filename;

//取消订单
+ (instancetype)postOrder_CloseWithorderid:(NSString *)orderid;
//支付订单
+ (instancetype)postPayOrderWithorderid:(NSString *)orderid;
//申请退款
+ (instancetype)postConfirmOrderWithorderid:(NSString *)orderId orderItemId:(NSString *)orderItemId quantity:(NSString *)quantity comments:(NSString *)comments;
//确认收货
+ (instancetype)postConfirmOrderWithorderid:(NSString *)orderid;
//佣金申请
+ (instancetype)postCommissionApplyWithCommission:(NSString *)commission;
//设置全部已读
+ (instancetype)postSetReadNotice;
//申请代理不支付
+ (instancetype)postApplyAgentWithagnetId:(NSString *)agnetId smsCode:(NSString *)smsCode mobile:(NSString *)mobile;
//申请代理并支付
+ (instancetype)postAgentApplyPayWithagnetId:(NSString *)agnetId smsCode:(NSString *)smsCode mobile:(NSString *)mobile;
// 验证手机号
+ (instancetype)postVerifyMobile:(NSString *)mobile;
//发送短信验证码
+ (instancetype)postSms_SendCode:(NSString *)mobile code:(NSString *)code;
//订单支付
+ (instancetype)postOrder_AppPayAddrId:(NSString *)addrId orderId:(NSString *)orderId money:(NSString *)money;
//创建订单
+ (instancetype)postOrder_CreateWithAddrId:(NSString *)addr_id skuId:(NSString *)skuId count:(NSString *)count mode:(NSNumber *)mode gbId:(NSString *)gbId couponId:(NSString *)couponId integralTempIds:(NSString *)integralTempIds message:(NSString *)message cartIds:(NSString *)cartIds storeId:(NSString *)storeId shippingStoreIds:(NSString *)shippingStoreIds;
//发布评价
+ (instancetype)postOrderEvaluateWithOrderId:(NSString *)orderId level:(NSNumber *)level logisticsScore:(NSNumber *)logisticsScore serviceScore:(NSNumber *)serviceScore productEvaluate:(NSString *)productEvaluate;
//上传多张图片
+ (instancetype)postUploadManyImageWithimageDatas:(NSArray *)imageDatas;
//佣金转余额(分销佣金 = 0、代理佣金 = 1、门店佣金 = 2）
+ (instancetype)postBonusToBalanceWithmoney:(NSString *)money bonusType:(NSNumber *)bonusType;
//转送积分
+ (instancetype)postGiveAwayPointsWithgetUserId:(NSString *)getUserId points:(NSString *)points;
//校验推荐码并绑定上下级关系
+ (instancetype)ValidateRecommendCodeWithCode:(NSString *)code;
//更新省市区信息
+ (instancetype)UpdateUserInfoOfCityWithRegionId:(NSString *)regionId;
@end
