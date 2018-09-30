//
//  SDPostTimeLinePicItem.h
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface SDPostTimeLinePicItem : BaseModel

singleton_h(SDPostTimeLinePicItem)

@property (nonatomic, copy) NSMutableArray *ContentECSubjectPicModel;

@end
@interface ContentECSubjectPicModel : BaseModel

@property (nonatomic, copy) NSString *PicUrl;
@property (nonatomic, copy) NSString *Priority;

@end
