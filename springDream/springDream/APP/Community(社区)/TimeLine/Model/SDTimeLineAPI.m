//
//  SDTimeLineAPI.m
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "SDTimeLineAPI.h"

@implementation SDTimeLineAPI

+ (instancetype)GetContentECSubjectListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize commentLimit:(NSNumber *)commentLimit{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_ContentECSubject;
    if (commentLimit) {
        [api.parameters setObject:commentLimit forKey:@"commentLimit"];
    }
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
+ (instancetype)GetCommentsWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize subjectId:(NSString *)subjectId{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_GetComments;
    if (subjectId) {
        [api.parameters setObject:subjectId forKey:@"subjectId"];
    }
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
    if (subjectId) {
//        [api.parameters setObject:subjectId forKey:@"subjectId"];
        api.subUrl =  [NSString stringWithFormat:@"%@?subjectId=%@&userId=0",API_PriseUnPrise,subjectId];
    }
//    [api.parameters setObject:@"0" forKey:@"userId"];

    api.parametersAddToken = NO;
    return api;
}

+ (instancetype)postCommentWithsubjectId:(NSString *)subjectId comment:(NSString *)comment{
    
    SDTimeLineAPI *api = [self new];
//    api.subUrl = API_Comment;

//    if (comment) {
//        [api.parameters setObject:comment forKey:@"comment"];
//    }
    if (subjectId) {
//        [api.parameters setObject:subjectId forKey:@"subjectId"];
        api.subUrl =  [NSString stringWithFormat:@"%@?subjectId=%@&userId=0&comment=%@",API_Comment,subjectId,[comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    }
    api.parametersAddToken = NO;
    return api;
}
//发表评论
+ (instancetype)postComment_AddWithContentECSubjectModel:(NSDictionary *)ContentECSubjectModel{
    
    SDTimeLineAPI *api = [self new];
    api.subUrl = API_Comment_Add;
    if (ContentECSubjectModel) {
        [api.parameters setObject:ContentECSubjectModel forKey:@"ContentECSubjectModel"];
    }
    api.parametersAddToken = NO;
    return api;
}


@end
