//
//  HHvipInfoVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHvipInfoVC.h"

@interface HHvipInfoVC ()

@end

@implementation HHvipInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"会员信息";
    
    self.tableV.backgroundColor = kWhiteColor;
    self.view.backgroundColor = kWhiteColor;
    
    UIView *head_view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 200) backColor:kWhiteColor];
    UIImageView *code_imagV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
    code_imagV.image = [UIImage imageNamed:@"icon0"];
    code_imagV.center = head_view.center;
    [head_view addSubview:code_imagV];
    self.tableV.tableHeaderView = head_view;
    
    //
    UILabel *footer_lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, 50) text:@"推荐人：小可爱" textColor:kDarkGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    self.tableV.tableFooterView = footer_lab;

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0&&indexPath.row == 0) {
        UIImageView *icon_imagV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-75, 0, 50, 50)];
        [icon_imagV lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
        icon_imagV.image = [UIImage imageNamed:@"icon0"];
        [cell.contentView addSubview:icon_imagV];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}
- (NSArray *)groupTitles{
    
    return @[@[@"头像",@"昵称",@"账号",@"会员等级",@"经理"]];
    
}
- (NSArray *)groupIcons {
    
 return @[@[@"",@"",@"",@"",@""]];
    
}
- (NSArray *)groupDetials{
    
    return @[@[@" ",@"小可爱",@"34567890",@"会员",@"..zaki.."]];

}

@end
