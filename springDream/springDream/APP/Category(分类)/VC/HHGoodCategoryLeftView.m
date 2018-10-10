//
//  HHMydistributorsVC.m
//  springDream
//
//  Created by User on 2018/9/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodCategoryLeftView.h"
#import "HHGoodCategoryLeftViewCell.h"

@interface HHGoodCategoryLeftView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSMutableArray *selectItems;

@end

@implementation HHGoodCategoryLeftView

- (UIView *)alertViewContentView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW/2, ScreenH - 64 - 49) style:UITableViewStyleGrouped];
    
    [self.tableView registerClass:[HHGoodCategoryLeftViewCell class] forCellReuseIdentifier:@"HHGoodCategoryLeftViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.allowsMultipleSelection = NO;
    
    return self.tableView;
}
- (NSMutableArray *)selectItems{
    
    if (!_selectItems) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}
- (void)setDatas:(NSMutableArray *)datas{
    _datas = datas;
    HJUser *user = [HJUser sharedUser];
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == user.category_selectIndexPath.row) {
            [self.selectItems addObject:@1];
        }else{
            [self.selectItems addObject:@0];
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHGoodCategoryLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHGoodCategoryLeftViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.datas[indexPath.row];
    cell.icon_ImagV.hidden = !((NSNumber *)self.selectItems[indexPath.row]).boolValue;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.selectItems enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            [self.selectItems replaceObjectAtIndex:idx withObject:@1];
        }else{
            [self.selectItems replaceObjectAtIndex:idx withObject:@0];
        }
    }];
    [self.tableView reloadData];
    HHleft_categoryModel *model = self.datas[indexPath.row];
    [self hideWithCompletion:^{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didselectIndexPath:categoryId:)]) {
            
            [self.delegate didselectIndexPath:indexPath categoryId:model.Id];
            
            [self.delegate didTapGesWithTapStatus:NO];
        }
    }];
 
}
/**
 *  显示
 *
 *  @param animated 是否启用动画
 */
- (void)showAnimated:(BOOL)animated{
    NSAssert(self.contentView != nil, @"must have conetentView");
    
    self.animated = animated;
    
    [self av_addSuperViews];
    
    if (animated) {
        self.contentView.lh_right = self.lh_left;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.lh_left = self.lh_left;
        } completion:^(BOOL finished) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didTapGesWithTapStatus:)]) {
                [self.delegate didTapGesWithTapStatus:YES];
            }
        }];
    }
}
/**
 *  隐藏
 *
 *  @param completionBlock 完成block
 */
- (void)hideWithCompletion:(void(^)())completionBlock {
    if (self.animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.lh_right = self.lh_left;
        } completion:^(BOOL finished) {
            [self av_removeSubviews];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didTapGesWithTapStatus:)]) {
                [self.delegate didTapGesWithTapStatus:NO];
            }
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
    else {
        [self av_removeSubviews];
        
        if (completionBlock) {
            completionBlock();
        }
    }
}

@end
