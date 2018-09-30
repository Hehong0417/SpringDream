//
//  SDTimeLineAPI.m
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "SDTimeLineAPI.h"

@implementation SDTimeLineAPI

+ (instancetype)GetContentECSubjectListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_ContentECSubject;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
//    [api.parameters setObject:@"1" forKey:@"status"];

    return api;
}
+ (instancetype)postPriseUnPriseWithsubjectId:(NSString *)subjectId{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_PriseUnPrise;
    if (subjectId) {
        [api.parameters setObject:subjectId forKey:@"subjectId"];
    }
    api.parametersAddToken = NO;
    return api;
}
+ (instancetype)postCommentWithsubjectId:(NSString *)subjectId comment:(NSString *)comment{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_Comment;
    if (comment) {
        [api.parameters setObject:comment forKey:@"comment"];
    }
    if (subjectId) {
        [api.parameters setObject:subjectId forKey:@"subjectId"];
    }
    api.parametersAddToken = NO;
    return api;
}
//发表评论
+ (instancetype)postComment_AddWithContentECSubjectModel:(NSString *)ContentECSubjectModel{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_Comment_Add;
    if (ContentECSubjectModel) {
        [api.parameters setObject:ContentECSubjectModel forKey:@"ContentECSubjectModel"];
    }
    api.parametersAddToken = NO;
    return api;
}


@end
