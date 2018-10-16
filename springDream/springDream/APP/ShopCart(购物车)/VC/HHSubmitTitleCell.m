//
//  HHSubmitTitleCell.m
//  springDream
//
//  Created by User on 2018/10/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitTitleCell.h"

@implementation HHSubmitTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.detail_label];
    }
    return self;
}


- (UILabel *)detail_label{
    if (!_detail_label) {
        _detail_label = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW-20, 44) text:@"" textColor:KTitleLabelColor font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
    }
    
    return _detail_label;
}
@end
