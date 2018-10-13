//
//  HHGetAccess_TokenAPI.m
//  CredictCard
//
//  Created by User on 2017/12/22.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHUserLoginAPI.h"

@implementation HHUserLoginAPI

//登录
+ (instancetype)postApiLoginWithUseWay:(NSNumber *)UseWay Phone:(NSString *)Phone OpenId:(NSString *)OpenId Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode unionId:(NSString *)unionId{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_Login;
    api.parametersAddToken = NO;
    if (UseWay) {
        [api.parameters setObject:UseWay forKey:@"UseWay"];
    }
    if (Phone) {
        [api.parameters setObject:Phone forKey:@"Phone"];
    }
    if (OpenId) {
        [api.parameters setObject:OpenId forKey:@"OpenId"];
    }
    if (Pwd) {
        [api.parameters setObject:Pwd forKey:@"Pwd"];
    }
    if (VerificationCode) {
        [api.parameters setObject:VerificationCode forKey:@"VerificationCode"];
    }
    if (unionId) {
        [api.parameters setObject:unionId forKey:@"unionId"];
    }
    [api.parameters setObject:@"1" forKey:@"ClientInfo_Id"];

    return api;
}
//注册
+ (instancetype)postRegsterWithUseWay:(NSNumber *)UseWay Phone:(NSString *)Phone OpenId:(NSString *)OpenId Pwd:(NSString *)Pwd VerificationCode:(NSString *)VerificationCode  InviteCode:(NSString *)InviteCode UserImage:(NSString *)UserImage unionId:(NSString *)unionId{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_Register;
    api.parametersAddToken = NO;
    if (UseWay) {
        [api.parameters setObject:UseWay forKey:@"UseWay"];
    }
    if (Phone) {
        [api.parameters setObject:Phone forKey:@"Phone"];
    }
    if (OpenId) {
        [api.parameters setObject:OpenId forKey:@"OpenId"];
    }
    if (Pwd) {
        [api.parameters setObject:Pwd forKey:@"Pwd"];
    }
    if (VerificationCode) {
        [api.parameters setObject:VerificationCode forKey:@"VerificationCode"];
    }
    if (InviteCode) {
        [api.parameters setObject:InviteCode forKey:@"InviteCode"];
    }
    if (UserImage) {
        [api.parameters setObject:UserImage forKey:@"UserImage"];
    }
    if (unionId) {
        [api.parameters setObject:unionId forKey:@"unionId"];
    }
    [api.parameters setObject:@"1" forKey:@"ClientInfo_Id"];

    return api;
    
}
//身份证绑定
+ (instancetype)postBindCardIDInformationWithUserId:(NSString *)UserId RealName:(NSString *)RealName CardID:(NSString *)CardID{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_BindCardIDInformation;
    api.parametersAddToken = NO;
    if (UserId) {
        [api.parameters setObject:UserId forKey:@"UserId"];
    }
    if (RealName) {
        [api.parameters setObject:RealName forKey:@"RealName"];
    }
    if (CardID) {
        [api.parameters setObject:CardID forKey:@"CardID"];
    }
   
    return api;
    
}
//银行卡绑定
+ (instancetype)postBindBankCardInformationWithUserId:(NSString *)UserId BankAccountNo:(NSString *)BankAccountNo BankAccountName:(NSString *)BankAccountName BankName :(NSString *)BankName AccountOpeningBranch:(NSString *)AccountOpeningBranch Tel:(NSString *)Tel{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_BindBankCardInformation;
    api.parametersAddToken = NO;
    if (UserId) {
        [api.parameters setObject:UserId forKey:@"UserId"];
    }
    if (BankAccountNo) {
        [api.parameters setObject:BankAccountNo forKey:@"BankAccountNo"];
    }
    if (BankAccountName) {
        [api.parameters setObject:BankAccountName forKey:@"BankAccountName"];
    }
    if (BankName) {
        [api.parameters setObject:BankName forKey:@"BankName"];
    }
    if (AccountOpeningBranch) {
        [api.parameters setObject:AccountOpeningBranch forKey:@"AccountOpeningBranch"];
    }
    if (Tel) {
        [api.parameters setObject:Tel forKey:@"Tel"];
    }
    return api;
    
}

//发送短信验证码
+ (instancetype)postSmsSendCodeWithmobile:(NSString *)mobile{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_Sms_SendCode;
    api.parametersAddToken = NO;
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    return api;
    
}
//1.15绑定微信
+ (instancetype)postBindWeiXinWithOpenId:(NSString *)OpenId UnionId:(NSString *)UnionId UserImage:(NSString *)UserImage{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_BindWeiXin;
    api.parametersAddToken = NO;
    if (OpenId) {
        [api.parameters setObject:OpenId forKey:@"OpenId"];
    }
    if (UnionId) {
        [api.parameters setObject:UnionId forKey:@"UnionId"];
    }
    if (UnionId) {
        [api.parameters setObject:UnionId forKey:@"UnionId"];
    }
    if (UserImage) {
        [api.parameters setObject:UserImage forKey:@"UserImage"];
    }
    return api;
}

//1.16修改密码
+ (instancetype)postUpdatePasswordWithOldPassword:(NSString *)OldPassword Password:(NSString *)Password{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_UpdatePassword;
    api.parametersAddToken = NO;
    if (OldPassword) {
        [api.parameters setObject:OldPassword forKey:@"OldPassword"];
    }
    if (Password) {
        [api.parameters setObject:Password forKey:@"Password"];
    }
    
    return api;
}
//1.17手机验证码修改密码
+ (instancetype)postUpdatePasswordToPhoneWithPhone:(NSString *)Phone Password:(NSString *)Password VerificationCode:(NSString *)VerificationCode{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_UpdatePasswordToPhone;
    api.parametersAddToken = NO;

    if (Phone) {
        [api.parameters setObject:Phone forKey:@"Phone"];
    }
    if (Password) {
        [api.parameters setObject:Password forKey:@"Password"];
    }
    if (VerificationCode) {
        [api.parameters setObject:VerificationCode forKey:@"VerificationCode"];
    }
    [api.parameters setObject:@"1" forKey:@"ClientInfo_Id"];

    return api;
}


//手机号登录
+ (instancetype)postIOSAuthenticationLoginWithphone:(NSString *)phone psw:(NSString *)psw{
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_IOSAuthenticationLogin;
    api.parametersAddToken = NO;
    if (phone) {
        [api.parameters setObject:phone forKey:@"phone"];
    }
    if (psw) {
        [api.parameters setObject:psw forKey:@"psw"];
    }
    [api.parameters setObject:Cid forKey:@"cid"];

    return api;
}

@end
