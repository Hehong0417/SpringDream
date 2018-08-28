//
//  HHServiceCell_two.m
//  springDream
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHServiceCell_two.h"
#import "HHShippingAddressVC.h"
#import "HHModifyInfoVC.h"

@implementation HHServiceCell_two

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        NSArray *btn_image_arr = @[@"service_11",@"service_12",@"service_13",@"service_14"];
        NSArray *btn_title_arr = @[@"地址管理",@"会员权益",@"会员互动",@"基础设置"];
        HHModelsView *models_view = [HHModelsView createModelViewWithFrame:CGRectMake(0, 0, ScreenW, 95) btn_image_arr:btn_image_arr btn_title_arr:btn_title_arr title_color:kDarkGrayColor lineCount:5 message_arr:@[] title_image_padding:10 top_padding:0];
        models_view.delegate = self;
        [self.contentView addSubview:models_view];
    }
    
    return self;
}
- (void)modelButtonDidSelectWithButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex:%ld",buttonIndex);
    
    if (buttonIndex == 0) {
        //地址管理
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        [self.nav pushVC:vc];
        
    }else if (buttonIndex == 1){
        //会员权益
        
    }else if (buttonIndex == 2){
       // 会员互动
        
    }else if (buttonIndex == 3){
        
        //基础设置
        HHModifyInfoVC *vc = [HHModifyInfoVC new];
        [self.nav pushVC:vc];
       
    }
}
@end
