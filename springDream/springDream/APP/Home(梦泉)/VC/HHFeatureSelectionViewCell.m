//
//  HHFeatureSelectionViewCell.m
//  springDream
//
//  Created by User on 2018/8/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHFeatureSelectionViewCell.h"

@interface HHFeatureSelectionViewCell()
{
    UIView *numbView;
}
#define NSString(type,obj)   [NSString stringWithFormat:(type),(obj)]//强转字符串



/* 选择属性Id */
@property (strong , nonatomic)NSMutableArray *seleId_Array;

/*  */
@property (strong , nonatomic)NSMutableArray *sku_name_value_copy_Array;
/*  */
@property (strong , nonatomic)NSMutableArray *pred_arr;

@property (strong , nonatomic)NSMutableArray *seleSetion_Array;

@property (strong , nonatomic)DCCollectionHeaderLayout *layout;


@property (strong , nonatomic)PPNumberButton *numberButton;

@property (weak) NSMutableArray *attrArray;//当前所有属性对象
@property (weak) NSArray *skuArray;//当前商品活着类别下的所有sku对象
- (NSMutableArray *) GetSelectsku;//获取未选中的属性值
@end

static NSInteger num_;
static NSString *const DCFeatureHeaderViewID = @"DCFeatureHeaderView";
static NSString *const DCFeatureItemCellID = @"DCFeatureItemCell";

