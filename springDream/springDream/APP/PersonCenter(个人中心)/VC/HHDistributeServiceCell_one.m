//
//  HHDistributeServiceCell_one.m
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDistributeServiceCell_one.h"
#import "HHCouponSuperVC.h"
#import "HHMyCollectionVC.h"
#import "HHMyWalletVC.h"
#import "HHMyIntegralVC.h"

@implementation HHDistributeServiceCell_one

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        NSArray *btn_image_arr = @[@"service_01",@"service_02",@"service_03",@"service_04"];
        NSArray *btn_title_arr = @[@"分销专题",@"一级",@"二级",@"三级"];
        self.models_view = [HHModelsView createModelViewWithFrame:CGRectMake(0, 0, ScreenW, 95) btn_image_arr:btn_image_arr btn_title_arr:btn_title_arr title_color:kDarkGrayColor lineCount:5 message_arr:@[] title_image_padding:10 top_padding:0];
        self.models_view.delegate = self;
        [self.contentView addSubview:self.models_view];
    }
    
    return self;
}
- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex:%ld",buttonIndex);
  
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
