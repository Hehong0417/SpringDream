//
//  SDListModel.m
//  springDream
//
//  Created by User on 2018/10/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "SDListModel.h"

@implementation SDListModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"List":[SDTimeLineModel class]};
}

@end