@implementation HHFeatureSelectionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.collectionView.backgroundColor = kWhiteColor;
        self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
    
}
///接收通知处理数据
- (void)reloadData{
    
    
    NSArray * skuResult = self.SKUResult;
    [self.skuResult removeAllObjects];
    [self.seletedEnable removeAllObjects];
    [self.seletedIdArray removeAllObjects];
    [self.seletedIndexPaths removeAllObjects];
    [self.skuResult addObjectsFromArray:skuResult];
    
    //取出SKUResult中所有可能的排列组合方式(keysArray)
    NSMutableArray * keysArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in self.skuResult) {
        NSString * key = [[dict allKeys] firstObject];
        [keysArray addObject:key];
    }
    
    int i = 0;
    for (HHproduct_sku_valueModel * model in _featureAttr) {
        
        int x = -1;
        NSString * sku_id = @"";
        for (int j = 0; j < model.ItemList.count; j++) {
            HHsku_name_valueModel * sku_model = model.ItemList[j];
            
            NSString * sku_value_id = NSString(@"%@", sku_model.ValueItemId);
            
            if (sku_model.isSelect == YES) {
                x = j;
                sku_id = sku_value_id;
                break;
            }
        }
        //如果没有选中的
        if (x == -1) {
            [self.seletedIndexPaths addObject:@"0"];
            [self.seletedIdArray addObject:@""];
        }else{
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:x inSection:i];
            [self.seletedIndexPaths addObject:indexPath];
            [self.seletedIdArray addObject:sku_id];
        }
        
        i++;
    }
    
    [self.seletedEnable removeAllObjects];
    
    for (int i = 0; i < _featureAttr.count; i++) {
        HHproduct_sku_valueModel * model = _featureAttr[i];
        for (int j = 0; j < model.ItemList.count; j++) {
            HHsku_name_valueModel * sku_model = model.ItemList[j];
            NSIndexPath * currentIndexPath = [NSIndexPath indexPathForItem:j inSection:i];
            NSString * currentId = NSString(@"%@", sku_model.ValueItemId);
            NSMutableArray * tempArray = [[NSMutableArray alloc]initWithArray:self.seletedIdArray];
            
            [tempArray removeObjectAtIndex:i];
            [tempArray insertObject:currentId atIndex:i];
            NSMutableArray * resultArray = [[NSMutableArray alloc]init];
            for (NSString * str in tempArray) {
                if (![str isEqualToString:@""]) {
                    [resultArray addObject:str];
                }
            }
            
            NSArray * changeArray = [self change:resultArray];
            NSString * resultKey = [changeArray componentsJoinedByString:@"_"];
            
            if (![keysArray containsObject:resultKey]) {
                [self.seletedEnable addObject:currentIndexPath];
            }
        }
        
    }
}
- (void)setGooodDetailModel:(HHgooodDetailModel *)gooodDetailModel{
    _gooodDetailModel = gooodDetailModel;

}
#pragma mark - initialize
- (void)setUpBase
{
    //  product_sku_value数组

    if (_lastSeleArray.count == 0) return;
    
    for (NSString *str in _lastSeleArray) {//反向遍历（赋值）
        
        for (NSInteger i = 0; i < _featureAttr.count; i++) {
            for (NSInteger j = 0; j < _featureAttr[i].ItemList.count; j++) {
                if ([_featureAttr[i].ItemList[j].ValueItemName isEqualToString:str]) {
                    _featureAttr[i].ItemList[j].isSelect = YES;
                    [self.collectionView reloadData];
                }
            }
        }
    }
    if (_lastSele_IdArray.count == 0) return;
    NSString *seleId_str = [NSString stringWithFormat:@"%@_%@",self.product_id,[_lastSele_IdArray componentsJoinedByString:@"_"]];
    [self.product_sku_arr enumerateObjectsUsingBlock:^(HHproduct_skuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.Id isEqualToString:seleId_str]) {
            self.product_price = obj.SalePrice;
            self.product_stock = obj.Stock;
            //                self.goodImageView = obj.imgUrl;
            [self.collectionView reloadData];
        }
    }];
    
}
- (UIView *)setUpNumbView{
    
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"[数量]";
    numLabel.font = FONT(13);
    numLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:numLabel];
    numLabel.frame = CGRectMake(10, 0, 80, 40);
    [numView addSubview:numLabel];
   
    self.numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(ScreenW-115-DCMargin, numLabel.mj_y, 115, numLabel.mj_h)];
    self.numberButton.shakeAnimation = YES;
    self.numberButton.minValue = 1;
    self.numberButton.inputFieldFont = 18;
    self.numberButton.increaseTitle = @"";
    self.numberButton.decreaseTitle = @"";
    num_ = (_lastNum == 0) ?  1 : [_lastNum integerValue];
    self.numberButton.currentNumber = num_;
    self.numberButton.delegate = self;
    
    NSInteger  stock =  self.product_stock.integerValue;
    WEAKSELF;
    self.numberButton.maxValue = stock>0?stock:1;
 
    self.numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        num_ = num;
        weakSelf.Num_ = num;
    };
    [numView addSubview:self.numberButton];
    
    return numView;
    
}
- (void)setProduct_sku_value_arr:(NSArray<HHproduct_sku_valueModel *> *)product_sku_value_arr{
    _product_sku_value_arr = product_sku_value_arr;
    
    _featureAttr = product_sku_value_arr.mutableCopy; //数据
    [self setUpBase];
    [self.collectionView reloadData];
}
- (void)setProduct_sku_arr:(NSArray<HHproduct_skuModel *> *)product_sku_arr{
    
    _product_sku_arr = product_sku_arr;
    
    [self createDataSource:product_sku_arr];
    [self reloadData];

}
#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.layout = [DCCollectionHeaderLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        //自定义layout初始化
        self.layout.delegate = self;
        self.layout.lineSpacing = 8.0;
        self.layout.interitemSpacing = DCMargin;
        self.layout.headerViewHeight = 35;
        self.layout.footerViewHeight = 40;
        self.layout.itemInset = UIEdgeInsetsMake(0, DCMargin, 0, DCMargin);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[DCFeatureItemCell class] forCellWithReuseIdentifier:DCFeatureItemCellID];//cell
        [_collectionView registerClass:[DCFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
        
    }
    return _collectionView;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return _featureAttr.count?_featureAttr.count:1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    NSLog(@"_featureAttr:%@",_featureAttr[section].ItemList);

    return _featureAttr.count?_featureAttr[section].ItemList.count:1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFeatureItemCellID forIndexPath:indexPath];
    if (_featureAttr.count>0) {
        ///不可选
        if ([self.seletedEnable containsObject:indexPath]) {
            cell.content = _featureAttr[indexPath.section].ItemList[indexPath.row];
            cell.userInteractionEnabled = NO;
            cell.attLabel.textColor = [UIColor lightGrayColor];
        }
        //可选
        else
        {
            // cell.attLabel.textColor = [UIColor blackColor];
            cell.content = _featureAttr[indexPath.section].ItemList[indexPath.row];
            cell.userInteractionEnabled = YES;
        }
        
    }
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        
        DCFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID forIndexPath:indexPath];
        if (_featureAttr.count>0) {
            headerView.headTitle = _featureAttr[indexPath.section].ValueName;
        }
        return headerView;
    }else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        
        if (_featureAttr.count == 0) {
            if (numbView) {
                [numbView removeFromSuperview];
            }
            numbView = [self setUpNumbView];
            [footerView addSubview:numbView];
            
        }else if(_featureAttr.count > 0){
            
            if (indexPath.section == _featureAttr.count-1) {
                if (numbView) {
                    [numbView removeFromSuperview];
                }
                numbView = [self setUpNumbView];
                [footerView addSubview:numbView];
            }
        }
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //*****************************//
    
    NSMutableArray * keysArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in self.SKUResult) {
        NSString * key = [[dict allKeys] firstObject];
        [keysArray addObject:key];
    }
    
    //*****************************//
    
    
    //限制每组内的Item只能选中一个(加入质数选择)
    if (_featureAttr[indexPath.section].ItemList[indexPath.row].isSelect == NO) {
        for (NSInteger j = 0; j < _featureAttr[indexPath.section].ItemList.count; j++) {
            _featureAttr[indexPath.section].ItemList[j].isSelect = NO;
        }
    }
    
    _featureAttr[indexPath.section].ItemList[indexPath.row].isSelect = !_featureAttr[indexPath.section].ItemList[indexPath.row].isSelect;
    
    //当前选中的行
    _seleArray = [@[] mutableCopy];
    _seleId_Array = [@[] mutableCopy];
    
    
    for (NSInteger i = 0; i < _featureAttr.count; i++) {
        for (NSInteger j = 0; j < _featureAttr[i].ItemList.count; j++) {
            
            if (_featureAttr[i].ItemList[j].isSelect == YES) {
                [_seleArray addObject:_featureAttr[i].ItemList[j].ValueItemName];
                [_seleId_Array addObject:_featureAttr[i].ItemList[j].ValueItemId];
            }else{
                [_seleArray removeObject:_featureAttr[i].ItemList[j].ValueItemName];
                [_seleId_Array removeObject:_featureAttr[i].ItemList[j].ValueItemId];
                [_lastSeleArray removeAllObjects];
                [_lastSele_IdArray removeAllObjects];
            }
        }
    }
    
    //如果已经被选中则取消选中
    if ([self.seletedIndexPaths containsObject:indexPath]) {
        [self.seletedIndexPaths removeObjectAtIndex:indexPath.section];
        [self.seletedIndexPaths insertObject:@"0" atIndex:indexPath.section];
        [self.seletedIdArray removeObjectAtIndex:indexPath.section];
        [self.seletedIdArray insertObject:@"" atIndex:indexPath.section];
    }
    else
    {
        [self.seletedIndexPaths removeObjectAtIndex:indexPath.section];
        [self.seletedIndexPaths insertObject:indexPath atIndex:indexPath.section];
        [self.seletedIdArray removeObjectAtIndex:indexPath.section];
        [self.seletedIdArray insertObject:_featureAttr[indexPath.section].ItemList[indexPath.row].ValueItemId atIndex:indexPath.section];
    }
    //*******************************//
    
    [self.seletedEnable removeAllObjects];
    for (int i = 0; i < _featureAttr.count; i++) {
        
        for (int j = 0; j < _featureAttr[i].ItemList.count; j++) {
            HHsku_name_valueModel * model = _featureAttr[i].ItemList[j];
            NSIndexPath * currentIndexPath = [NSIndexPath indexPathForItem:j inSection:i];
            NSString * currentId = NSString(@"%@", model.ValueItemId);
            NSMutableArray * tempArray = [[NSMutableArray alloc]initWithArray:self.seletedIdArray];
            [tempArray removeObjectAtIndex:i];
            [tempArray insertObject:currentId atIndex:i];
            
            NSMutableArray * resultArray = [[NSMutableArray alloc]init];
            for (NSString * str in tempArray) {
                if (![str isEqualToString:@""]) {
                    [resultArray addObject:str];
                }
            }
            NSArray * changeArray = [self change:resultArray];
            
            NSString * resultKey = [changeArray componentsJoinedByString:@"_"];
            if (![keysArray containsObject:resultKey]) {
                [self.seletedEnable addObject:currentIndexPath];
            }
        }
        
    }
    
    //*******************************//
    
    
    
    //******//
    //选择完属性，更新库存和价格
    if (_seleArray.count == _featureAttr.count || _lastSeleArray.count == _featureAttr.count) {
        
        NSString *seleId_str = [NSString stringWithFormat:@"%@_%@",self.product_id,[_seleId_Array componentsJoinedByString:@"_"]];
        
        [self.product_sku_arr enumerateObjectsUsingBlock:^(HHproduct_skuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.Id isEqualToString:seleId_str]) {
                self.product_price = obj.SalePrice;
                self.product_stock = obj.Stock;
                //                self.goodImageView = obj.imgUrl;
            }
        }];
    }

    //刷新tableView和collectionView
    [self.collectionView reloadData];
}

