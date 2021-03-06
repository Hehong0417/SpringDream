//
//  HHCommonSetVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCommonSetVC.h"
#import "GFAddressPicker.h"
#import "HHShippingAddressVC.h"
#import "HHLoginVC.h"
#import "HHAuthenticationVC.h"
#import "HHInviteCodeVC.h"
#import "HHBankListVC.h"
#import "HHModifyPassWordVC.h"

@interface HHCommonSetVC ()
{
    MBProgressHUD  *hud;
}
@property(nonatomic,strong) HHMineModel  *mineModel;
@property (nonatomic, strong)    GFAddressPicker *addressPick;

@end

@implementation HHCommonSetVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"设置";
    
    HJSettingItem *item4_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    item4_0.detailTitle = [NSString stringWithFormat:@"%@版本",kAppCurrentVersion];
    
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    CGFloat M = size/1024/1024;
    
    HJSettingItem *item4_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:4]];
    item4_1.detailTitle = [NSString stringWithFormat:@"%.2fM",M];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction:) backgroundImage:nil title:@"退出当前登录"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_NAV_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
}

//退出登录
- (void)saveAction:(UIButton *)btn{
    
    HJUser *user = [HJUser sharedUser];
    user.token = nil;
    [user write];
    kKeyWindow.rootViewController = [[HJNavigationController alloc] initWithRootViewController:[HHLoginVC new]];
    
}

#pragma mark - 获取数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.mineModel = [HHMineModel mj_objectWithKeyValues:api.Data[@"user"]];
                
                HJSettingItem *item0_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                item0_1.detailTitle = self.mineModel.CellPhone;
                HJSettingItem *item0_2 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                if (self.mineModel.OpenId) {
                    item0_2.detailTitle = @"已绑定";
                }else{
                    item0_2.detailTitle = @"去绑定";
                }
                HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.Data];
                HJSettingItem *item0_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                item0_3.detailTitle = model.userRegin?model.userRegin:@"";
                
                HJSettingItem *item3_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                if (self.mineModel.RealName) {
                    item3_0.detailTitle = @"已验证";
                }else{
                    item3_0.detailTitle = @"未验证";
                }
                HJSettingItem *item3_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
                if (self.mineModel.CardID) {
                    item3_1.detailTitle = @"";
                }else{
                    item3_1.detailTitle = @"";
                }
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self.cellHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.mineModel.UserImage] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return WidthScaleSize_H(55);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0&&indexPath.row == 2) {
        //绑定微信
        if (self.mineModel.OpenId.length==0) {
          [self getAuthWithUserInfoFromWechat];
        }
    }
    if (indexPath.section == 0&&indexPath.row == 3) {
        //选择地址
        self.addressPick = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.addressPick.font = [UIFont systemFontOfSize:WidthScaleSize_H(19)];
        [self.addressPick showPickViewAnimation:YES];
        WEAK_SELF();
        self.addressPick.completeBlock = ^(NSString *result, NSString *district_id) {

            [weakSelf saveAddressWithDistrict_id:district_id result:result indexPath:indexPath];
           
        };
     }

    if (indexPath.section == 1&&indexPath.row == 0) {
        
        HHModifyPassWordVC *vc = [HHModifyPassWordVC new];
        [self.navigationController pushVC:vc];
    }
    if (indexPath.section == 1&&indexPath.row == 1) {
        
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        vc.enter_type = HHenter_type_mine;
        [self.navigationController pushVC:vc];
    }
    if (indexPath.section == 2&&indexPath.row == 0) {
        HHInviteCodeVC *vc = [HHInviteCodeVC new];
        vc.IsGenerateCode = YES;
        [self.navigationController pushVC:vc];
    }
    if (indexPath.section == 2&&indexPath.row == 1) {
        HHInviteCodeVC *vc = [HHInviteCodeVC new];
        vc.IsGenerateCode = NO;
        [self.navigationController pushVC:vc];
    }
    if (indexPath.section == 3&&indexPath.row == 0) {
        if (self.mineModel.RealName) {
           
        }else{
            
            HHAuthenticationVC *vc = [HHAuthenticationVC new];
            [self.navigationController pushVC:vc];
        }

    }
    if (indexPath.section == 3&&indexPath.row == 1) {
        
        HHBankListVC *vc = [HHBankListVC new];
        [self.navigationController pushVC:vc];
    }
    
}
- (void)saveAddressWithDistrict_id:(NSString *)district_id result:(NSString *)result indexPath:(NSIndexPath *)indexPath{
    
    HJSettingItem *item = [self settingItemInIndexPath:indexPath];
    item.detailTitle = result;
    [self.tableV reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    
    [[[HHMineAPI UpdateUserInfoOfCityWithRegionId:district_id] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
    }];
    
}
- (NSArray *)indicatorIndexPaths{
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSIndexPath *indexPath0_2 = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath0_3 = [NSIndexPath indexPathForRow:3 inSection:0];
    [indexPaths addObject:indexPath0_2];
    [indexPaths addObject:indexPath0_3];

    HJSettingItem *item3_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    if ([item3_0.detailTitle isEqualToString:@"未验证"]) {
        NSIndexPath *indexPath3_0 = [NSIndexPath indexPathForRow:0 inSection:3];
        [indexPaths addObject:indexPath3_0];
    }
//    HJSettingItem *item3_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
//    if ([item3_1.detailTitle isEqualToString:@"去添加"]) {
        NSIndexPath *indexPath3_1 = [NSIndexPath indexPathForRow:1 inSection:3];
        [indexPaths addObject:indexPath3_1];
//    }
    
    
    return indexPaths;
}
- (NSArray *)groupTitles{
    
    return @[@[@"个人头像",@"手机号",@"微信号",@"会员所在区域"],@[@"修改密码",@"收货地址"],@[@"生成邀请码",@"输入邀请码"],@[@"身份验证",@"我的银行卡"],@[@"版本号",@"清除缓存"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@"",@"",@""],@[@"",@""],@[@"",@""],@[@"",@""],@[@"",@""]];

}
- (NSArray *)groupDetials {
    
    return @[@[@"",@"",@"",@""],@[@"",@""],@[@"",@""],@[@"",@""],@[@"",@""]];
    
}
- (NSIndexPath *)headImageCellIndexPath{
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
}
#pragma mark - 微信授权，获取微信信息

- (void)getAuthWithUserInfoFromWechat
{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        
        if (error) {
            NSLog(@"error--%@",error);
            
        } else {
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.color = KA0LabelColor;
            hud.detailsLabelText = @"授权中，请稍后...";
            hud.detailsLabelColor = kWhiteColor;
            hud.detailsLabelFont = FONT(14);
            hud.activityIndicatorColor = kWhiteColor;
            [hud showAnimated:YES];
            
            UMSocialUserInfoResponse *resp = result;
            // 授权信息 resp.uid,resp.unionId,resp.openid,resp.accessToken,resp.refreshToken
            // 用户信息 resp.name,resp.iconurl,resp.gender
            
            //  NSString *openid = @"o8dxQ1s0Cr9bkYry3FNYVw0WUQcc";
            NSString *openid = resp.openid;
            //    ***************//
            
            [[[HHUserLoginAPI postBindWeiXinWithOpenId:openid UnionId:resp.unionId UserImage:resp.iconurl] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
                [hud hideAnimated:YES];
                if (!error) {
                    if (api.State == 1) {
                        HJSettingItem *item0_2 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        item0_2.detailTitle = @"已绑定";
                        [self.tableV reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                        
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"绑定失败！"];
                    }
                }else{
                    if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
                    }
                }
                
            }];
            //    *********************//
            
        }
        
    }];
}
@end
