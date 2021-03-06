//
//  HHMineModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHMineModel : BaseModel

//用户详细
@property(nonatomic,strong) NSString *BuyTotal;
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *UserName;
@property(nonatomic,strong) NSString *UserImage;
@property(nonatomic,strong) NSString *parent_userid;
@property(nonatomic,strong) NSString *parent_username;
@property(nonatomic,strong) NSString *level;
@property(nonatomic,strong) NSString *ReferralUserName;
@property(nonatomic,strong) NSString  *Points;
@property(nonatomic,strong) NSNumber  *isExtraBonus;
@property(nonatomic,strong) NSString  *CellPhone;
@property(nonatomic,strong) NSString  *RealName;
@property(nonatomic,strong) NSString  *UserLevelId;
@property(nonatomic,strong) NSString  *CardID;
@property(nonatomic,strong) NSString  *OpenId;
@property(nonatomic,strong) NSString  *userRegin;
@property(nonatomic,strong) NSString  *total;


@property(nonatomic,strong) NSNumber  *isUserAgent;
@property(nonatomic,strong) NSNumber  *isUserDistribution;
@property(nonatomic,strong) NSNumber  *isHasStore;



//订单消息数
@property(nonatomic,strong) NSString  *wait_pay_count;//待付款
@property(nonatomic,strong) NSString  *wait_send_count;//待发货
@property(nonatomic,strong) NSString  *already_shipped_count;//已发货
@property(nonatomic,strong) NSString  *un_evaluate_count;//待评价
@property(nonatomic,strong) NSString  *afte_ervice_count;//退款/售后

//优惠券信息
@property(nonatomic,strong) NSString *CouponValue;
@property(nonatomic,strong) NSString *CouponsId;
@property(nonatomic,strong) NSString *StartTime;
@property(nonatomic,strong) NSString *EndTime;
@property(nonatomic,strong) NSString *CouponsName;
@property(nonatomic,strong) NSString *ConditionValue;

@property(nonatomic,strong) NSString *begin_time;
@property(nonatomic,strong) NSString *condition;
@property(nonatomic,strong) NSString *end_time;
@property(nonatomic,strong) NSString *value;
@property(nonatomic,strong) NSString *cid;


//粉丝列表
@property(nonatomic,strong) NSString *AgentName;
@property(nonatomic,strong) NSString *Icon;
@property(nonatomic,strong) NSString *AcId;
//@property(nonatomic,strong) NSString *UserName;
@property(nonatomic,strong) NSString *AgnetLevel;

//提现信息
@property(nonatomic,strong) NSString *MinBalance;
@property(nonatomic,strong) NSString *MaxBalance;
@property(nonatomic,strong) NSString *HadBalance;
@property(nonatomic,strong) NSString *IsBusiness;
@property(nonatomic,strong) NSString *IsExistApply;
@property(nonatomic,strong) NSString *RefuseReason;
@property(nonatomic,strong) NSString *ApplyMoney;

//我的积分
@property (nonatomic, assign) NSString *integra;
@property (nonatomic, copy) NSString *integraType;
@property (nonatomic, copy) NSString *datetime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *oid;

//积分排行榜
@property (nonatomic, assign) NSString *Ponits;
@property (nonatomic, copy) NSString *Sort;
@property (nonatomic, copy) NSString *UserId;
//@property (nonatomic, copy) NSString *UserImage;
//@property (nonatomic, copy) NSString *UserName;

//我的消息
@property (nonatomic, copy) NSString *Author;
@property (nonatomic, assign) NSInteger ClientInfo_Id;
@property (nonatomic, copy) NSString *Memo;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *PubTime;
@property (nonatomic, assign) NSInteger SendTo;
@property (nonatomic, assign) BOOL IsRead;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, assign) NSInteger SendType;
@property (nonatomic, assign) NSInteger IsPub;

//收货地址
@property(nonatomic,strong) NSString *Recipient;
@property(nonatomic,strong) NSString *Moble;
@property(nonatomic,strong) NSNumber *IsDefault;
@property(nonatomic,strong) NSString *Province;
@property(nonatomic,strong) NSString *City;
@property(nonatomic,strong) NSString *District;
@property(nonatomic,strong) NSString *FullAddress;
@property(nonatomic,strong) NSString *FullAddressOnly;
@property(nonatomic,strong) NSString *Address;
@property(nonatomic,strong) NSString *AddrId;
@property(nonatomic,strong) NSString *CityId;
@property(nonatomic,strong) NSString *RegionId;

