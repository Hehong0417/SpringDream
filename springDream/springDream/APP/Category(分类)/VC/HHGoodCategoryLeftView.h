//
//  HHGoodCategoryLeftView.h
//  
//
//  Created by User on 2018/10/10.
//

#import "LHAlertView.h"

@protocol  HHGoodCategoryLeftViewDelegate <NSObject>

- (void)didselectIndexPath:(NSIndexPath *)indexPath categoryId:(NSString *)categoryId;

- (void)didTapGesWithTapStatus:(BOOL)TapStatus;

@end

@interface HHGoodCategoryLeftView : LHAlertView

@property (nonatomic, strong)   NSMutableArray *datas;

@property (nonatomic, weak)   id <HHGoodCategoryLeftViewDelegate> delegate;

/**
 *  显示
 *
 *  @param animated 是否启用动画
 */
- (void)showAnimated:(BOOL)animated;
/**
 *  隐藏
 *
 *  @param completionBlock 完成block
 */
- (void)hideWithCompletion:(void(^)())completionBlock;

@end
