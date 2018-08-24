//
//  HHFeatureSelectionViewCell.h
//  springDream
//
//  Created by User on 2018/8/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFeatureItem.h"
#import "DCFeatureTitleItem.h"
#import "DCFeatureList.h"
// Views
#import "PPNumberButton.h"
#import "DCFeatureItemCell.h"
#import "DCFeatureHeaderView.h"
#import "DCCollectionHeaderLayout.h"

@protocol HHFeatureSelectionViewCellDelegate <NSObject>

@optional

// 用协议传回 collectionView 的 size
- (void)tableviewDynamictablviewHeightWithCollectionHeight:(CGFloat)collectionHeight;

@end

@interface HHFeatureSelectionViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate,PPNumberButtonDelegate>

/* contionView */
@property (strong , nonatomic)UICollectionView *collectionView;

/* 按钮标题 */
@property (strong , nonatomic)NSString *button_Title;

/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;
/* 上一次选择的属性 */
@property (strong , nonatomic)NSMutableArray *lastSeleArray;
/* 上一次选择的属性Id */
@property (strong , nonatomic)NSMutableArray *lastSele_IdArray;

/* 上一次选择的数量 */
@property (assign , nonatomic)NSString *lastNum;
/* 数量 */
@property (assign , nonatomic)NSInteger Num_;
/* 价格 */
@property (assign , nonatomic)NSString *product_price;
/* 库存 */
@property (assign , nonatomic)NSString *product_stock;
/* 商品Id */
@property (assign , nonatomic)NSString *product_id;

//商品规格
@property (strong , nonatomic)NSArray <HHproduct_sku_valueModel *> *product_sku_value_arr;

//用来查询库存和价格
@property (assign , nonatomic)NSArray <HHproduct_skuModel *> *product_sku_arr;

@property (nonatomic, strong)  HHgooodDetailModel *gooodDetailModel;

@property (assign , nonatomic)CGFloat nowScreenH;

@property (assign , nonatomic)id<HHFeatureSelectionViewCellDelegate> delegate;


@property (nonatomic ,strong)NSMutableArray * SKUResult;

@property (nonatomic ,strong)NSMutableArray * skuResult;//!<可匹配规格
@property (nonatomic ,strong)NSMutableArray * seletedIndexPaths;//!<已经选中的规格数组
@property (nonatomic ,strong)NSMutableArray * seletedIdArray;//!<记录已选id
@property (nonatomic ,strong)NSMutableArray * seletedEnable;//!<不可选indexPath


/* 选择属性 */
@property (strong , nonatomic)NSMutableArray *seleArray;
/* 数据 */
@property (strong , nonatomic)NSMutableArray <HHproduct_sku_valueModel*> *featureAttr;
@end
