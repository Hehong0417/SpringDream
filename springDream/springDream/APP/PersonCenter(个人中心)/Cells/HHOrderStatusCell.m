//
//  HHOrderStatusCell.m
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderStatusCell.h"
#import "HHOrderVC.h"

@implementation HHOrderStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        NSArray *btn_image_arr = @[@"order_01",@"order_02",@"order_03",@"order_04",@"order_05"];
        NSArray *btn_title_arr = @[@"待付款",@"待发货",@"已发货",@"待评价",@"退款/售后"];
        NSArray *message_arr = @[@"0",@"0",@"0",@"0",@"0"];

        self.models_view = [HHModelsView createModelViewWithFrame:CGRectMake(0, -6, ScreenW, 70) btn_image_arr:btn_image_arr btn_title_arr:btn_title_arr title_color:kDarkGrayColor lineCount:5 message_arr:message_arr title_image_padding:1 top_padding:0];
        self.models_view.delegate = self;
        [self.contentView addSubview:self.models_view];

    }
    return self;
}
- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex:%ld",buttonIndex);
    
    HHOrderVC *vc = [HHOrderVC new];
    vc.sg_selectIndex = buttonIndex+1;
    vc.button_tag = buttonIndex+1;
    [self.nav pushVC:vc];
}
- (void)setMessage_arr:(NSArray *)message_arr{
    
    _message_arr = message_arr;
    
    self.models_view.message_count = message_arr;
    
}

@end
