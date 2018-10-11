//
//  HHdelegateServiceCell.m
//  springDream
//
//  Created by User on 2018/10/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdelegateServiceCell.h"

@implementation HHdelegateServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        NSArray *btn_image_arr  = @[@"sub_service_01",@"sub_service_02",@"",@""];
        NSArray *btn_title_arr = @[@"代理佣金",@"我的代理",@"",@""];
        self.models_view = [HHModelsView createModelViewWithFrame:CGRectMake(0, -6, ScreenW, 85) btn_image_arr:btn_image_arr btn_title_arr:btn_title_arr title_color:TitleGrayColor lineCount:5 message_arr:@[] title_image_padding:1 top_padding:0];
        self.models_view.delegate = self;
        [self.contentView addSubview:self.models_view];
    }
    return self;
}
- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(serviceModelButtonDidSelectWithButtonIndex: cell:)]) {
        [self.delegate serviceModelButtonDidSelectWithButtonIndex:buttonIndex cell:self];
    }
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
