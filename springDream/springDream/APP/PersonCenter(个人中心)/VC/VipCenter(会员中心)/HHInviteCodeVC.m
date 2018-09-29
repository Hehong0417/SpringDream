//
//  HHInviteCodeVC.m
//  springDream
//
//  Created by User on 2018/9/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHInviteCodeVC.h"

@interface HHInviteCodeVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *text_field;
@property(nonatomic,strong) NSMutableArray *text_field_arr;

@end

@implementation HHInviteCodeVC

- (NSMutableArray *)text_field_arr{
    if (!_text_field_arr) {
        _text_field_arr = [NSMutableArray array];
    }
    return _text_field_arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImageView *bg_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*494/750) image:[UIImage imageNamed:@"recom"]];
    [self.view addSubview:bg_imagV];

    
    UIButton *back_btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 30, 50, 45) target:self action:@selector(backAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [self.view addSubview:back_btn];

    UILabel *code_text_label = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(bg_imagV.frame)+20, 300, 30)];

    [self.view addSubview:code_text_label];

    CGFloat tf_w = 35;
    CGFloat tf_h = 35;
    CGFloat margin = (ScreenW-70*2-tf_w*4)/3;
    CGFloat left_padding = 70;
    for (NSInteger i = 0; i<4; i++) {
        self.text_field = [[UITextField alloc] initWithFrame:CGRectMake(left_padding+i*(margin+tf_w), CGRectGetMaxY(code_text_label.frame)+30, tf_w, tf_h)];
        self.text_field.textAlignment = NSTextAlignmentCenter;
        self.text_field.delegate = self;
        [self.text_field lh_setCornerRadius:2 borderWidth:1 borderColor:APP_COMMON_COLOR];
        self.text_field.keyboardType = UIKeyboardTypeASCIICapable;
        if (i == 0) {
            self.text_field.enabled = YES;
        }else{
            self.text_field.enabled = NO;
        }
        self.text_field.tag = 10000+i;
        [self.text_field_arr addObject:self.text_field];
        [self.view addSubview:self.text_field];
    }
    
    UIButton *generate_code_button = [UIButton lh_buttonWithFrame:CGRectMake(20,CGRectGetMaxY(code_text_label.frame)+50+120, ScreenW-40, 44) target:self action:@selector(generateCodeAction:) image:nil title:@"生成邀请码" titleColor:kWhiteColor font:FONT(14)];
    [generate_code_button lh_setCornerRadius:2 borderWidth:0 borderColor:nil];
    [generate_code_button setBackgroundColor:APP_NAV_COLOR];
    [self.view addSubview:generate_code_button];
    
    if (self.IsGenerateCode == YES) {
        code_text_label.text = @"动态邀请码";
        self.text_field.enabled = NO;
        generate_code_button.hidden = NO;
    }else{
        code_text_label.text = @"输入动态邀请码";
        self.text_field.enabled = YES;
        UITextField *text_field = [self.view viewWithTag:10000];
        [text_field becomeFirstResponder];
        generate_code_button.hidden = YES;
    }
}
- (void)backAction{
    
    [self.navigationController popVC];
}
//生成邀请码
- (void)generateCodeAction:(UIButton *)button{
    
    [[[HHMineAPI GetRecommendCode] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                for (NSInteger i = 0; i<4; i++) {
                    UITextField *text_field = self.text_field_arr[i];
                    NSString *text = [api.Data substringWithRange:NSMakeRange(i, 1)];
                    text_field.text = text;
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    

}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger current_index = textField.tag - 10000;
    if (current_index<3) {
        textField.enabled = NO;
        textField.text = string;
            UITextField   *next_textFiled = self.text_field_arr[current_index+1];
            next_textFiled.enabled = YES;
            [next_textFiled becomeFirstResponder];
    }else{
        textField.text = string;
        [textField resignFirstResponder];
        [self commitInviteCode];
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (toBeString.length > 1 && range.length!=1){
        textField.text = [toBeString substringToIndex:1];
        textField.enabled = NO;
        return NO;
    }
    return YES;
}
- (void)commitInviteCode{

    NSMutableArray *recom_arr = [NSMutableArray array];
     for (NSInteger i = 0; i<4; i++)
     {
        UITextField *text_field = self.text_field_arr[i];
         [recom_arr addObject: text_field.text];
    }
    NSString *code = [recom_arr componentsJoinedByString:@""];
    if (code.length>0) {
        [[[HHMineAPI ValidateRecommendCodeWithCode:code] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {

                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showSuccessWithStatus:@"邀请成功！"];
                    [self.navigationController popVC];
                    
                }else{
                    
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
    }

        
//        for (NSInteger i=0; i<self.text_field_arr.count; i++) {
//            UITextField *text_field = self.text_field_arr[i];
//            text_field.text = @"";
//            if (i == 0) {
//                text_field.enabled = YES;
//                [text_field becomeFirstResponder];
//            }
//        }
//
//    });
    
    
}
@end
