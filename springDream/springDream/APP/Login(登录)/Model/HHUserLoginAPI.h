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
+ (instancetype)postApiLoginWithUseWay:(NSNumber *)UseWay Phone:(NSString *)Phone OpenId:(NSString *)OpenId Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode;
//注册
+ (instancetype)postRegsterWithUseWay:(NSNumber *)UseWay Phone:(NSString *)Phone OpenId:(NSString *)OpenId Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode InviteCode:(NSString *)InviteCode UserImage:(NSString *)UserImage;
//银行卡绑定
+ (instancetype)postBindBankCardInformationWithUserId:(NSString *)UserId BankAccountNo:(NSString *)BankAccountNo BankAccountName:(NSString *)BankAccountName BankName :(NSString *)BankName AccountOpeningBranch:(NSString *)AccountOpeningBranch Tel:(NSString *)Tel;
//身份证绑定
+ (instancetype)postBindCardIDInformationWithUserId:(NSString *)UserId RealName:(NSString *)RealName CardID:(NSString *)CardID;

//发送短信验证码
+ (instancetype)postSmsSendCodeWithmobile:(NSString *)mobile;

//手机号登录
+ (instancetype)postIOSAuthenticationLoginWithphone:(NSString *)phone psw:(NSString *)psw;

@end
