//
//  HHBandCardVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBandCardVC.h"
#import "HHTextfieldcell.h"

@interface HHBandCardVC ()<UITextFieldDelegate>

@end

@implementation HHBandCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定银行卡";
    
    self.view.backgroundColor = KVCBackGroundColor;
    
    UIView *tableHeaderView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(50)) backColor:KVCBackGroundColor];
    UILabel *bankInfo_title_label = [UILabel lh_labelWithFrame:CGRectMake(20, 0, ScreenW-40, WidthScaleSize_H(50)) text:@"银行卡信息" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [tableHeaderView addSubview:bankInfo_title_label];
    self.tableView.tableHeaderView = tableHeaderView;

    
    UIView *tableFooterView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(90)) backColor:KVCBackGroundColor];
    
     UIButton  *commit_button = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(20),WidthScaleSize_H(35), ScreenW-WidthScaleSize_W(40), WidthScaleSize_H(44)) target:self action:@selector(commit_buttonAction:) title:@"提交" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_NAV_COLOR];
    [commit_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [tableFooterView addSubview:commit_button];

    self.tableView.tableFooterView = tableFooterView;

    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *title_arr = @[@"银行卡号",@"开户行",@"开户名",@"开户网点",@"开户手机号"];
    NSArray *placeholder_arr = @[@"请输入银行卡号",@"请选择开户行",@"请输入开户名",@"请输入开户网点",@"请输入预留手机号码"];

    HHTextfieldcell  *cell = [[HHTextfieldcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputTextField.tag = indexPath.row+10000;
    cell.titleLabel.text = title_arr[indexPath.row];
    if (indexPath.row == 0) {
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTextField.delegate = self;
    }
    if (indexPath.row == 4) {
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTextField.delegate = self;
    }
    cell.inputTextField.placeholder = placeholder_arr[indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return WidthScaleSize_H(50);
}
- (void)commit_buttonAction:(UIButton *)button{
    
    HHTextfieldcell  *BankAccountNo_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    HHTextfieldcell  *BankName_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    HHTextfieldcell  *BankAccountName_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    HHTextfieldcell  *AccountOpeningBranch_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    HHTextfieldcell  *Tel_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];

    NSString *isvalid = [self isValidWithBankAccountNo:BankAccountNo_cell.inputTextField.text BankAccountName:BankAccountName_cell.inputTextField.text BankName:BankName_cell.inputTextField.text  AccountOpeningBranch:AccountOpeningBranch_cell.inputTextField.text Tel:Tel_cell.inputTextField.text];
    if (!isvalid) {
        
        [[[HHUserLoginAPI postBindBankCardInformationWithUserId:@"0" BankAccountNo:BankAccountNo_cell.inputTextField.text BankAccountName:BankAccountName_cell.inputTextField.text BankName:BankName_cell.inputTextField.text AccountOpeningBranch:AccountOpeningBranch_cell.inputTextField.text Tel:Tel_cell.inputTextField.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"绑定成功！"];
                    
                    [self.navigationController popVC];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:isvalid];
    }
    
}
- (NSString *)isValidWithBankAccountNo:(NSString *)BankAccountNo BankAccountName:(NSString *)BankAccountName  BankName:(NSString *)BankName AccountOpeningBranch:(NSString *)AccountOpeningBranch Tel:(NSString *)Tel {
    
    if (BankAccountNo.length == 0) {
        return @"请输入银行卡号！";
    }else if (BankAccountName.length == 0){
        return @"请输入开户名！";
    }
    else if (BankName.length == 0){
        return @"请输入开户行！";
    }else if (AccountOpeningBranch.length == 0){
        return @"请输入开户网点！";
    }else  if (Tel.length == 0) {
        return @"请输入预留手机号码！";
    }
    return nil;
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

    if (textField.tag == 10000) {
        
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 19 && range.length!=1){
            textField.text = [toBeString substringToIndex:19];
            return NO;
        }
    }
    if (textField.tag == 10004) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    

    return YES;
}
@end
