//
//  SDTimeLineModel.m
//  springDream
//
//  Created by User on 2018/9/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "SDTimeLineModel.h"

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation SDTimeLineModel
{
    CGFloat _lastContentWidth;
}

@synthesize SubjectContent = _SubjectContent;

- (void)setSubjectContent:(NSString *)SubjectContent{
    
    _SubjectContent = SubjectContent;
}
- (NSString *)SubjectContent{
    
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 40;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_SubjectContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    return _SubjectContent;
}
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"ContentECSubjectPicModel":[SDContentECSubjectPicModel class],@"ContentECSubjectCommentModel":[SDTimeLineCellCommentItemModel class]};
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end


@implementation SDTimeLineCellLikeItemModel


@end

@implementation SDTimeLineCellCommentItemModel


@end
@implementation SDContentECSubjectPicModel


@end

