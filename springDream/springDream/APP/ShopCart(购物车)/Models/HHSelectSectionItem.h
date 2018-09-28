//
//  HHSelectItem.h
//  springDream
//
//  Created by User on 2018/9/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHSelectRowItem;
@interface HHSelectSectionItem : BaseModel

@property (nonatomic, strong) NSArray  <HHSelectRowItem *>*selectRow_Arr;

@end
@interface HHSelectRowItem : BaseModel

@property (nonatomic, strong) NSNumber  *row_selected;

@end
