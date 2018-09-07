//
//  HHGoodDetailItem.m
//  springDream
//
//  Created by User on 2018/9/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodDetailItem.h"

@implementation HHGoodDetailItem

singleton_m(GoodDetailItem)

- (instancetype)init {
    
    HHGoodDetailItem *localUser = [HHGoodDetailItem read];
    
    if (localUser) {
        _instance = localUser;
    } else {
        
        _instance = [super init];
    }
    
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    
    return copy;
}
@end
