//
//  HHDetailGoodReferralCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDetailGoodReferralCell.h"

@implementation HHDetailGoodReferralCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.product_nameLabel.font = BoldFONT(15);
    
    [self setupAutoHeightWithBottomView:self.stock_label bottomMargin:10];
    
}
- (void)setGooodDetailModel:(HHgooodDetailModel *)gooodDetailModel{

    _gooodDetailModel = gooodDetailModel;
    self.product_nameLabel.text = gooodDetailModel.ProductName;
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",gooodDetailModel.BuyPrice?gooodDetailModel.BuyPrice.floatValue:0.00];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:¥%.2f",gooodDetailModel.MarketPrice?gooodDetailModel.MarketPrice.floatValue:0.00]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.product_s_intergralLabel.attributedText = newPrice;
    self.package_lab.text = [NSString stringWithFormat:@"运费：%@",gooodDetailModel.StrFreightModey?gooodDetailModel.StrFreightModey:@"0"];
    self.stock_label.text = [NSString stringWithFormat:@"库存：%@件",gooodDetailModel.Stock?gooodDetailModel.Stock:@"0"];
    self.sale_count_label.text = [NSString stringWithFormat:@"销量：%@件",gooodDetailModel.SaleCounts?gooodDetailModel.SaleCounts:@"0"];
}
@end
