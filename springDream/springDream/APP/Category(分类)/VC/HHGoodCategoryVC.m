//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodCategoryVC.h"
#import "HHcategoryCollectionViewCell.h"
#import "SGSegmentedControl.h"
#import "SearchView.h"
#import "SearchDetailViewController.h"
#import "HHGoodDetailVC.h"
#import "HHGoodListVC.h"
#import "HHGoodCategoryLeftView.h"

@interface HHGoodCategoryVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGSegmentedControlDelegate,SearchViewDelegate,SearchDetailViewControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHGoodCategoryLeftViewDelegate,UIGestureRecognizerDelegate>
{
    SearchView *searchView;
    XYQButton *category_btn;
}
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
@property(nonatomic,strong)     SGSegmentedControl *category_SG;
@property(nonatomic,strong)   NSMutableArray *category_arr;
@property(nonatomic,strong)   NSMutableArray *GoodCategoryLeftDatas;
@property (nonatomic, assign) BOOL isCanBack;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HHGoodCategoryVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //商品列表
    self.page = 1;
    self.pageSize = 20;
    
    self.isCategory = YES;
    
    if ([HJUser sharedUser].categoryId) {
        self.categoryId = [HJUser sharedUser].categoryId;
    }
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HHcategoryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HHcategoryCollectionViewCell"];
    
    [self getSectionData];

    [self setupSGSegmentedControl];
    
    [self setupSearchView];
    //获取数据
    [self addHeadRefresh];

    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 40, 45) target:self action:@selector(backBtnAction) image:[UIImage imageNamed:@""]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    HJUser *user = [HJUser sharedUser];
    user.category_selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [user write];
    [self getGoodCategoryLeftDatas];

}
- (void)getGoodCategoryLeftDatas{
    
    [[ [HHCategoryAPI GetNewCategoryList] netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
               self.GoodCategoryLeftDatas =  [HHleft_categoryModel  mj_objectArrayWithKeyValuesArray:arr];
                HHleft_categoryModel *newModel = [HHleft_categoryModel new];
                newModel.Name = @"全部";
                newModel.Id = @"0";
                [self.GoodCategoryLeftDatas insertObject:newModel atIndex:0];
            }
        }
    }];
}
- (void)backBtnAction{
    
    if (self.enter_Type == 1) {
    [self.navigationController popVC];
    }
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)category_arr{
    if (!_category_arr) {
        _category_arr = [NSMutableArray array];
    }
    return _category_arr;
}
- (NSMutableArray *)GoodCategoryLeftDatas{
    if (!_GoodCategoryLeftDatas) {
        _GoodCategoryLeftDatas = [NSMutableArray array];
    }
    return _GoodCategoryLeftDatas;
}

#pragma mark - SGSegmentedControl init

- (void)setupSGSegmentedControl{

    self.title_arr = [NSMutableArray arrayWithArray:@[@"上新",@"销量",@"价格"]];
    NSArray *nomalImageArr = @[@"",@"",@"pArrow"];
    NSArray *selectedImageArr = @[@"",@"",@"pArrow_top"];
    
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeStatic nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:self.title_arr];
    }else{
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeScroll nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:self.title_arr];
    }
    UIView *v_line = [UIView lh_viewWithFrame:CGRectMake(0, 89, ScreenW, 1) backColor:KVCBackGroundColor];
    [self.view addSubview:v_line];
    [self.SG setPriceTop:@"pArrow_top" price_down:@"pArrow_down"];
    self.SG.titleColorStateNormal = kBlackColor;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = BoldFONT(14);
    self.SG.showsBottomScrollIndicator = NO;
    self.SG.hidden = YES;
    [self.view addSubview:_SG];
    
}
#pragma 加载数据

