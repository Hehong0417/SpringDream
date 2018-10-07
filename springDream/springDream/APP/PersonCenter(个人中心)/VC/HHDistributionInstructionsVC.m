//
//  HHDistributionInstructionsVC.m
//  springDream
//
//  Created by User on 2018/10/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDistributionInstructionsVC.h"

@interface HHDistributionInstructionsVC ()

@end

@implementation HHDistributionInstructionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分销说明";
    
    UITextView *textView = [UITextView lh_textViewWithFrame:self.view.bounds font:FONT(14) backgroundColor:kWhiteColor];
    textView.text = @"分销说明";
    [self.view addSubview:textView];
    
    
    
}


@end
