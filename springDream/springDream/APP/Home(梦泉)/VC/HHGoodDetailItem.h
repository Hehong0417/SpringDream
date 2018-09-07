//
//  HHGoodDetailItem.h
//  springDream
//
//  Created by User on 2018/9/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHGoodDetailItem : BaseModel
singleton_h(GoodDetailItem)

@property(nonatomic,strong) NSString *product_stock;

@end
