//
//  HHpreferentialModelCell.h
//  springDream
//
//  Created by User on 2018/9/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXTagsView.h"
#import "HHpreferModel.h"

@interface HHpreferentialModelCell : UITableViewCell

@property (nonatomic ,strong)LXTagsView *tagsView;

@property(nonatomic,strong)NSArray *items;

@property (nonatomic, strong) HHpreferModel *model;


@end
