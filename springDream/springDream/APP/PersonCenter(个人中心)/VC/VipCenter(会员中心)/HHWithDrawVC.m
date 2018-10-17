//
//  HHWithDrawVC.m
//  springDream
//
//  Created by User on 2018/10/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWithDrawVC.h"
#import "HHTextfieldcell.h"
#import "HXCommonPickView.h"

@interface HHWithDrawVC ()
{
    HXCommonPickView *_pickView;
}
@property (nonatomic, strong)   NSMutableArray *bankNames;
@property (nonatomic, strong)   NSMutableArray *bankIds;
@property (nonatomic, strong)   NSMutableArray *datas;

@end

@implementation HHWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    
    [self getDatas];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];

    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction) backgroundImage:nil title:@"提现"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_NAV_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
    _pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];

    
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
                [self.datas enumerateObjectsUsingBlock:^(HHMineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *subBankName = model.bank_no.length>4?[model.bank_no substringFromIndex:model.bank_no.length-4]:model.bank_no;
                    [self.bankNames addObject:[NSString stringWithFormat:@"%@ 尾号%@",model.bank_name,subBankName]];
                    
                }];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
    }];
    
}

- (NSArray *)groupTitles{
    
    return @[@[@"选择银行卡",@"提现金额"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@""]];
    
}
- (NSArray *)groupDetials {
    
    return @[@[@"",@" "]];
    
}
- (void)saveAction{
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        UITextField *moneyTF = [UITextField lh_textFieldWithFrame:CGRectMake(SCREEN_WIDTH - 150, 0, 135, 44) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
        moneyTF.placeholder = [NSString stringWithFormat:@"可用余额：%@",self.total_money];
        [cell.contentView addSubview:moneyTF];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (self.datas.count>0) {
            
                    [_pickView setStyle:HXCommonPickViewStyleDIY titleArr:self.bankNames];
                    WEAK_SELF();
                    _pickView.completeBlock = ^(NSString *result) {
                        HJSettingItem *item0 = [weakSelf settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        item0.detailTitle = result;
                    };
                    [_pickView showPickViewAnimation:YES];
            
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"请先添加银行卡！"];
        }

        
    }
    
}

@end
