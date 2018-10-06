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
#import "HHBandCardVC.h"
#import "HHInviteCodeVC.h"

@interface HHCommonSetVC ()
@property(nonatomic,strong) HHMineModel  *mineModel;
@property (nonatomic, strong)    GFAddressPicker *addressPick;

@end

@implementation HHCommonSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"设置";
    
    [self getDatas];
    
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
                item0_2.detailTitle = @"去绑定";
                HJSettingItem *item0_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                item0_3.detailTitle = @"";
                
                HJSettingItem *item3_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                if (self.mineModel.RealName) {
                    item3_0.detailTitle = @"未验证";
                }else{
                    item3_0.detailTitle = @"已验证";
                }
                HJSettingItem *item3_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
                item3_1.detailTitle = @"去添加";
        
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
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
    
    if (indexPath.section == 0&&indexPath.row == 3) {
        //选择地址
        self.addressPick = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.addressPick.font = [UIFont systemFontOfSize:WidthScaleSize_H(19)];
        [self.addressPick showPickViewAnimation:YES];
        WEAK_SELF();
        self.addressPick.completeBlock = ^(NSString *result, NSString *district_id) {
//            weakSelf.district_id = district_id;
//            weakSelf.address_Str = result;
            
            HJSettingItem *item = [weakSelf settingItemInIndexPath:indexPath];
            item.detailTitle = result;
            [weakSelf.tableV reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
     }
    if (indexPath.section == 1&&indexPath.row == 1) {
        
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
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
        HHAuthenticationVC *vc = [HHAuthenticationVC new];
        [self.navigationController pushVC:vc];
    }
    if (indexPath.section == 3&&indexPath.row == 1) {
        HHBandCardVC *vc = [HHBandCardVC new];
        [self.navigationController pushVC:vc];
    }
    
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
    HJSettingItem *item3_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
    if ([item3_1.detailTitle isEqualToString:@"去添加"]) {
        NSIndexPath *indexPath3_1 = [NSIndexPath indexPathForRow:1 inSection:3];
        [indexPaths addObject:indexPath3_1];
    }
    
    
    return indexPaths;
}
- (NSArray *)groupTitles{
    
    return @[@[@"个人头像",@"手机号",@"微信号",@"会员所在区域"],@[@"修改密码",@"收货地址"],@[@"生成邀请码",@"输入邀请码"],@[@"身份验证",@"添加银行卡"],@[@"版本号",@"清除缓存"]];
    
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

@end
