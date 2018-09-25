//
//  HHIntegralRankVC.m
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHIntegralRankVC.h"
#import "HHIntegralRankCell.h"

@interface HHIntegralRankVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation HHIntegralRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分排行榜";
    [self.tableView registerNib:[UINib nibWithNibName:@"HHIntegralRankCell" bundle:nil] forCellReuseIdentifier:@"HHIntegralRankCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"record_icon_no"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"你还没有相关的记录喔" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
    
    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 20;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHIntegralRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHIntegralRankCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<3) {
        cell.rank_label.hidden = YES;
        cell.rank_button.hidden = NO;
//        [cell.rank_button setTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1] forState:UIControlStateNormal];
        [cell.rank_button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rank_%ld",indexPath.row+1]] forState:UIControlStateNormal];
    }else{
        cell.rank_label.hidden = NO;
        cell.rank_button.hidden = YES;
        cell.rank_label.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

@end
