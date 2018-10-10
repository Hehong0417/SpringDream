//
//  HHGoodCategoryLeftViewCell.m
//  springDream
//
//  Created by User on 2018/10/10.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodCategoryLeftViewCell.h"

@implementation HHGoodCategoryLeftViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.icon_ImagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        self.icon_ImagV.image = [UIImage imageNamed:@"categoryTag"];
        self.icon_ImagV.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.icon_ImagV];
        self.icon_ImagV.hidden = YES;

        
        self.tLabel = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(self.icon_ImagV.frame), 0, ScreenW/2 - CGRectGetMaxX(self.icon_ImagV.frame)-15, 44) text:@"2345678" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [self.contentView addSubview:self.tLabel];

    }
    
    return self;
}
- (void)setModel:(HHleft_categoryModel *)model {
    _model = model;
    self.tLabel.text = model.Name;
}

@end
