//
//  SDPostTimeLinePicItem.m
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "SDPostTimeLinePicItem.h"

@implementation SDPostTimeLinePicItem

 singleton_m(SDPostTimeLinePicItem)

- (instancetype)init {
    
    SDPostTimeLinePicItem *localUser = [SDPostTimeLinePicItem read];
    
    if (localUser) {
        _instance = localUser;
    } else {
        
        _instance = [super init];
    }
    
    return _instance;
}

- (NSMutableArray *)ContentECSubjectPicModel{
    if (!_ContentECSubjectPicModel) {
        _ContentECSubjectPicModel = [NSMutableArray array];
    }
    return _ContentECSubjectPicModel;
}
@end
@implementation ContentECSubjectPicModel : BaseModel

@end
