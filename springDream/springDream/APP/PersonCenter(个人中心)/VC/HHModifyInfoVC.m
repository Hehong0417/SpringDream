//
//  HHModifyInfoVC.m
//  CredictCard
//
//  Created by User on 2017/12/18.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHModifyInfoVC.h"
//#import "HHUserInfoModel.h"
#import "HHAboutUsVC.h"
#import "HHLoginVC.h"

@interface HHModifyInfoVC ()<UITextFieldDelegate>

@end

@implementation HHModifyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction:) backgroundImage:nil title:@"退出当前登录"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_NAV_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
    
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    CGFloat M = size/1024/1024;
    HJSettingItem *item = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    item.detailTitle = [NSString stringWithFormat:@"%.2fM",M];

    [self.tableView setSeparatorColor:RGB(238, 238, 238)];
}

//退出登录
- (void)saveAction:(UIButton *)btn{

    HJUser *user = [HJUser sharedUser];
    user.token = nil;
    [user write];
    kKeyWindow.rootViewController = [[HJNavigationController alloc] initWithRootViewController:[HHLoginVC new]];
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.cellHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.userIcon]];

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];

        }else if (indexPath.row == 1){
            //手机号码
            
        }
//        else if (indexPath.row == 2){
//            //关于我们
//            HHAboutUsVC *vc = [HHAboutUsVC new];
//            [self.navigationController pushVC:vc];
//        }
    }
//    else if (indexPath.section == 1) {
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            HJSettingItem *item = [self settingItemInIndexPath:indexPath];
//            [[SDImageCache sharedImageCache] clearMemory];
//            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//            item.detailTitle = [NSString stringWithFormat:@"0.00M"];
//            [self.tableV reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            [alertC dismissViewControllerAnimated:YES completion:nil];
//
//        }];
//        [alertC addAction:action1];
//        [alertC addAction:action2];
//        [self presentViewController:alertC animated:YES completion:nil];
//
//    }
}
- (NSArray *)groupTitles{
    
//    return @[@[@"头像",@"登录账号",@"关于我们"],@[@"清除缓存"]];
     return @[@[@"头像",@"登录账号"]];

}
- (NSArray *)groupIcons {
    
//    return @[@[@"",@"",@""],@[@""]];
    return @[@[@"",@""]];

}
- (NSArray *)groupDetials{
    
    return @[@[@" ",self.phoneNum?self.phoneNum:@" "]];

}

- (NSIndexPath *)headImageCellIndexPath{
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        return WidthScaleSize_H(75);
    }
    
    return 50;
    
}
@end
