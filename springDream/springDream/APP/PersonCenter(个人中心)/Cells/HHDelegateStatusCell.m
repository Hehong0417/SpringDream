//
//  HHDelegateStatusCell.m
//  springDream
//
//  Created by User on 2018/9/26.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDelegateStatusCell.h"

@implementation HHDelegateStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        NSArray *btn_image_arr = @[@"delegate_01",@"distribute_02",@"distribute_04",@"distribute_03"];
        NSArray *btn_title_arr =  @[@"代理商品",@"分销商",@"会员",@"团队订单"];
        NSArray *message_arr = @[@"0",@"0",@"0",@"0"];
    
        self.models_view = [HHModelsView createModelViewWithFrame:CGRectMake(0, -6, ScreenW, 70) btn_image_arr:btn_image_arr btn_title_arr:btn_title_arr title_color:kDarkGrayColor lineCount:4 message_arr:message_arr title_image_padding:1 top_padding:0];
        self.models_view.delegate = self;
        [self.contentView addSubview:self.models_view];
        
    }
    return self;
}
- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(modelButtonDidSelectWithButtonIndex:StatusCell:)]) {
        [self.delegate modelButtonDidSelectWithButtonIndex:buttonIndex StatusCell:self];
    }
}

- (void)setMessage_arr:(NSArray *)message_arr{
    
    _message_arr = message_arr;
    
    self.models_view.message_count = message_arr;
    
}
- (void)setBtn_image_arr:(NSArray *)btn_image_arr{
    _btn_image_arr = btn_image_arr;
    self.models_view.btn_image_arr = btn_image_arr;
}

- (void)setBtn_title_arr:(NSArray *)btn_title_arr{
    _btn_title_arr = btn_title_arr;
    self.models_view.btn_title_arr = btn_title_arr;
}
@end
