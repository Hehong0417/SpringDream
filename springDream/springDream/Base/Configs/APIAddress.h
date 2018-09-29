//
//  APIAddress.h
//  ganguo
//
//  Created by ganguo on 13-7-8.
//  Copyright (c) 2013年 ganguo. All rights reserved.
//

//SKU  MengYa

//(57)
//#ifdef DEBUG

//阿里云
#define API_HOST @"http://mrs-base.elevo.cn/api"

#define API_HOST1 @"http://mrs.elevo.cn"

#define API_HOST2 @"http://mrs-order.elevo.cn/api"

//分类、商品详情
#define API_HOST3  @"http://mrs-product.elevo.cn/api/Product"

#define API_HOST4  @"http://mrs-product.elevo.cn/api"


////公共设置
#define APP_key @"59334e721bcd31"
#define APP_scode @"15ca7554e8cb486f3b8cbe1fa166c75b"
// [NSString md5:[APP_key stringByAppendingString:@"trans"]]

//MD5加密（APP_key+”weicai”）
//#define API_APP_BASE_URL @""
//#define API_BASE_URL [NSString stringWithFormat:@"%@", API_HOST]
#define API_QR_BASE_URL [NSString stringWithFormat:@"%@/image", API_BASE_URL]
//接口类型1
#define API_SUB_URL(_url) [NSString stringWithFormat:@"%@/%@", API_HOST, _url]
//接口类型2
#define API_SUB_URL1(_url) [NSString stringWithFormat:@"%@/%@", API_HOST1, _url]
//接口类型3
#define API_SUB_URL2(_url) [NSString stringWithFormat:@"%@/%@", API_HOST2, _url]
//接口类型4
#define API_SUB_URL3(_url) [NSString stringWithFormat:@"%@/%@", API_HOST3, _url]
//接口类型5
#define API_SUB_URL4(_url) [NSString stringWithFormat:@"%@/%@", API_HOST4, _url]

#import "HJUser.h"

//微信APPStore URL
#define KWX_APPStore_URL @"https://itunes.apple.com/cn/app/微信/id414478124?mt=8"
//#define KWX_APPStore_URL @"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"

/**
 *  登录注册
 */
#define Cid @"1"

//1.3注册
#define API_Register API_SUB_URL4(@"UserInfo/Register")
//1.4登录
#define API_Login   API_SUB_URL4(@"UserInfo/Login")
//1.8身份证绑定
#define API_BindCardIDInformation API_SUB_URL4(@"UserInfo/BindCardIDInformation")
//1.7银行卡绑定
#define API_BindBankCardInformation API_SUB_URL4(@"UserInfo/BindBankCardInformation")
//1.6发送短信验证码
#define API_Sms_SendCode API_SUB_URL1(@"CommonApi/Sms/Send")
//1.8佣金转余额
#define API_BonusToBalance  API_SUB_URL4(@"Balance/BonusToBalance")
//1.9获取推荐码
#define API_GetRecommendCode  API_SUB_URL4(@"User/GetRecommendCode")
//1.10校验推荐码并绑定上下级关系
#define API_ValidateRecommendCode  API_SUB_URL4(@"User/ValidateRecommendCode")
//1.11转送积分
#define API_GiveAwayPoints  API_SUB_URL4(@"UserInfo/GiveAwayPoints")
//1.12会员积分排行榜
#define API_TopPointsLeaderboard API_SUB_URL4(@"UserInfo/TopPointsLeaderboard")
//1.13我的积分
//#define API_IntegralList API_SUB_URL4(@"Personal/IntegralList")
//1.14获取余额变更记录
#define API_BalanceChangeList API_SUB_URL4(@"Balance/BalanceChangeList")

//1.4手机号登录
#define API_IOSAuthenticationLogin   API_SUB_URL(@"WeiXin/IOSAuthenticationLogin")
//1.6忘记密码，重置密码
#define API_ResetPassword API_SUB_URL(@"CustomerApi/User/ResetPassword")
//1.7验证手机号
#define API_VerifyMobile API_SUB_URL(@"UserInfo/VerifyMobile")


/**
 *  首页
 */
//2.1首页商品列表
#define API_GetHomeProductList  API_SUB_URL(@"ProductApi/ApiIndexProduct/GetCategoryProductList")
////2.2商品详情
//#define API_GetProductDetail  API_SUB_URL(@"ProductApi/ApiProduct/GetProductDetail")
//2.3月成交记录
#define API_GetFinishLog  API_SUB_URL(@"ProductApi/ApiProduct/GetFinishLog")



/**
 *  商品分类
 */
//3.1获取商品分类列表
#define API_GetProductGroup API_SUB_URL3(@"GetProductGroup")
//3.4获取商品分类列表(搜索)
#define API_Product_search API_SUB_URL3(@"SearchProduct")
//3.5获取单个商品
#define API_GetProductDetail API_SUB_URL3(@"GetProduct")

