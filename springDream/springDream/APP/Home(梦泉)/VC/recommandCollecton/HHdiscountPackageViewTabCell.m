//
//  HHdiscountPackageViewTabCell.m
//  lw_Store
//
//  Created by User on 2018/6/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageViewTabCell.h"
#import "HHdiscountPackageView.h"

@interface HHdiscountPackageViewTabCell()
{
    HHdiscountPackageView *_discount_view;
    UIView *_titleView;
    UILabel *_titleLabel;
    UIImageView *_arrpw_imageV;
}
@end
@implementation HHdiscountPackageViewTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = KVCBackGroundColor;
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        [self.contentView addSubview:_titleView];
        
        _titleLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, 200, 40) text:@"为您推荐" textColor:RGB(51, 51, 51) font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        _titleLabel.textColor = RGB(51, 51, 51);
        [_titleView addSubview:_titleLabel];

        _discount_view = [[HHdiscountPackageView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, 120)];
        [self.contentView addSubview:_discount_view];

        
//        _arrpw_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(ScreenW-50, 0, 50, 30) image:[UIImage imageNamed:@"right_arrow"]];
//        _arrpw_imageV.contentMode = UIViewContentModeCenter;
//        [_titleView addSubview:_arrpw_imageV];
        
        _titleView.userInteractionEnabled = YES;
    }
    
    return self;
}
- (void)setGuess_you_like_arr:(NSArray *)guess_you_like_arr{
    
     _guess_you_like_arr = guess_you_like_arr;
    
     BOOL  hidden = guess_you_like_arr.count>0?NO:YES;
    _titleView.hidden = hidden;
    _discount_view.hidden = hidden;
    _discount_view.guess_you_like_arr = guess_you_like_arr;
    
    [_discount_view.collectionView reloadData];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    
//    _titleLabel.text = [NSString stringWithFormat:@"优惠套餐%ld",indexPath.row+1];
}
@end
