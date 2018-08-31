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
    self.product_nameLabel.text = @"梦泉时尚薰衣草梦泉梦泉时尚薰衣草梦泉时尚薰衣草梦泉时尚薰衣草梦泉时尚薰衣草梦泉时尚薰衣草梦泉时尚薰衣草时尚薰衣草";

//    self.product_nameLabel.text = gooodDetailModel.ProductName;
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %@",gooodDetailModel.BuyPrice?gooodDetailModel.BuyPrice:@""];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:¥%@",gooodDetailModel.MarketPrice?gooodDetailModel.MarketPrice:@""]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.product_s_intergralLabel.attributedText = newPrice;
    self.package_lab.text = [NSString stringWithFormat:@"运费：%@",gooodDetailModel.StrFreightModey];
    self.stock_label.text = [NSString stringWithFormat:@"库存：%@件",gooodDetailModel.Stock];
    self.sale_count_label.text = [NSString stringWithFormat:@"销量：%@件",gooodDetailModel.SaleCounts];
}
@end
