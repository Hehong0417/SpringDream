//
//  HHtEditCarItem.m
//  Store
//
//  Created by User on 2018/1/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHtEditCarItem.h"
#import "HHSelectSectionItem.h"

@implementation HHtEditCarItem

+(instancetype)shopCartGoodsList:(NSArray *)shopCartGoodsList selectionArr:(NSArray *)selectionArr{
    
    __block NSMutableArray *productsArr = [NSMutableArray array];
    
    [shopCartGoodsList enumerateObjectsUsingBlock :^(HHstoreModel  *storeModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [storeModel.products enumerateObjectsUsingBlock:^(HHproductsModel * productModel, NSUInteger idx1, BOOL * _Nonnull stop) {
            
            [selectionArr enumerateObjectsUsingBlock:^( HHSelectSectionItem *secItem, NSUInteger oneIdx, BOOL * _Nonnull stop) {
                [secItem.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger twoIdx, BOOL * _Nonnull stop) {
                    if ([rowItem.row_selected isEqual:@1]) {
                        if ((oneIdx == idx)&&(twoIdx == idx1)) {
                                [productsArr addObject:productModel];
                        }
                    }
                
                }];
        }];
        
        }];
        
    }];
    HHtEditCarItem *editCarItem  = [HHtEditCarItem settleGoodsModelWithGoodsList:productsArr];

    
    __block BOOL allSelect = YES;
    [selectionArr enumerateObjectsUsingBlock:^( HHSelectSectionItem *secItem, NSUInteger oneIdx, BOOL * _Nonnull stop) {
        [secItem.selectRow_Arr enumerateObjectsUsingBlock:^(HHSelectRowItem * rowItem, NSUInteger twoIdx, BOOL * _Nonnull stop) {
            if (rowItem.row_selected.boolValue == NO) {
                allSelect = NO;
                *stop = YES;
            }
        }];
    }];
        editCarItem.settleAllSelect = allSelect;
    
    return  editCarItem;
}

+ (instancetype)settleGoodsModelWithGoodsList:(NSArray *)goodsList{
    
    NSLog(@"goodsList:%@",goodsList);
    if (goodsList.count>0) {
        HHtEditCarItem *editCarItem = [HHtEditCarItem new];

        __block  CGFloat totalPrice = 0;
        
        [goodsList enumerateObjectsUsingBlock:^(HHproductsModel  *productsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat price_total = productsModel.price.floatValue*productsModel.quantity.integerValue;
            totalPrice +=price_total;
        }];
        editCarItem.total_Price = totalPrice;
        return  editCarItem;
    }else {
        
        HHtEditCarItem *editCarItem = [HHtEditCarItem new];
        editCarItem.total_Price = 0.00;
        return editCarItem;
    }
    
}

@end
