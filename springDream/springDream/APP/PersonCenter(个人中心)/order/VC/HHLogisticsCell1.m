//
//  HHLogisticsCell1.m
//  Store
//
//  Created by User on 2018/1/31.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHLogisticsCell1.h"

@implementation HHLogisticsCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HHExpress_message_list *)model{
    _model = model;
    
    self.timeLabel.text = model.time?model.time:@"";
    self.express_messageLabe.text = model.context?model.context:@"";
    
}
@end
