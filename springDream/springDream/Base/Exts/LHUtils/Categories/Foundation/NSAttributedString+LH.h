//
//  NSAttributedString+LH.h
//  springDream
//
//  Created by User on 2018/8/24.
//  Copyright © 2018年 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (LH)



/**
 计算属性字符串的size

 @param attributedText 属性字符串
 @return CGSize
 */
+ (CGSize)lh_sizewithAttributedText:(NSAttributedString *)attributedText;
+ (CGSize)lh_sizeWithConstrainedToSize:(CGSize)size attributedText:(NSAttributedString *)attributedText;

@end
