//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDistributionGoodsVC.h"
#import "HXHomeCollectionCell.h"
#import "SGSegmentedControl.h"
#import "SearchView.h"
#import "SearchDetailViewController.h"
#import "HHGoodDetailVC.h"
#import "SDTimeLineTableViewController.h"

@interface HHDistributionGoodsVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGSegmentedControlDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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

@end

@implementation HHDistributionGoodsVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = self.title_str;
     // UIButton *post_button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 45, 40) target:self action:@selector(post_buttonAction) image:nil title:@"发现" titleColor:kWhiteColor font:FONT(14)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:post_button];
    
    //商品列表
    self.page = 1;
    self.pageSize = 20;
    
    self.isCategory = YES;
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    [self setupSGSegmentedControl];
    
    //获取数据
    [self addHeadRefresh];
    
    [self getDatas];
    
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
    
    //   self.title_arr = [NSMutableArray arrayWithArray:@[@"价格",@"上新",@"浏览量",@"销量"]];
    self.title_arr = [NSMutableArray arrayWithArray:@[@"上新",@"销量",@"价格"]];
    NSArray *nomalImageArr = @[@"",@"",@"pArrow"];
    NSArray *selectedImageArr = @[@"",@"",@"pArrow_top"];
    
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeStatic nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:self.title_arr];
        //  self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeScroll nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:self.title_arr];
        
        //   self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    [self.SG setPriceTop:@"pArrow_top" price_down:@"pArrow_down"];
    self.SG.titleColorStateNormal = kBlackColor;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(14);
    self.SG.showsBottomScrollIndicator = NO;
    [self.view addSubview:_SG];
    
}
#pragma 加载数据

- (void)getDatas{
    
    self.task =  [[[HHCategoryAPI GetProductListWithType:self.type storeId:nil categoryId:self.isCategory?self.categoryId:nil name:self.name orderby:self.orderby page:@(self.page) pageSize:@(self.pageSize)] netWorkClient] getRequestInView:(self.isFooterRefresh||self.isGoodDetailBack)?nil:self.view finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
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

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - Status_HEIGHT-40-44) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

@end
