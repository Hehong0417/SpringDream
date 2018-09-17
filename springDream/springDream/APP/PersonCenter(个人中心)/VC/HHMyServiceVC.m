//
//  HHMyServiceVC.m
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyServiceVC.h"
#import "HHMyServiceCell.h"
#import "HHMyWalletVC.h"
#import "HHCouponSuperVC.h"
#import "HHMyIntegralVC.h"
#import "HHMyCollectionVC.h"
#import "HHShippingAddressVC.h"
#import "HHMyRightsVC.h"
#import "HHmyEarningsVC.h"
#import "HHModifyInfoVC.h"
#import "HHInviteCodeVC.h"
#import "HHSendIntegralVC.h"

@interface HHMyServiceVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *model_images;
@property(nonatomic,strong)NSArray *model_titles;

@property(nonatomic,strong)NSArray *vc_arr;


@end

@implementation HHMyServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的服务";

    [self setUp];
    
}
- (void)setUp{
    
    [self.collectionView registerClass:[HHMyServiceCell class] forCellWithReuseIdentifier:@"HHMyServiceCell"];
    
    self.vc_arr = @[[HHMyWalletVC new],[HHCouponSuperVC new],[HHMyIntegralVC new],[HHMyCollectionVC new],[HHShippingAddressVC new],[HHMyRightsVC new],[HHmyEarningsVC new],[HHModifyInfoVC new],[HHInviteCodeVC new],[HHInviteCodeVC new],[HHSendIntegralVC new]];
    
    if (self.service_type == MyService_type_vipCenter) {
        self.model_images = @[@"service_01",@"service_02",@"service_03",@"service_04",@"service_11",@"service_12",@"service_13",@"service_14",@"service_01",@"service_02",@"service_03"];
        self.model_titles = @[@"我的钱包",@"我的优惠券",@"我的积分",@"我的收藏",@"地址管理",@"会员权益",@"会员收益",@"基础设置",@"生成邀请码",@"输入邀请码",@"赠送积分"];
    }else if (self.service_type == MyService_type_distributionCenter) {
        self.model_images = @[@"service_01",@"service_02",@"service_03",@"service_04",@"service_11",@"service_12",@"service_13",@"service_14",@"service_01",@"service_02",@"service_03"];
        self.model_titles = @[@"我的钱包",@"我的优惠券",@"我的积分",@"我的收藏",@"地址管理",@"会员权益",@"会员收益",@"基础设置",@"生成邀请码",@"输入邀请码",@"赠送积分"];
    }else if (self.service_type == MyService_type_storesManager) {
        
    }else if (self.service_type == MyService_type_delegateCenter) {
        
    }
    
    [self.view addSubview:_collectionView];

}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenH) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = KVCBackGroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.model_titles.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW-5)/4, 95);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHMyServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHMyServiceCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    cell.title_str =  self.model_titles[indexPath.row];
    cell.image_str = self.model_images[indexPath.row];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1,1,1,1);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self pushVCWithIndexPath:indexPath];

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    
    return  CGSizeMake(0,0);
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (void)pushVCWithIndexPath:(NSIndexPath *)indexPath{
    
    if (self.service_type == MyService_type_vipCenter) {
        
        if (indexPath.row == 7) {
            HHModifyInfoVC *vc = (HHModifyInfoVC *)self.vc_arr[indexPath.row];
            HJUser *user = [HJUser sharedUser];
            vc.userIcon = user.mineModel.UserImage;
            vc.phoneNum = user.mineModel.CellPhone;
            [self.navigationController pushVC:vc];
        }else if(indexPath.row == 8){
            HHInviteCodeVC *vc = (HHInviteCodeVC *)self.vc_arr[indexPath.row];
            vc.IsGenerateCode = YES;
            [self.navigationController pushVC:vc];

        }else if(indexPath.row == 9){
            HHInviteCodeVC *vc = (HHInviteCodeVC *)self.vc_arr[indexPath.row];
            vc.IsGenerateCode = NO;
            [self.navigationController pushVC:vc];

        }else{
        
            UIViewController *vc = self.vc_arr[indexPath.row];
            [self.navigationController pushVC:vc];
            
        }
    }

}
@end