#pragma mark - <HorizontalCollectionLayoutDelegate>
#pragma mark - 自定义layout必须实现的方法
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    
    return _featureAttr.count?_featureAttr[indexPath.section].ItemList[indexPath.row].ValueItemName:@"";
}
- (CGSize)collectionViewDynamicFooterSizeWithIndexPath:(NSIndexPath *)indexPath{
    
    if (_featureAttr.count>0) {
        if (indexPath.section == _featureAttr.count-1) {
            return CGSizeMake(ScreenW, 40);
        }else{
            return CGSizeMake(0, 0);
        }
    }else if (_featureAttr.count == 0){
        
        return CGSizeMake(ScreenW, 40);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)collectionViewDynamicHeaderSizeWithIndexPath:(NSIndexPath *)indexPath{
    
    if (_featureAttr.count>0) {
        
        return CGSizeMake(ScreenW, 40);
    }
    return CGSizeMake(0, 0);
}
- (void)collectionViewDynamicCollectionViewHeight:(CGFloat)collectionHeight{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tableviewDynamictablviewHeightWithCollectionHeight:)]) {
        [self.delegate tableviewDynamictablviewHeightWithCollectionHeight:collectionHeight];
    }
    self.collectionView.sd_layout.widthIs(ScreenW);
    self.collectionView.sd_layout.heightIs(collectionHeight);
    
}
-(NSMutableArray *)seletedIdArray
{
    if(_seletedIdArray == nil)
    {
        _seletedIdArray = [[NSMutableArray alloc]init];
    }
    return _seletedIdArray;
}
-(NSMutableArray *)seletedIndexPaths
{
    if(_seletedIndexPaths == nil)
    {
        _seletedIndexPaths = [[NSMutableArray alloc]init];
    }
    return _seletedIndexPaths;
}
-(NSMutableArray *)seletedEnable
{
    if(_seletedEnable == nil)
    {
        _seletedEnable = [[NSMutableArray alloc]init];
    }
    return _seletedEnable;
}
-(NSMutableArray *)skuResult
{
    if(_skuResult == nil)
    {
        _skuResult = [[NSMutableArray alloc]init];
    }
    return _skuResult;
}

