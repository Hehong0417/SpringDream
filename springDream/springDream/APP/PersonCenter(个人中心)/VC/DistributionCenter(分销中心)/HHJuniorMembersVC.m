//
//  HHJuniorMembersVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHJuniorMembersVC.h"
#import "HHMydistributorsVC.h"

@interface HHJuniorMembersVC ()<SGSegmentedControlDelegate>

@property(nonatomic,strong)     SGSegmentedControl *SG;
@property (nonatomic, strong)   NSMutableArray *title_arr;

@end

@implementation HHJuniorMembersVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"下级会员";
    UIView *head = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(70)) backColor:kWhiteColor];
    [self.view addSubview:head];
    
    UILabel *bankInfo_title_label = [UILabel lh_labelWithFrame:CGRectMake(0, WidthScaleSize_H(14), ScreenW, WidthScaleSize_H(18)) text:@"当前会员人数" textColor:kDarkGrayColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    [head addSubview:bankInfo_title_label];
    
    UILabel *bankInfo_title_label2 = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(bankInfo_title_label.frame), ScreenW, WidthScaleSize_H(18)) text:@"49999999" textColor:APP_COMMON_COLOR font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    [head addSubview:bankInfo_title_label2];
    
    [self setupSGSegmentedControl];
}
#pragma mark - SGSegmentedControl init

- (void)setupSGSegmentedControl{
    
    self.title_arr = [NSMutableArray arrayWithArray:@[@"一级",@"二级",@"三级"]];
    
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, WidthScaleSize_H(70)+WidthScaleSize_H(8), self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, WidthScaleSize_H(70)+WidthScaleSize_H(8), self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    self.SG.titleColorStateNormal = kBlackColor;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(13);
    self.SG.showsBottomScrollIndicator = NO;
    [self.view addSubview:_SG];
    
    HHMydistributorsVC *vc = [[HHMydistributorsVC alloc]init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];

}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index{
    
    
    
}

@end