- (void)getDatas{
    
    if (self.groupId||self.categoryId) {
        self.task =  [[[HHCategoryAPI GetProductListWithType:self.type storeId:nil categoryId:self.categoryId name:self.name orderby:self.orderby page:@(self.page) pageSize:@(self.pageSize) IsCommission:nil groupId:self.groupId] netWorkClient] getRequestInView:(self.isLoading||self.isGoodDetailBack)?nil:self.view finishedBlock:^(HHCategoryAPI *api, NSError *error) {
            
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
}
- (void)getSectionData{
    
    [[[HHCategoryAPI GetProductGroup] netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = api.Data;
                NSMutableArray *category_titles = [NSMutableArray array];
                [arr enumerateObjectsUsingBlock:^(NSDictionary  *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    [category_titles addObject:dic[@"name"]];
                }];
                self.category_arr = arr.mutableCopy;
                if (category_titles.count < 5) {
                    self.category_SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeStatic titleArr:category_titles];
                }else{
                    self.category_SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:SGSegmentedControlTypeScroll titleArr:category_titles];
                }
                self.category_SG.titleColorStateNormal = TitleGrayColor;
                self.category_SG.titleColorStateSelected = APP_COMMON_COLOR;
                self.category_SG.title_fondOfSize  = FONT(14);
                self.category_SG.indicatorColor = APP_COMMON_COLOR;
                [self.view addSubview:self.category_SG];
                if (self.category_arr.count == 0) {
                    self.category_SG.hidden = YES;
                    self.SG.hidden = YES;
                }else{
                    self.category_SG.hidden = NO;
                    self.SG.hidden = NO;
                }
                [self SGSegmentedControl:self.category_SG didSelectBtnAtIndex:0];
                
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
    [self getDatas];
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
        self.isLoading = YES;
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
        self.isLoading = YES;
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

#pragma mark - SearchView

- (void)setupSearchView {
    searchView = [[SearchView alloc] initWithFrame:CGRectMake(15, 3, self.view.frame.size.width-30, 30)];
    searchView.textField.text = @"";
    searchView.delegate = self;
    searchView.userInteractionEnabled = YES;
//     if (self.enter_Type == HHenter_category_Type ||self.enter_Type == HHenter_home_Type ) {
//            [self searchButtonWasPressedForSearchView:searchView];
//        }else{
//        }
    NSString *back_navName = @"";
    NSString *back_select_name = @"";
    if (self.enter_Type == 1) {
        back_navName = @"icon_return_default";
        UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(-15, 3, 40, 30) target:self action:@selector(backBtnAction) image:[UIImage imageNamed:back_navName]];
        [searchView addSubview:backBtn];
        
    }else{
        back_navName = @"category_up";
        back_select_name = @"category_down";
        category_btn = [XYQButton ButtonWithFrame:CGRectMake(-15, 0, 40, 35) imgaeName:back_navName titleName:@"分类" contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:kWhiteColor fontsize:WidthScaleSize_W(7)] tapAction:^(XYQButton *button) {
            
            [self showGoodCategoryLeftViewWithStatus:button.selected];
            
        }];
        [category_btn setImage:[UIImage imageNamed:back_select_name] forState:UIControlStateSelected];
        [searchView addSubview:category_btn];
    }
    [self.navigationController.navigationBar addSubview:searchView];
}
- (void)backAction{
    
    [self.navigationController popVC];
}

//显示分类列表
- (void)showGoodCategoryLeftViewWithStatus:(BOOL)status{
    
    HHGoodCategoryLeftView *goodCategoryLeftView = [[HHGoodCategoryLeftView alloc] init];
    goodCategoryLeftView.delegate = self;
    goodCategoryLeftView.datas = self.GoodCategoryLeftDatas;
    [goodCategoryLeftView showAnimated:YES];

}
#pragma mark - SearchViewDelegate

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView {
    
    SearchDetailViewController *searchViewController = [[SearchDetailViewController alloc] init];
    searchViewController.textFieldText = self.name;
    searchViewController.placeHolderText = searchView.textField.text;
    searchViewController.delegate = self;
    searchViewController.enter_Type = self.enter_Type;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController
                       animated:NO
                     completion:nil];
    
}
#pragma mark - HHGoodCategoryLeftViewDelegate

- (void)didselectIndexPath:(NSIndexPath *)indexPath categoryId:(NSString *)categoryId{
    
    HJUser *user = [HJUser sharedUser];
    user.category_selectIndexPath = indexPath;
    [user write];
    self.page = 1;
    self.categoryId = categoryId;
    self.isFooterRefresh = NO;
    self.isLoading = NO;
    self.groupId = nil;
    [self getDatas];
}
- (void)didTapGesWithTapStatus:(BOOL)TapStatus{
    
    category_btn.selected = TapStatus;
    
}

#pragma mark - SearchDetailViewControllerDelegate

- (void)tagViewButtonDidSelectedForTagTitle:(NSString *)title{

    HHGoodListVC *vc = [HHGoodListVC new];
    vc.name = title;
    vc.enter_Type = HHenter_category_Type;
    [self.navigationController pushVC:vc];
}
- (void)dismissButtonWasPressedForSearchDetailView:(id)searchView{
    
    [self.navigationController popToRootVC];
    
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index{
    
    self.categoryId = nil;
    self.page = 1;
    if (segmentedControl == self.SG) {
        self.isFooterRefresh = NO;
        self.isLoading = NO;
        self.isGoodDetailBack = NO;
        [self.task cancel];
        [self refreshSortData:index];
        
    }else  if (segmentedControl == self.category_SG){
        self.isFooterRefresh = NO;
        self.isLoading = NO;
        self.isGoodDetailBack = NO;
        [self.task cancel];
        if (self.category_arr.count>0) {
                    HHCategoryModel  *category_m = [HHCategoryModel mj_objectWithKeyValues:self.category_arr[index]];
                    self.groupId = category_m.Id;
                    [self refreshCategoryData];
        }
    }

}
- (void)refreshSortData:(NSInteger)selectIndex{
    
    if (selectIndex == 0){
        //上新
            self.orderState = 4;
        self.orderby = @(self.orderState);
        [self getDatas];
    }else if (selectIndex == 1){

        self.orderState = 8;
        self.orderby = @(self.orderState);
        [self getDatas];
    }
    else if (selectIndex == 2){
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
- (void)refreshCategoryData{
    
    [self getDatas];
}
#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHcategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHcategoryCollectionViewCell" forIndexPath:indexPath];
    cell.goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 2)/2 , SCREEN_WIDTH/2+WidthScaleSize_W(60));
    
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
    vc.Id = goodsModel.product_id;
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, SCREEN_HEIGHT - Status_HEIGHT-40-64) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    searchView.hidden = NO;
    self.isLoading = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
        searchView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack{
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}
@end