-(NSMutableArray *)SKUResult
{
    if(_SKUResult == nil)
    {
        _SKUResult = [[NSMutableArray alloc]init];
    }
    return _SKUResult;
}
#pragma mark - SKU算法
- (void)createDataSource:(NSArray <HHproduct_skuModel *>*)array
{
    NSMutableArray * keysArray = [[NSMutableArray alloc]init];
    NSMutableArray * valuesArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i++) {
        HHproduct_skuModel * model = array[i];
        NSDictionary * dic = @{@"SalePrice":model.SalePrice?model.SalePrice:@"0",@"Stock":model.Stock?model.Stock:@"0",@"imgUrl":model.imgUrl?model.imgUrl:@"0"};
        [keysArray addObject:model.Id];
        [valuesArray addObject:dic];
    }
    
    for (int j = 0; j < keysArray.count; j++) {
        NSString * key = keysArray[j];
        NSArray * subKeyAttrs = [key componentsSeparatedByString:@"_"];
        NSMutableArray * muArray = [[NSMutableArray alloc]initWithArray:subKeyAttrs];
        [muArray removeFirstObject];
        NSArray * resultArray = [self change:muArray];
        
        NSArray * combArr = [self combInArray:resultArray];
        
        NSDictionary * sku = valuesArray[j];
        
        for (int k = 0; k < combArr.count; k++) {
            [self add2SKUResult:combArr[k] sku:sku];
        }
        NSString *keys = [resultArray componentsJoinedByString:@"_"];
        NSString * sku_price = [NSString stringWithFormat:@"%@",sku[@"SalePrice"]];
        NSString * sku_stock = [NSString stringWithFormat:@"%@",sku[@"Stock"]];
        NSMutableArray * prices = [[NSMutableArray alloc]init];
        NSMutableArray * sku_stocks = [[NSMutableArray alloc]init];
        
        [prices addObject:sku_price];
        [sku_stocks addObject:sku_stock];
        
        NSDictionary * dic = @{@"Stock":sku_stock,@"SalePrice":prices,@"Stock":sku_stocks};
        NSDictionary * dict = @{keys:dic};
        [self.SKUResult addObject:dict];
    }
}

