//
//  HHPostTimeLineVC.m
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPostTimeLineVC.h"
#import "TZImagePickerController.h"
#import "CollectionViewCell.h"

typedef   void (^completeHandle)();

@interface HHPostTimeLineVC ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YYTextViewDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
    MBProgressHUD  *hud;
}
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic, strong)   UITextField *text_filed;
@property (nonatomic, strong)   YYTextView *text_view;
@property BOOL isSelectOriginalPhoto;
@end

@implementation HHPostTimeLineVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发布";
    
    self.text_filed = [UITextField lh_textFieldWithFrame:CGRectMake(25, 20, ScreenW-50, 45) placeholder:@"输入30字以内副标题" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.view addSubview:self.text_filed];

    self.text_view = [[YYTextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.text_filed.frame), ScreenW-50, 90)];
    self.text_view.placeholderText = @"你想表达什么？";
    [self.view addSubview:self.text_view];
  
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    
}
- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (NSMutableArray *)assestArray{
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _margin = 4;
        _itemWH = (ScreenW - 2 * _margin - 4) / 3 - _margin;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake((ScreenW - 50)/ 4, (ScreenW - 50)/ 4);
        flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, WidthScaleSize_H(150), ScreenW, WidthScaleSize_H(100)) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //self.collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidEndEditing:(YYTextView *)textView{
    
    HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    HHproductEvaluateModel  *evaluate_m  = oEvaluateItem.productEvaluate[self.section];
    evaluate_m.content = textView.text;
    [oEvaluateItem write];
    
    NSLog(@"textViewDidEndEditing");
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 200 && range.length!=1){
        textView.text = [toBeString substringToIndex:200];
        return NO;
    }
    return YES;
}
- (void)checkLocalPhoto{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    //上传多张图片
    [self uploadPhotosWithPhotos:photos completeHandle:^{
        [hud hideAnimated:YES];
        self.photosArray = [NSMutableArray arrayWithArray:photos];
        self.assestArray = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        [_collectionView reloadData];
        
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photosArray.count) {
        [self checkLocalPhoto];
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            //上传多张图片
            [self uploadPhotosWithPhotos:photos completeHandle:^{
                _photosArray = [NSMutableArray arrayWithArray:photos];
                _assestArray = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_photosArray.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _photosArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == _photosArray.count) {
        cell.imagev.image = [UIImage imageNamed:@"add_pic"];
        //cell.imagev.backgroundColor = [UIColor redColor];
        cell.deleteButton.hidden = YES;
        
    }else{
        cell.imagev.image = _photosArray[indexPath.row];
        cell.deleteButton.hidden = NO;
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
#pragma mark- 上传多张图片

- (void)uploadPhotosWithPhotos:(NSArray *)photos completeHandle:(completeHandle)completeHandle{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = KA0LabelColor;
    hud.detailsLabelText = @"完成中";
    hud.detailsLabelColor = kWhiteColor;
    hud.detailsLabelFont = FONT(14);
    hud.activityIndicatorColor = kWhiteColor;
    [hud show:YES];
    
    NSMutableArray *photo_datas = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [photo_datas addObject:imageData];
    }];
    [[[HHMineAPI postUploadManyImageWithimageDatas:photo_datas] netWorkClient] uploadFileInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        [hud hideAnimated:YES];
        if (!error) {
            if (api.State == 1) {
                HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
                if (oEvaluateItem.productEvaluate>0) {
                    HHproductEvaluateModel  *evaluate_m  = oEvaluateItem.productEvaluate[self.section];
                    evaluate_m.pictures = api.Path;
                    
                    [oEvaluateItem write];
                    completeHandle();
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
- (void)deletePhotos:(UIButton *)sender{
    
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

@end