//收款银行卡列表
@property(nonatomic,strong) NSString *bank_name;
@property(nonatomic,strong) NSString *bank_no;
@property(nonatomic,strong) NSString *BankAccountNo;
@property(nonatomic,strong) NSString *BankName;

//我的钱包
@property(nonatomic,strong) NSString *ChangeModeString;
@property(nonatomic,strong) NSString *ChangeMoney;
@property(nonatomic,strong) NSString *CreateDate;
@property(nonatomic,strong) NSString *Operator;
@property(nonatomic,strong) NSString *OriginalMoney;
@property(nonatomic,strong) NSString *Remarks;


@property(nonatomic,strong) NSString *integral_type;


@property(nonatomic,strong) NSString *is_certified;

//代理信息
//@property(nonatomic,strong) NSString *AgentName;
//@property(nonatomic,strong) NSString *CreateDate;
@property(nonatomic,strong) NSString *Discount;
@property(nonatomic,strong) NSString *IsApplyJoin;
@property(nonatomic,strong) NSString *JoinMoney;
@property(nonatomic,strong) NSString *Level;
@property(nonatomic,strong) NSString *UserCount;
//@property(nonatomic,strong) NSString *ApplyMoney;
@property(nonatomic,strong) NSString *IsApply;
@property(nonatomic,strong) NSString *IsVerifyMobile;
@property(nonatomic,strong) NSDictionary *ApplyName;

//评价统计信息
@property(nonatomic,strong) NSString *describeScore;
@property(nonatomic,strong) NSString *totalCount;
@property(nonatomic,strong) NSString *hasImageCount;
@property(nonatomic,strong) NSString *goodEvaluateProportion;

//物流信息
@property(nonatomic,strong) NSArray *data;
@property(nonatomic,strong) NSString *stateName;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *orderNumber;
@property(nonatomic,strong) NSString *productIcon;
@property(nonatomic,strong) NSString *company;


//快递公司
@property(nonatomic,strong) NSString *comcontact;
@property(nonatomic,strong) NSString *nu;
@property(nonatomic,strong) NSNumber *ischeck;

//我的门店
@property(nonatomic,strong) NSString *store_address;
@property(nonatomic,strong) NSString *store_id;
@property(nonatomic,strong) NSString *store_image;
@property(nonatomic,strong) NSString *store_name;
@property(nonatomic,strong) NSString *store_phone;

//我的分销商
//@property(nonatomic,strong) NSString *BuyTotal;
//@property(nonatomic,strong) NSString *CreateDate;
@property(nonatomic,strong) NSString *HeadLogo;
//@property(nonatomic,strong) NSString *Level;
@property(nonatomic,strong) NSString *Name;
@property(nonatomic,strong) NSString *Phone;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *icon;

//分销总佣金
@property(nonatomic,strong) NSString *HistoryCommission;
@property(nonatomic,strong) NSString *TotalComm;
@property(nonatomic,strong) NSString *YestodayComm;
//门店收益
@property(nonatomic,strong) NSString *history_commission;
@property(nonatomic,strong) NSString *total_comm;
@property(nonatomic,strong) NSString *yestoday_comm;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *order_date;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *product_sku_name;
@property(nonatomic,strong) NSString *store_reward;
@property(nonatomic,strong) NSString *store_rebate;

//分销佣金
@property(nonatomic,strong) NSString *OrderInfo_Id;
@property(nonatomic,strong) NSString *TradeTime;
@property(nonatomic,strong) NSString *UserCommission;
@property(nonatomic,strong) NSString *CommTotal;
//代理佣金
@property(nonatomic,strong) NSString *remain_bonus;
@property(nonatomic,strong) NSString *history_total_bonus;
@property(nonatomic,strong) NSString *yesterday_bonus;

//@property(nonatomic,strong) NSString *oid;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *bonus_value;
@property(nonatomic,strong) NSString *bonus_result;

@end

@interface HHExpress_message_list : BaseModel
@property(nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *context;

@end