- (NSArray *)combInArray:(NSArray *)array
{
    if ([array isKindOfClass:[NSNull class]] || array.count == 0) {
        return @[];
    }
    
    int len = (int)array.count;
    NSMutableArray * aResult = [[NSMutableArray alloc]init];
    
    for (int n = 1; n < len; n++) {
        NSMutableArray * aaFlags = [[NSMutableArray alloc]initWithArray:[self getComFlags:len n:n]];
        
        while (aaFlags.count != 0) {
            NSMutableArray * aFlag = [[NSMutableArray alloc]initWithArray:[aaFlags firstObject]];
            [aaFlags removeObjectAtIndex:0];
            NSMutableArray * aComb = [[NSMutableArray alloc]init];
            for (int i = 0; i < len; i++) {
                if ([aFlag[i] intValue] == 1) {
                    [aComb addObject:array[i]];
                }
            }
            [aResult addObject:aComb];
            
        }
        
    }
    
    return aResult;
}

- (NSArray *)getComFlags:(int)m n:(int)n
{
    if (!n || n < 1) {
        return @[];
    }
    
    NSMutableArray * aFlag = [[NSMutableArray alloc]init];
    BOOL bNext = YES;
    
    for (int i = 0; i < m; i++) {
        int q = i < n ? 1 : 0;
        [aFlag addObject:[NSNumber numberWithInt:q]];
    }
    
    NSMutableArray * aResult = [[NSMutableArray alloc]init];
    [aResult addObject:[aFlag copy]];
    
    int iCnt1 = 0;
    while (bNext) {
        iCnt1 = 0;
        for (int i = 0; i < m - 1; i++) {
            if ([aFlag[i] intValue] == 1 && [aFlag[i+1] intValue] == 0) {
                for (int  j = 0; j < i; j++) {
                    int w = j < iCnt1 ? 1 : 0;
                    [aFlag removeObjectAtIndex:j];
                    [aFlag insertObject:[NSNumber numberWithInt:w] atIndex:j];
                }
                [aFlag removeObjectAtIndex:i];
                [aFlag insertObject:@(0) atIndex:i];
                [aFlag removeObjectAtIndex:i+1];
                [aFlag insertObject:@(1) atIndex:i+1];
                
                NSArray * aTmp = [aFlag copy];
                [aResult addObject:aTmp];
                
                int e = (int)aTmp.count;
                NSString * tempString;
                for (int r = e - n; r < e; r ++) {
                    tempString = [NSString stringWithFormat:@"%@%@",tempString,aTmp[r]];
                }
                if ([tempString rangeOfString:@"0"].location == NSNotFound) {
                    bNext = false;
                }
                
                break;
            }
            if ([aFlag[i] intValue] == 1) {
                iCnt1++;
            }
        }
    }
    return aResult;
}
- (void)add2SKUResult:(NSArray *)combArrItem sku:(NSDictionary *)sku
{
    NSString * key = [combArrItem componentsJoinedByString:@"_"];
    NSMutableArray * keysArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.SKUResult) {
        NSString * keys = [[dic allKeys] firstObject];
        [keysArray addObject:keys];
    }
    
    if ([keysArray containsObject:key]) {
        NSString * price = [NSString stringWithFormat:@"%@",sku[@"SalePrice"]];
        NSString * count = [NSString stringWithFormat:@"%@",sku[@"Stock"]];
        
        NSMutableDictionary * newDic = [[NSMutableDictionary alloc]init];
        int i = 0;
        for (NSDictionary * dict in self.SKUResult) {
            NSString * keys = [[dict allKeys] firstObject];
            if ([keys isEqualToString:key]) {
                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
                NSDictionary * diction = dict[keys];
                NSString * scount = [NSString stringWithFormat:@"%@",diction[@"Stock"]];
                int newCount = [scount intValue] + [count intValue];
                [tempDic setValue:[NSString stringWithFormat:@"%d",newCount] forKey:@"Stock"];
                NSMutableArray * tempArray = [[NSMutableArray alloc]initWithArray:diction[@"SalePrice"]];
                [tempArray addObject:price];
                [tempDic setValue:tempArray forKey:@"SalePrices"];
                [newDic setValue:tempDic forKey:keys];
                [self.SKUResult removeObjectAtIndex:i];
                [self.SKUResult insertObject:newDic atIndex:i];
                break;
            }
            i++;
        }
        
    }
    else
    {
        NSString * price = [NSString stringWithFormat:@"%@",sku[@"SalePrice"]];
        NSString * count = [NSString stringWithFormat:@"%@",sku[@"Stock"]];
        NSMutableArray * prices = [[NSMutableArray alloc]init];
        [prices addObject:price];
        NSDictionary * dic = @{@"sku_stock":count,@"SalePrice":prices};
        NSDictionary * dict = @{key:dic};
        [self.SKUResult addObject:dict];
    }
}
///冒泡排序
- (NSArray *)change:(NSMutableArray *)array
{
    if (array.count > 1) {
        for (int  i =0; i<[array count]-1; i++) {
            
            for (int j = i+1; j<[array count]; j++) {
                
                if ([array[i] intValue]>[array[j] intValue]) {
                    
                    //交换
                    [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                }
                
            }
            
        }
    }
    NSArray * resultArray = [[NSArray alloc]initWithArray:array];
    
    return resultArray;
}

@end
