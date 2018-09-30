//
//  SDPostContentModel.h
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface SDPostContentModel : BaseModel

@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *SubjectContent;
@property (nonatomic, copy) NSString *UserId;

@property (nonatomic, copy) NSArray *ContentECSubjectPicModel;

@end
