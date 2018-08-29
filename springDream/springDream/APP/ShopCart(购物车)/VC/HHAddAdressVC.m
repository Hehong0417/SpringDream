//
//  HHAddAdressVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHAddAdressVC.h"
#import "HHTextfieldcell.h"
#import "GFAddressPicker.h"
#import "HHSubmitOrdersVC.h"

@interface HHAddAdressVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSMutableArray *placeHolder_arr;
@property (nonatomic, strong)    GFAddressPicker *addressPick;
@property (nonatomic, strong)    NSString *address_Str;
@property (nonatomic, strong)    UISwitch *swi;
@property (nonatomic, assign)    BOOL isOn;

@property (nonatomic, strong)   NSString *username;

@property (nonatomic, strong)   NSString *mobile;

@property (nonatomic, strong)   NSString *district_id;

@property (nonatomic, strong)   NSString *address;

@property (nonatomic, strong)   NSArray *addressValue_arr;

@end

@implementation HHAddAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    
    self.title_arr = @[@[@"国家/地区",@"市、区",@"详细地址",@"邮政编码"],@[@"收件人姓名",@"电话号码"],@[@"设置为默认地址"]];
    self.placeHolder_arr = [NSMutableArray arrayWithArray:@[@[@"中国大陆",@"请选择",@"",@"邮政编码"],@[@"请填写真实姓名，确保顺利收到货",@"中国大陆电话号码"],@[@""]]];
    
    //获取数据
    if (self.addressType == HHAddress_editType) {
        [self getDatas];
    }

    self.addressValue_arr = @[@[@"中国大陆",@"",@"",@""],@[@"",@""],@[@""]];

    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableView.tableFooterView = footView;

}

