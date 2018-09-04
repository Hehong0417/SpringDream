//
//  HHLogisticsHead.m
//  springDream
//
//  Created by User on 2018/9/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHLogisticsHead.h"

@implementation HHLogisticsHead

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.image_url lh_setCornerRadius:0 borderWidth:1 borderColor:KVCBackGroundColor];
    
}
@end