/**
 *  购物车
 */
//3.1获取购物车中商品
//#define API_GetProducts  API_SUB_URL2(@"ShopCart/Get")
#define API_GetProducts  API_SUB_URL2(@"ShopCart/GetShopCart")
//3.2是否存在收货地址
#define API_IsExistOrderAddress  API_SUB_URL(@"UserInfo/IsExistOrderAddress")
//3.2添加购物车数量
#define API_AddQuantity API_SUB_URL2(@"ShopCart/Create")
//3.2减少购物车数量
#define API_minusQuantity API_SUB_URL2(@"ShopCart/AddCount")
//3.3加入购物车
#define API_AddProducts API_SUB_URL2(@"ShopCart/Create")
//3.4删除购物车
#define API_ShopCart_Delete API_SUB_URL2(@"ShopCart/Delete")
//3.5获得结算订单
#define API_GetConfirmOrder API_SUB_URL2(@"PreviewOrder/Get")
//3.7热门搜索
#define API_GetHotSearch API_SUB_URL(@"UserInfo/GetUserSearchAndHotSearch")
//3.8用户历史搜索
#define API_GetUserSearch API_SUB_URL(@"UserInfo/GetUserSearchAndHotSearch")
// APP订单去支付
#define API_Order_AppPay API_SUB_URL2(@"Order/AppPay")
//3.9创建订单
#define API_Order_Create API_SUB_URL2(@"Order/Create")
//3.10 发布评价
#define API_OrderEvaluate API_SUB_URL2(@"Order/OrderEvaluate")
//3.11 上传多张图片
#define API_UploadManyImage API_SUB_URL(@"FileUpload/UploadManyImage")
//3.6商品评价列表
#define API_GetProductEvaluate API_SUB_URL2(@"Order/GetProductEvaluate")
//3.6门店列表
#define API_GetProductStore API_SUB_URL(@"Store/GetProductStore")
//3.7商品收藏
#define API_AddProductCollection API_SUB_URL3(@"AddProductCollection")
//3.8取消商品收藏
#define API_DeleteProductCollection API_SUB_URL3(@"DeleteProductCollection")
//3.9取消商品收藏
#define API_DeleteProductCollection API_SUB_URL3(@"DeleteProductCollection")
//3.10获取个人商品收藏
#define API_GetProductCollection API_SUB_URL3(@"GetProductCollection")


/**
 *  我的
 */
