//
//  HHSignListVC.m
//  springDream
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSignListVC.h"

@interface HHSignListVC ()

@end

@implementation HHSignListVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"签到记录";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"签到第1天";
    cell.textLabel.font = FONT(14);
    cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.text = @"+20分";
    return cell;
}


@end
