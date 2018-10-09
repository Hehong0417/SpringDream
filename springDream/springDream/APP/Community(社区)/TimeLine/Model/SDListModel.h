//
//  SDListModel.h
//  springDream
//
//  Created by User on 2018/10/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"
#import "SDTimeLineModel.h"

@interface SDListModel : BaseModel

@property (nonatomic, copy) NSArray<SDTimeLineModel *> *List;

@end