//4.1获取用户详细
#define API_GetUserDetail API_SUB_URL(@"UserInfo/GetInfo")
//4.2退出登录
#define API_Logout API_SUB_URL(@"CustomerApi/User/Logout")
//4.2修改登录密码
#define API_ModifyLoginPassword API_SUB_URL(@"CustomerApi/User/ModifyLoginPassword")
//4.3修改安全密码
#define API_ModifySecurityPassword API_SUB_URL(@"CustomerApi/User/ModifySecurityPassword")
//4.8实名认证
#define API_Authentication API_SUB_URL(@"CustomerApi/User/Authentication")
//4.8特殊认证
#define API_SpecialAuthentication API_SUB_URL(@"CustomerApi/User/SpecialAuthentication")
//4.9转账记录
#define API_TransferList API_SUB_URL(@"CustomerApi/Trade/TransferList")
//4.10转账
#define API_Transfer API_SUB_URL(@"CustomerApi/Trade/Transfer")
//4.13用户收货地址
#define API_GetAddressList API_SUB_URL(@"UserInfo/GetUserAddressList")
//4.14删除收货地址
#define API_DeleteAddress API_SUB_URL(@"UserInfo/DeleteUserAddress")
//4.15设置为默认收货地址
#define API_SetDefaultAddress API_SUB_URL(@"CustomerApi/User/SetDefaultAddress")
//4.16编辑收货地址
#define API_EditAddress API_SUB_URL(@"UserInfo/EditUserAddress")
//4.17获取一个收货地址(获取默认收货地时，不传）
#define API_GetAddress API_SUB_URL(@"UserInfo/GetUserAddress")
//4.18添加地址
#define API_AddAddress  API_SUB_URL(@"UserInfo/EditUserAddress")
//4.33获取订单列表
#define API_GetOrderList API_SUB_URL2(@"Order/Get")
//4.33获取订单详情
#define API_GetOrderDetail API_SUB_URL2(@"Order/GetOrderDetail")
//4.33获取提现信息
#define API_GetUserApplyMessage API_SUB_URL(@"Commission/GetUserApplyMessage")
//4.21佣金申请
#define API_CommissionApply  API_SUB_URL(@"Commission/Apply")
//4.34获取积分列表
#define API_IntegralList API_SUB_URL(@"Integral/GetHistorys")
//4.34获取消息列表
#define API_GetUserNotice API_SUB_URL(@"Notice/GetUserNotice")
//4.35设置消息全部已读
#define API_SetReadNotice API_SUB_URL(@"Notice/SetReadNotice")
//4.35获取消息详情
#define API_GetNoticeDetail API_SUB_URL(@"Notice/GetNoticeDetail")
//4.36上传用户头像
#define API_UploadUserIcon API_SUB_URL(@"Api/Image/UploadUserIcon")
//4.36保存用户头像
#define API_SaveUserIcon API_SUB_URL(@"CustomerApi/User/SaveUserIcon")
//4.37取消订单
#define API_order_Close  API_SUB_URL2(@"Order/Cancel")
//4.38支付订单
#define API_PayOrder  API_SUB_URL(@"WeiXin/Pay")
//4.39确认收货
#define API_ConfirmOrder  API_SUB_URL2(@"Order/Confirm")
//4.40申请退款
#define API_RefundMoney  API_SUB_URL2(@"Order/RefundMoney")
//4.40猜你喜欢
#define API_GetAlliancesProducts  API_SUB_URL3(@"GetAlliancesProducts")
//4.41我的二维码
#define API_Mycode API_SUB_URL(@"UserInfo/GetQRCode")
//4.43优惠券
#define API_GetMyCouponList API_SUB_URL2(@"Activity/GetMyCouponList")
//4.44获取代理信息
#define API_GetApplyAgent API_SUB_URL(@"UserInfo/GetApplyAgent")
//4.45申请代理不支付
#define API_ApplyAgent API_SUB_URL(@"UserInfo/ApplyAgent")
//4.46申请代理并支付
#define API_AgentApplyPay API_SUB_URL2(@"Order/AgentApplyRealAppPay")
//4.47 粉丝列表搜索
#define API_GetAgentList API_SUB_URL(@"UserInfo/GetAgentList")     
//4.48获取商品评价统计接口
#define API_GetProductEvaluateStatictis API_SUB_URL2(@"Order/GetProductEvaluateStatictis")
//省
#define API_GetProvinces API_SUB_URL1(@"Admin/Region/GetRegionList")
//获取城市或地区
#define API_GetChilds API_SUB_URL1(@"Admin/Region/GetRegionList")
//4.2获取订单的物流信息
#define API_GetOrderExpress API_SUB_URL2(@"Order/GetCheckLogistics")
//4.2获取未完成订单数
#define API_GetOrderStatusCount API_SUB_URL2(@"Order/GetOrderStatusCount")
//4.3我的门店
#define API_GetUserStore API_SUB_URL(@"Store/GetUserStore")
//4.4获取门店订单
#define API_GetStoreOrder API_SUB_URL2(@"Order/GetStoreOrder")
//4.5获取分销总佣金
#define API_GetUserCommission API_SUB_URL(@"Commission/GetUserCommission")
//4.6获取分销佣金
#define API_GetFansSale API_SUB_URL(@"Commission/GetFansSale")
//4.8获取分销商
#define API_GetUserBusiness API_SUB_URL(@"UserInfo/GetUserBusiness")
//4.9获取分销订单
#define API_GetDistributionOrder API_SUB_URL2(@"Order/GetDistributionOrder")
//4.10我的下级会员总数接口
#define API_GetUserFanCount API_SUB_URL(@"UserInfo/GetUserFanCount")
//4.20我的下级会员接口
#define API_GetUserFewFans API_SUB_URL(@"UserInfo/GetUserFewFans")
//4.21获得用户代理佣金明细
#define API_GetBonus API_SUB_URL(@"Agent/GetBonus")
//4.22获得团队下级的会员
#define API_GetSubUsers API_SUB_URL(@"Agent/GetSubUsers")
//4.23获得团队下级的代理
#define API_GetSubAgents API_SUB_URL(@"Agent/GetSubAgents")
//4.24 门店收益
#define API_GetUserStoreCommission API_SUB_URL(@"Store/GetUserStoreCommission")
//4.24 门店zo收益
#define API_GetUserStoreCommissionStatictis API_SUB_URL(@"Store/GetUserStoreCommissionStatictis")


/**
 *  支付
 */

//微信支付通知
#define KWX_Pay_Sucess_Notification @"KWX_Pay_Sucess_Notification" //微信支付成功通知
#define KWX_Pay_Fail_Notification @"KWX_Pay_Fail_Notification" //微信支付失败通知

//代理支付完成，刷新个人中心
#define KPersonCter_Refresh_Notification @"KPersonCter_Refresh_Notification" //微信支付失败通知

typedef enum : NSUInteger {
    HHenter_itself_Type,
    HHenter_home_Type,
    HHenter_category_Type
} HHenter_Type;
typedef enum : NSUInteger {
    HHhandle_type_delete,
    HHhandle_type_cancel,
    HHhandle_type_Confirm,
} HHhandle_type;
