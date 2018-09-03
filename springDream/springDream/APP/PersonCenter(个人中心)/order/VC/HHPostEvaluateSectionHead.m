//
//  HHPostEvaluateSectionHead.m
//  lw_Store
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPostEvaluateSectionHead.h"

@implementation HHPostEvaluateSectionHead

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        self.product_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(10), WidthScaleSize_H(10), WidthScaleSize_H(65), WidthScaleSize_H(65)) image:nil];
        self.product_imageV.backgroundColor = KVCBackGroundColor;
        [self addSubview:self.product_imageV];
        
        UILabel *title_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(self.product_imageV.frame)+WidthScaleSize_W(10), WidthScaleSize_H(10), 60, WidthScaleSize_H(20)) text:@"产品评价" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [self addSubview:title_lab];
        
        //CDPStarEvaluation星形评价
        self.starEvaluation=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.product_imageV.frame)+WidthScaleSize_W(10),CGRectGetMaxY(title_lab.frame),ScreenW-WidthScaleSize_W(80),WidthScaleSize_H(30)) onTheView:self];
        self.starEvaluation.delegate=self;
        
    }
    return self;
}

- (void)theCurrentCommentText:(NSString *)commentText starEvaluation:(id)starEvaluation{
    
    NSNumber *describeScore =  ((CDPStarEvaluation *)starEvaluation).grade;
    
    HHPostOrderEvaluateItem *postOrderEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    HHproductEvaluateModel *evaluate_m =  postOrderEvaluateItem.productEvaluate[self.section];
    evaluate_m.describeScore = describeScore;
    [postOrderEvaluateItem write];
}
@end
