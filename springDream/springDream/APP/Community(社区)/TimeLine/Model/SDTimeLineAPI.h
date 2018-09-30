//
//  SDTimeLineAPI.h
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface SDTimeLineAPI : BaseAPI

+ (instancetype)GetContentECSubjectListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize;


+ (instancetype)postPriseUnPriseWithsubjectId:(NSString *)subjectId;
+ (instancetype)postCommentWithsubjectId:(NSString *)subjectId comment:(NSString *)comment;
//发表评论
+ (instancetype)postComment_AddWithContentECSubjectModel:(NSString *)ContentECSubjectModel;

@end
