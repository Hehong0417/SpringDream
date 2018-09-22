//
//  HHAuthenticationVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAuthenticationVC.h"
#import "BXTextField.h"

@interface HHAuthenticationVC ()
{
    UIImageView *_phone_imagV;
    UIImageView *_code_imagV;
    UITextField *_name_textfield;
    BXTextField *_bXTextField;
    UIButton *_commit_button;

}
@end

@implementation HHAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";

    _phone_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25),WidthScaleSize_H(30), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"phone"]];
    _phone_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_phone_imagV];
    
    _name_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(_phone_imagV.frame)+10, _phone_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30)) placeholder:@"输入姓名" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.view addSubview:_name_textfield];
    
    UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(_phone_imagV.mj_x,CGRectGetMaxY(_phone_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line];
    
    
    _code_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(25), CGRectGetMaxY(_name_textfield.frame)+WidthScaleSize_H(20), WidthScaleSize_H(30), WidthScaleSize_H(30)) image:[UIImage imageNamed:@"v_code"]];
    _code_imagV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_code_imagV];
    
    _bXTextField = [[BXTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_code_imagV.frame)+10, _code_imagV.mj_y, ScreenW-CGRectGetMaxX(_phone_imagV.frame)-10-WidthScaleSize_W(25), WidthScaleSize_H(30))];
    _bXTextField.placeholder = @"输入本人身份证";
    _bXTextField.font = FONT(14);
    _bXTextField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_bXTextField];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_imagV.mj_x,CGRectGetMaxY(_code_imagV.frame)+WidthScaleSize_H(8), ScreenW-WidthScaleSize_W(50), 1) backColor:KVCBackGroundColor];
    [self.view addSubview:h_line_1];
    
    
    _commit_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20), CGRectGetMaxY(h_line_1.frame)+WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(_commit_buttonAction:) title:@"提交" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [_commit_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_commit_button];
    
}
- (void)_commit_buttonAction:(UIButton *)button{
    
    
    
    
}
@end
