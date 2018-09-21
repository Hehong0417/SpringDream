//
//  HHdiscountPackageView.h
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHdiscountPackageView;

@protocol HHdiscountPackageViewDelegate<NSObject>

- (void)didSelectItemWithPackage_Id:(NSString *)Package_Id;

@end

@interface HHdiscountPackageView : UIView

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong)   NSArray <HHPackagesModel *>*Packages;

@property (nonatomic, weak)  id<HHdiscountPackageViewDelegate> delegate;


@end
