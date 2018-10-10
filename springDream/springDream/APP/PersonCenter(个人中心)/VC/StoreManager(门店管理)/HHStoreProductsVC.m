//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHStoreProductsVC.h"
#import "HXHomeCollectionCell.h"
#import "SGSegmentedControl.h"
#import "SearchView.h"
#import "SearchDetailViewController.h"
#import "HHGoodDetailVC.h"
#import "SDTimeLineTableViewController.h"
#import "HHMyStoreVC.h"

@interface HHStoreProductsVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGSegmentedControlDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHMyStoreVCDelagete>

@property (nonatomic, strong)   UICollectionView *collectionView;
@property(nonatomic,strong)     SGSegmentedControl *SG;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property(nonatomic,assign)    NSInteger page;
@property(nonatomic,assign)   NSInteger pageSize;
@property(nonatomic,strong)   NSMutableArray *datas;
@property(nonatomic,assign)   NSInteger  orderState;
@property(nonatomic,assign)   BOOL  isFooterRefresh;
@property(nonatomic,strong)   NSURLSessionDataTask *task;
@property(nonatomic,assign)   BOOL  isCategory;
@property(nonatomic,assign)   BOOL  isGoodDetailBack;
@property(nonatomic,strong)   UIImageView *imagV;
@property(nonatomic,strong)   UILabel *name_label;
@property(nonatomic,strong)   UILabel *address_label;
@property(nonatomic,strong)   UILabel *call_label;
@property(nonatomic,strong)   NSString *store_Id;

@end

@implementation HHStoreProductsVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"门店商品";

    //商品列表
    self.page = 1;
    self.pageSize = 20;
    
    self.isCategory = YES;
    
    self.store_Id = self.store_model.store_id;

    [self setupSGSegmentedControl];
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    
    //获取数据
    [self addHeadRefresh];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)post_buttonAction{
    SDTimeLineTableViewController *vc = [SDTimeLineTableViewController new];
    [self.navigationController pushVC:vc];
}

#pragma mark - SGSegmentedControl init