- (void)getDatas{
    
    [[[HHMineAPI GetAddressWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
        
                HHMineModel *model =  [HHMineModel mj_objectWithKeyValues:api.Data];
                if (model.RegionId) {
                    self.district_id = model.RegionId;
                }else if (model.CityId){
                    self.district_id = model.CityId;
                }else{
                    self.district_id = model.AddrId;
                }
                  self.username = model.Recipient;
                  self.mobile = model.Moble;
                //详细地址
                  self.address = model.Address;
                //选择的地址
                self.address_Str = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.region];
                if ([model.IsDefault isEqualToString:@"1"]) {
                    self.isOn = YES;
                }else{
                    self.isOn = NO;
                }
                [self.tableView reloadData];
            }
            
        }
    }];
    
}
- (void)saveBtnAction{
    //姓名
    HHTextfieldcell *usernameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *usernameStr = usernameCell.inputTextField.text;
    //手机号
    HHTextfieldcell *mobileCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSString *mobileStr = mobileCell.inputTextField.text;
    //详细地址
    HHTextfieldcell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *addressStr = addressCell.inputTextField.text;
    
    NSString *validStr = [self validWithusername:usernameStr mobile:mobileStr district_id:self.district_id address:addressStr];
    if (!validStr) {
        
      if (self.addressType == HHAddress_editType){
           
            [[ [HHMineAPI  postEditAddressWithId:self.Id district_id:self.district_id address:addressStr username:usernameStr mobile:mobileStr is_default:[NSString stringWithFormat:@"%d",self.swi.isOn]] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                if (!error) {
                    if (api.State == 1) {
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"编辑成功！"];
                        [self.navigationController popVC];
                    }else{
                        
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }
            }];
            
      }else {
          
          [[[HHMineAPI postAddAddressWithdistrict_id:self.district_id address:addressStr username:usernameStr mobile:mobileStr is_default:[NSString stringWithFormat:@"%d",self.swi.isOn]] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
              if (!error) {
                  if (api.State == 1) {
                      if (self.addressType == HHAddress_addType) {
                          [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                          [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
                          [self.navigationController popVC];
                          
                      }else if(self.addressType == HHAddress_settlementType_cart){
                          //提交订单页面
                          HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                          vc.pids = self.pids;
                          if ([self.sendGift isEqual:@1]) {
                              vc.enter_type = HHaddress_type_Spell_group;
                              vc.mode = @8;
                          }else{
                              vc.enter_type = HHaddress_type_add_cart;
                              vc.mode = nil;
                          }
                          vc.sendGift = self.sendGift;
                          [self.navigationController pushVC:vc];
                          
                      }else if (self.addressType == HHAddress_settlementType_productDetail){
                          
                          HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                          vc.enter_type = HHaddress_type_add_productDetail;
                          vc.mode = self.mode;
                          vc.ids_Str = self.ids_Str;
                          vc.pids = self.pids;
                          [self.navigationController pushVC:vc];
                      }
                      
                  }else{
                      
                      [SVProgressHUD showInfoWithStatus:api.Msg];
                  }
              }
          }];
      }
        
    }else{
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (NSString *)validWithusername:(NSString *)username mobile:(NSString *)mobile district_id:(NSString *)district_id address:(NSString *)address {
    
    if (username.length == 0) {
        return @"请填写姓名！";
    }else  if (mobile.length == 0) {
        return @"请填写手机号吗！";
    }else  if (district_id.length == 0) {
        return @"请选择所在地区！";
    }else  if (address.length == 0) {
        return @"请填写详细地址！";
    }
    return nil;
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 10000) {
        if (toBeString.length > 15 && range.length!=1){
         //收货人姓名
            textField.text = [toBeString substringToIndex:15];
            return NO;
        }
    }else  if (textField.tag == 10001) {
        //手机号
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *gridCell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ||indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.textColor = KTitleLabelColor;
            cell.detailTextLabel.textColor = indexPath.row?KTitleLabelColor:kBlackColor;
        cell.textLabel.font = FONT(14);
        cell.detailTextLabel.font = FONT(14);
            if (indexPath.row == 1) {
                cell.detailTextLabel.text =  self.address_Str?self.address_Str:self.placeHolder_arr[indexPath.section][indexPath.row];
            }else{
                cell.detailTextLabel.text = self.placeHolder_arr[indexPath.section][indexPath.row];
            }
            cell.textLabel.text = self.title_arr[indexPath.section][indexPath.row];

        gridCell = cell;
        }
        if (indexPath.row == 2 ||indexPath.row == 3) {
          HHTextfieldcell *cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
            cell.titleLabel.textColor = KTitleLabelColor;
            cell.inputTextField.textColor = kBlackColor;
            cell.titleLabel.font = FONT(14);
            cell.inputTextField.font = FONT(14);
            cell.inputTextField.delegate = self;
            cell.inputTextField.placeholder = self.placeHolder_arr[indexPath.section][indexPath.row];
            if (indexPath.row == 2) {
                cell.inputTextField.text = self.address;
            }else{
                cell.inputTextField.text = self.addressValue_arr[indexPath.section][indexPath.row];
            }
            cell.titleLabel.text = self.title_arr[indexPath.section][indexPath.row];
            gridCell = cell;

        }
    }else if (indexPath.section == 1){
        HHTextfieldcell *cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
        cell.titleLabel.textColor = KTitleLabelColor;
        cell.inputTextField.textColor = kBlackColor;
        cell.titleLabel.font = FONT(14);
        cell.inputTextField.font = FONT(14);
        cell.inputTextField.delegate = self;
        cell.titleLabel.text = self.title_arr[indexPath.section][indexPath.row];
        cell.inputTextField.placeholder = self.placeHolder_arr[indexPath.section][indexPath.row];
        if(indexPath.row == 0){
            cell.inputTextField.text = self.username;
        }else if(indexPath.row == 1){
            cell.inputTextField.text = self.mobile;
        }
        gridCell = cell;

    }else if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = KTitleLabelColor;
        cell.detailTextLabel.textColor = kBlackColor;
        cell.textLabel.font = FONT(14);
        cell.detailTextLabel.font = FONT(14);
        cell.textLabel.text = self.title_arr[indexPath.section][indexPath.row];
        UISwitch *swi = [UISwitch new];
        [swi addTarget:self action:@selector(swiAction:) forControlEvents:UIControlEventValueChanged];
        [swi setOnTintColor:kRedColor];
        cell.accessoryView  = swi;
        gridCell = cell;
        
    }
    gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *line = [UIView lh_viewWithFrame:CGRectMake(15, 0, ScreenW-15, 1) backColor:KVCBackGroundColor];
    [gridCell.contentView addSubview:line];
    return gridCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0&&indexPath.row == 1) {
        //选择地址
        self.addressPick = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.addressPick.font = [UIFont systemFontOfSize:WidthScaleSize_H(19)];
        [self.addressPick showPickViewAnimation:YES];
        WEAK_SELF();
        self.addressPick.completeBlock = ^(NSString *result, NSString *district_id) {
            weakSelf.district_id = district_id;
            weakSelf.address_Str = result;
            
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.title_arr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *rows = self.title_arr[section];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0&&indexPath.row == 2) {
        return 60;
    }
    return WidthScaleSize_H(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
- (void)swiAction:(UISwitch *)swi{
    
    
    
    
}

@end
