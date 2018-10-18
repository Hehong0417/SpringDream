//
//  HHWithDrawVC.m
//  springDream
//
//  Created by User on 2018/10/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWithDrawVC.h"
#import "HHBankListCell.h"
#import "HHWithdrawCell.h"
#import "HHBankListVC.h"


@interface HHWithDrawVC ()

@property (nonatomic, strong)   NSMutableArray *bankNames;
@property (nonatomic, strong)   NSMutableArray *bankIds;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHMineModel *cardModel;

@end

@implementation HHWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    
    [self getDatas];
    
    
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];

    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction:) backgroundImage:nil title:@"确认提现"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_NAV_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableView.tableFooterView = footView;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;

    [self.tableView registerNib:[UINib nibWithNibName:@"HHBankListCell" bundle:nil] forCellReuseIdentifier:@"HHBankListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHWithdrawCell" bundle:nil] forCellReuseIdentifier:@"HHWithdrawCell"];

    self.view.backgroundColor = KVCBackGroundColor;
}
- (NSMutableArray *)bankNames{
    if (!_bankNames) {
        _bankNames = [NSMutableArray array];
    }
    return _bankNames;
}
- (NSMutableArray *)bankIds{
    if (!_bankIds) {
        _bankIds = [NSMutableArray array];
    }
    return _bankIds;
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserBankAccountList] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
               
                NSArray *arr = api.Data;
                [self.datas addObjectsFromArray:[HHMineModel mj_objectArrayWithKeyValuesArray:arr]];
                if (self.datas.count>0) {
                    self.cardModel = self.datas[0];
                    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
    }];
    
}

- (void)saveAction:(UIButton *)button{
    
    HHWithdrawCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (self.cardModel.Id.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择银行卡"];
    }else if(cell.moneyTextField.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入提现金额"];
    }else{
        [[[HHMineAPI postIntegralCashWithBank_id:self.cardModel.Id money:cell.moneyTextField.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"提现成功！"];
                    [self.navigationController popVC];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
            
        }];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell = nil;
    
    if (indexPath.section == 0) {
        
        HHBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHBankListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kWhiteColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = self.cardModel;
        gridCell = cell;
    }else{
        HHWithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHWithdrawCell"];
        [cell.allMoneyBtn addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        gridCell = cell;
    }
    
    return gridCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HHBankListVC *vc = [HHBankListVC new];
        [self.navigationController pushVC:vc];
        WEAK_SELF();
        vc.cardModelBlock = ^(HHMineModel *obj) {
            self.cardModel = obj;
            [weakSelf.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return  AdapationLabelFont(70);
    }else{
        return AdapationLabelFont(100);
    }
    
}
- (void)allButtonAction:(UIButton *)button{
    
    HHWithdrawCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.moneyTextField.text = self.total_money;
    
}
@end
