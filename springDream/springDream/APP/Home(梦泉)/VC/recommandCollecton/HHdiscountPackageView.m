//
//  HHdiscountPackageView.m
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageView.h"
#import "HHdiscountPackageCollectionCell.h"

@interface HHdiscountPackageView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation HHdiscountPackageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = KVCBackGroundColor;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;

        [self addSubview:_collectionView];
        [self.collectionView registerClass:[HHdiscountPackageCollectionCell class] forCellWithReuseIdentifier:@"HHdiscountPackageCollectionCell"];
    }
    return self;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.Packages.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ScreenW-40, self.mj_h);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHdiscountPackageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHdiscountPackageCollectionCell" forIndexPath:indexPath];
    HHPackagesModel *model = self.Packages[indexPath.row];
    cell.backgroundColor = kWhiteColor;
    cell.PackagesProducts_models = model.Products;
    cell.priceLabel.text =  [NSString stringWithFormat:@"最多可省¥%.2f",model.BeEconomicalMoney.floatValue];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10,10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHPackagesModel *model = self.Packages[indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectItemWithPackage_Id:)]) {
        [self.delegate didSelectItemWithPackage_Id:model.PKID];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    

    return  CGSizeMake(0,0);
    

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
       return nil;
}
@end
