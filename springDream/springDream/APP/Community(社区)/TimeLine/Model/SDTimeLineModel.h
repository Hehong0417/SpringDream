//
//  SDTimeLineModel.h
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel,SDContentECSubjectPicModel;

@interface SDTimeLineModel : BaseModel

@property (nonatomic, copy) NSString *UserImage;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *SubjectContent;
@property (nonatomic, copy) NSString *UploadDateTime;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *PraiseCount;
@property (nonatomic, copy) NSNumber *IsPraise;
@property (nonatomic, copy) NSString *SubjectId;

@property (nonatomic, strong) NSArray <SDContentECSubjectPicModel *>*ContentECSubjectPicModel;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<SDTimeLineCellCommentItemModel *> *ContentECSubjectCommentModel;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;


@end


@interface SDTimeLineCellLikeItemModel : BaseModel

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface SDTimeLineCellCommentItemModel : BaseModel

@property (nonatomic, copy) NSString *Comment;

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *SubjectId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end
//图片模型
@interface SDContentECSubjectPicModel : BaseModel

@property (nonatomic, copy) NSString *PicUrl;
@property (nonatomic, copy) NSString *Priority;
@property (nonatomic, copy) NSString *SubjectId;
@property (nonatomic, copy) NSString *SubjectPicId;
@property (nonatomic, copy) NSString *UpLoadDateTime;
@property (nonatomic, copy) NSString *UserName;

@end

