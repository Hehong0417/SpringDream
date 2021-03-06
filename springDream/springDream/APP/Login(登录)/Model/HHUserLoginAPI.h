//
//  HHGetAccess_TokenAPI.h
//  CredictCard
//
//  Created by User on 2017/12/22.
//  Copyright © 2017年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHUserLoginAPI : BaseAPI

#pragma mark - post

//登录
+ (instancetype)postApiLoginWithUseWay:(NSNumber *)UseWay Phone:(NSString *)Phone OpenId:(NSString *)OpenId Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode unionId:(NSString *)unionId;
//注册
+ (instancetype)postRegsterWithUseWay:(NSNumber *)UseWay Phone:(NSString *)Phone OpenId:(NSString *)OpenId Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode InviteCode:(NSString *)InviteCode UserImage:(NSString *)UserImage unionId:(NSString *)unionId;
//银行卡绑定
+ (instancetype)postBindBankCardInformationWithUserId:(NSString *)UserId BankAccountNo:(NSString *)BankAccountNo BankAccountName:(NSString *)BankAccountName BankName :(NSString *)BankName AccountOpeningBranch:(NSString *)AccountOpeningBranch Tel:(NSString *)Tel;
//身份证绑定
+ (instancetype)postBindCardIDInformationWithUserId:(NSString *)UserId RealName:(NSString *)RealName CardID:(NSString *)CardID;

//发送短信验证码
+ (instancetype)postSmsSendCodeWithmobile:(NSString *)mobile;

//1.15绑定微信
+ (instancetype)postBindWeiXinWithOpenId:(NSString *)OpenId UnionId:(NSString *)UnionId UserImage:(NSString *)UserImage;
//1.16修改密码
+ (instancetype)postUpdatePasswordWithOldPassword:(NSString *)OldPassword Password:(NSString *)Password;
//1.17手机验证码修改密码
+ (instancetype)postUpdatePasswordToPhoneWithPhone:(NSString *)Phone Password:(NSString *)Password VerificationCode:(NSString *)VerificationCode;


//手机号登录
+ (instancetype)postIOSAuthenticationLoginWithphone:(NSString *)phone psw:(NSString *)psw;

@end
