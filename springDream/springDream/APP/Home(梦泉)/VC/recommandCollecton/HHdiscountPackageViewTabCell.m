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
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        _discount_view = [[HHdiscountPackageView alloc] initWithFrame:CGRectMake(0, 30, ScreenW, 110)];
        [self.contentView addSubview:_titleView];
        [self.contentView addSubview:_discount_view];
        
        _titleLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, 200, 30) text:@"为你推荐" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [_titleView addSubview:_titleLabel];
        
//        _arrpw_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(ScreenW-50, 0, 50, 30) image:[UIImage imageNamed:@"right_arrow"]];
//        _arrpw_imageV.contentMode = UIViewContentModeCenter;
//        [_titleView addSubview:_arrpw_imageV];
        
        _titleView.userInteractionEnabled = YES;
    }
    
    return self;
}
- (void)setPackages_model:(HHPackagesModel *)packages_model{
    
    _packages_model = packages_model;
    _discount_view.PackagesProducts_models = packages_model.Products;
    WEAK_SELF();

}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    
//    _titleLabel.text = [NSString stringWithFormat:@"优惠套餐%ld",indexPath.row+1];
}
@end