- (void)setupSGSegmentedControl{
    
    UIView *store_head = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(90)) backColor:kWhiteColor];
    [self.view addSubview:store_head];
    store_head.userInteractionEnabled = YES;
    WEAKSELF;
    [store_head setTapActionWithBlock:^{
        HHMyStoreVC *vc = [HHMyStoreVC new];
        vc.delegate = self;
        [weakSelf.navigationController pushVC:vc];
    }];
    
    _imagV = [[UIImageView alloc] initWithFrame:CGRectMake(WidthScaleSize_W(10), WidthScaleSize_H(10), WidthScaleSize_H(70), WidthScaleSize_H(70))];
    _imagV.image = [UIImage imageNamed:@""];
    [_imagV lh_setCornerRadius:0 borderWidth:1 borderColor:KVCBackGroundColor];
    [store_head addSubview:_imagV];
    
    self.name_label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(self.imagV.frame)+WidthScaleSize_W(10), self.imagV.mj_y, ScreenW-CGRectGetMaxX(self.imagV.frame)-WidthScaleSize_W(40), WidthScaleSize_H(20)) text:@"" textColor:kBlackColor font:MediumFONT(15) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [store_head addSubview:self.name_label];
    self.address_label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(self.imagV.frame)+WidthScaleSize_W(10), CGRectGetMaxY(self.name_label.frame), ScreenW-CGRectGetMaxX(self.imagV.frame)-WidthScaleSize_W(40), WidthScaleSize_H(18)) text:@"" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [store_head addSubview:self.address_label];
    self.call_label = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(self.imagV.frame)+WidthScaleSize_W(10), CGRectGetMaxY(self.address_label.frame), ScreenW-CGRectGetMaxX(self.imagV.frame)-WidthScaleSize_W(40), WidthScaleSize_H(18)) text:@"" textColor:kDarkGrayColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [store_head addSubview:self.call_label];
    
    UIImageView *arrow_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(ScreenW-WidthScaleSize_H(60), 0, WidthScaleSize_H(50), WidthScaleSize_H(90)) image:[UIImage imageNamed:@"exchangeStore"]];
    arrow_imagV.contentMode = UIViewContentModeCenter;
    [store_head addSubview:arrow_imagV];

    
    self.title_arr = [NSMutableArray arrayWithArray:@[@"上新",@"销量",@"价格"]];
    NSArray *nomalImageArr = @[@"",@"",@"pArrow"];
    NSArray *selectedImageArr = @[@"",@"",@"pArrow_top"];
    
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, CGRectGetMaxY(store_head.frame), self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeStatic nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:self.title_arr];
    }else{
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, CGRectGetMaxY(store_head.frame), self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeScroll nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:self.title_arr];
    }
    UIView *h_line1 = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 1) backColor:KVCBackGroundColor];
    UIView *h_line2 = [UIView lh_viewWithFrame:CGRectMake(0, 43, ScreenW, 1) backColor:KVCBackGroundColor];
    [self.SG addSubview:h_line1];
    [self.SG addSubview:h_line2];

    [self.SG setPriceTop:@"pArrow_top" price_down:@"pArrow_down"];
    self.SG.titleColorStateNormal = kBlackColor;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(14);
    self.SG.showsBottomScrollIndicator = NO;
    [self.view addSubview:_SG];
    
    [self.imagV sd_setImageWithURL:[NSURL URLWithString:self.store_model.store_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.name_label.text = self.store_model.store_name;
    self.address_label.text = self.store_model.store_address;
    self.call_label.text = self.store_model.store_phone;
    
}
#pragma 加载数据

- (void)getDatas{
    
    self.task =  [[[HHCategoryAPI GetProductListWithType:self.type storeId:self.store_Id categoryId:nil name:self.name orderby:self.orderby page:@(self.page) pageSize:@(self.pageSize) IsCommission:nil groupId:nil] netWorkClient] getRequestInView:(self.isFooterRefresh||self.isGoodDetailBack)?nil:self.view finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
        self.collectionView.emptyDataSetDelegate = self;
        self.collectionView.emptyDataSetSource = self;
        
        if (!error) {
            
            if (api.State == 1) {
                
                if (self.isFooterRefresh==YES) {
                    [self loadDataFinish:api.Data];
                }else{
                    [self addFootRefresh];
                    [self.datas removeAllObjects];
                    [self loadDataFinish:api.Data];
                }
            }else{
                if ([api.Msg isEqualToString:@"cancelled"]) {
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
            
        }else{
            if ([error.localizedDescription isEqualToString:@"已取消"]) {
                
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }
    }];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"img_list_disable"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"还没有相关的宝贝，先看看其他的吧～" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
#pragma mark - 刷新控件

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = NO;
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.collectionView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        [self getDatas];
    }];
    self.collectionView.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (arr.count < self.pageSize) {
        
        [self endRefreshing:YES];
        
    }else{
        [self endRefreshing:NO];
    }
}

/**
 *  结束刷新
 */
- (void)endRefreshing:(BOOL)noMoreData {
    // 取消刷新
    self.collectionView.mj_footer.hidden = NO;
    
    if (noMoreData) {
        if (self.datas.count == 0) {
            self.collectionView.mj_footer.hidden = YES;
        }else {
            [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        
        [self.collectionView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.collectionView.mj_header.isRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
    
    if (self.collectionView.mj_footer.isRefreshing) {
        [self.collectionView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.collectionView reloadData];
    
}
- (void)backAction{
    
    [self.navigationController popVC];
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index{
    self.isFooterRefresh = NO;
    [self.task cancel];
    
    self.page = 1;
    
    if (index == 0){
        //上新
        if (self.orderState==3) {
            self.orderState = 4;
        }else{
            self.orderState = 3;
        }
        self.orderby = @(self.orderState);
        [self getDatas];
        
        
    }else if (index == 1){
        
        //销量
        if (self.orderState==7) {
            self.orderState = 8;
        }else{
            self.orderState = 7;
        }
        self.orderby = @(self.orderState);
        [self getDatas];
    }
    else if (index == 2){
        
        //价格
        if (self.orderState==1) {
            self.orderState = 2;
        }else{
            self.orderState = 1;
        }
        self.orderby = @(self.orderState);
        
        [self getDatas];
    }
    
}

#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
    cell.goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.view = self.view;
    cell.indexPath = indexPath;
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 2)/2 , 240);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 1, 1, 0);
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return  CGSizeMake(0.001, 0.001);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return  CGSizeMake(0.001, 0.001);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCategoryModel *goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    HHGoodDetailVC *vc = [HHGoodDetailVC new];
    vc.Id = goodsModel.Id;
    [self.navigationController pushVC:vc];
    vc.goodDetail_backBlock = ^{
        self.isGoodDetailBack = YES;
        self.isFooterRefresh = NO;
        [self getDatas];
    };
}
#pragma mark- HHMyStoreVCDelagete

-(void)didSelectRowWithstoreModel:(HHMineModel *)storeModel{
    
    [self.imagV sd_setImageWithURL:[NSURL URLWithString:storeModel.store_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.name_label.text = storeModel.store_name;
    self.address_label.text = storeModel.store_address;
    self.call_label.text = storeModel.store_phone;
    self.store_Id = storeModel.store_id;
    self.isGoodDetailBack = YES;
    self.isFooterRefresh = NO;
    [self getDatas];
}


- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SG.frame), SCREEN_WIDTH, SCREEN_HEIGHT - Status_HEIGHT-40-44) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

@end
