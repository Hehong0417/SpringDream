//
//  NSAttributedString+LH.m
//  springDream
//
//  Created by User on 2018/8/24.
//  Copyright © 2018年 User. All rights reserved.
//

#import "NSAttributedString+LH.h"

@implementation NSAttributedString (LH)

+ (CGSize)lh_sizewithAttributedText:(NSAttributedString *)attributedText{
    
    return  [NSAttributedString lh_sizeWithConstrainedToSize:CGSizeMake(ScreenW, CGFLOAT_MAX) attributedText:attributedText];
}


+ (CGSize)lh_sizeWithConstrainedToSize:(CGSize)size attributedText:(NSAttributedString *)attributedText{
    
    CGSize a_size=[attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    
    return a_size;
}
@end

