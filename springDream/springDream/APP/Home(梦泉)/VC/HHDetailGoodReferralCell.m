//
//  HHDetailGoodReferralCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDetailGoodReferralCell.h"
#import "HHActivityModel.h"

@implementation HHDetailGoodReferralCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.product_nameLabel.font = BoldFONT(15);
    
    [self setupAutoHeightWithBottomView:self.stock_label bottomMargin:10];
    
}
- (void)setGooodDetailModel:(HHgooodDetailModel *)gooodDetailModel{

    _gooodDetailModel = gooodDetailModel;
    
    if ([gooodDetailModel.IsNewProduct isEqual:@1]) {
        
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",gooodDetailModel.ProductName]];
        //添加图片
        UIImage *attach_Image = [UIImage imageNamed:@"new_pro"];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = attach_Image;
        attach.bounds = CGRectMake(0, -3, attach_Image.size.width, attach_Image.size.height);
        
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
        
        self.product_nameLabel.attributedText = attributeStr1;
    }else{
        self.product_nameLabel.text = gooodDetailModel.ProductName;
    }
    self.subtitle_label.text = gooodDetailModel.subtitle?gooodDetailModel.subtitle:@"";
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",gooodDetailModel.BuyPrice?gooodDetailModel.BuyPrice.doubleValue:0.00];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:¥%.2f",gooodDetailModel.MarketPrice?gooodDetailModel.MarketPrice.doubleValue:0.00]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.product_s_intergralLabel.attributedText = newPrice;
    self.package_lab.text = [NSString stringWithFormat:@"运费：%@",gooodDetailModel.StrFreightModey?gooodDetailModel.StrFreightModey:@"0"];
    self.stock_label.text = [NSString stringWithFormat:@"库存：%@件",gooodDetailModel.Stock?gooodDetailModel.Stock:@"0"];
    self.sale_count_label.text = [NSString stringWithFormat:@"销量：%@件",gooodDetailModel.SaleCounts?gooodDetailModel.SaleCounts:@"0"];
    
    
    HHActivityModel *SecKill_m = [HHActivityModel mj_objectWithKeyValues:gooodDetailModel.SecKill];
    if ([SecKill_m.IsSecKill isEqual:@1]) {
        self.product_min_priceLabel.text = @"";
        self.product_s_intergralLabel.text= @"";
    }
    HHActivityModel *Group_m = [HHActivityModel mj_objectWithKeyValues:gooodDetailModel.GroupBuy];
    if ([Group_m.IsJoin isEqual:@1]) {
        self.product_min_priceLabel.text = @"";
        self.product_s_intergralLabel.text= @"";
    }
    
    if ([gooodDetailModel.IsRewardShow isEqual:@1]) {
        self.rewardShow_label.hidden = NO;
        self.rewardShow_label.text = [NSString stringWithFormat:@"自购省%@元，分享省%@元",gooodDetailModel.BuyCheapMoney,gooodDetailModel.ShareMakeMoney];
        NSString *ewardShow_text =  [NSString stringWithFormat:@"自购省%@元，分享省%@元",gooodDetailModel.BuyCheapMoney,gooodDetailModel.ShareMakeMoney];
        CGSize mode_size = [ewardShow_text lh_sizeWithFont:FONT(13)  constrainedToSize:CGSizeMake(MAXFLOAT,AdapationLabelFont(20))];
        UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(0,0, mode_size.width+AdapationLabelFont(20), AdapationLabelFont(20)) text:ewardShow_text textColor:APP_NAV_COLOR font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [label lh_setCornerRadius:5 borderWidth:1 borderColor:APP_NAV_COLOR];
        [self.rewardShow_label addSubview:label];
    }else{
        self.rewardShow_label.hidden = YES;
        self.rewardShow_label.text = @"";
    }
}
@end
