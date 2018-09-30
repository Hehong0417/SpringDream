//
//  SDTimeLineTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineTableViewController.h"

#import "SDRefresh.h"

#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "HHPostTimeLineVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "GlobalDefines.h"

#import "SDTimeLineAPI.h"
#import "SDTimeLineModel.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;

@interface SDTimeLineTableViewController () <SDTimeLineCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, assign)   NSInteger page;

@end

@implementation SDTimeLineTableViewController

{
//    SDTimeLineRefreshFooter *_refreshFooter;
//    SDTimeLineRefreshHeader *_refreshHeader;
    MJRefreshNormalHeader *_refreshHeader;
    MJRefreshAutoNormalFooter *_refreshfooter;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"社区";

    self.page = 1;
    
    UIButton *post_button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 45, 40) target:self action:@selector(post_buttonAction) image:nil title:@"发布" titleColor:kWhiteColor font:FONT(14)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:post_button];
    
    UIButton *left_nav_button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 45, 40) target:self action:@selector(backAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [left_nav_button setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];

    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //获取社区数据
    [self getTimeLineData];
    
    [self addRefreshHeader];
    
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)addRefreshHeader{
    
    //下拉刷新
    _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//      [self refreshDatas];
        [self.dataArray removeAllObjects];
        self.page=1;
        [self getTimeLineData];
    }];
    
    _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    _refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = _refreshHeader;
    
}
- (void)addRefreshFooter{
    // 上拉加载
    _refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//      [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
        self.page++;
        [self getTimeLineData];
//        [self.tableView reloadDataWithExistedHeightCache];
//        if ([self.tableView.mj_footer isRefreshing]) {
//            [self.tableView.mj_footer endRefreshing];
//        }
    }];
    self.tableView.mj_footer = _refreshfooter;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (!_refreshHeader.superview) {
//
//        _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40, 45)];
//        _refreshHeader.scrollView = self.tableView;
//        __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
//        __weak typeof(self) weakSelf = self;
//        [_refreshHeader setRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
//                [weakHeader endRefreshing];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView reloadData];
//                });
//            });
//        }];
//        [self.tableView.superview addSubview:_refreshHeader];
//    } else {
//        [self.tableView.superview bringSubviewToFront:_refreshHeader];
//    }
}
- (void)refreshDatas{
    
//    __weak typeof(self) weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
    
//        if ([self.tableView.mj_header isRefreshing]) {
//            [self.tableView.mj_header endRefreshing];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView reloadData];
//        });
//    });
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
    [_textField removeFromSuperview];

}

- (void)dealloc
{
//    [_refreshHeader removeFromSuperview];
//    [_refreshFooter removeFromSuperview];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)backAction{
    
    [self.navigationController popVC];
}
- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] colorWithAlphaComponent:1].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.placeholder = @"写评论";
    _textField.font = FONT(14);
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, textFieldH);
    _textField.backgroundColor = [UIColor whiteColor];
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textFieldH)];
    _textField.leftView = left_view;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField resignFirstResponder];
}
- (void)getTimeLineData{
    
    [[[SDTimeLineAPI  GetContentECSubjectListWithPage:@(self.page) pageSize:@20] netWorkClient] getRequestInView:nil finishedBlock:^(SDTimeLineAPI *api, NSError *error) {
      
        if (!error) {
            if (api.State == 1) {
                 
                [self loadDataFinish:api.Data[@"List"]];
                [self addRefreshFooter];

            }
        }
    }];
}
//- (NSArray *)creatModelsWithCount:(NSInteger)count
//{
//    NSArray *iconImageNamesArray = @[@"icon0.jpg",
//                                     @"icon1.jpg",
//                                     @"icon2.jpg",
//                                     @"icon3.jpg",
//                                     @"icon4.jpg",
//                                     ];
//
//    NSArray *namesArray = @[@"GSD_iOS",
//                            @"风口上的猪",
//                            @"当今世界网名都不好起了",
//                            @"我叫郭德纲",
//                            @"Hello Kitty"];
//
//    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
//                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
//                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
//                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
//                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
//                           ];
//
//    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
//                               @"正宗好凉茶，正宗好声音。。。",
//                               @"你好，我好，大家好才是真的好",
//                               @"有意思",
//                               @"你瞅啥？",
//                               @"瞅你咋地？？？！！！",
//                               @"hello，看我",
//                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
//                               @"人艰不拆",
//                               @"咯咯哒",
//                               @"呵呵~~~~~~~~",
//                               @"我勒个去，啥世道啊",
//                               @"真有意思啊你💢💢💢"];
//
//    NSArray *picImageNamesArray = @[ @"pic0.jpg",
//                                     @"pic1.jpg",
//                                     @"pic2.jpg",
//                                     @"pic3.jpg",
//                                     @"pic4.jpg",
//                                     @"pic5.jpg",
//                                     @"pic6.jpg",
//                                     @"pic7.jpg",
//                                     @"pic8.jpg"
//                                     ];
//    NSMutableArray *resArr = [NSMutableArray new];
//
//    for (int i = 0; i < count; i++) {
//        int iconRandomIndex = arc4random_uniform(5);
//        int nameRandomIndex = arc4random_uniform(5);
//        int contentRandomIndex = arc4random_uniform(5);
//
//        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
//        model.iconName = iconImageNamesArray[iconRandomIndex];
//        model.name = namesArray[nameRandomIndex];
//        model.msgContent = textArray[contentRandomIndex];
//
//
//        // 模拟“随机图片”
//        int random = arc4random_uniform(6);
//
//        NSMutableArray *temp = [NSMutableArray new];
//        for (int i = 0; i < random; i++) {
//            int randomIndex = arc4random_uniform(9);
//            [temp addObject:picImageNamesArray[randomIndex]];
//        }
//        if (temp.count) {
//            model.picNamesArray = [temp copy];
//        }
//
//        // 模拟随机评论数据
//        int commentRandom = arc4random_uniform(3);
//        NSMutableArray *tempComments = [NSMutableArray new];
//        for (int i = 0; i < commentRandom; i++) {
//            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
//            int index = arc4random_uniform((int)namesArray.count);
//            commentItemModel.firstUserName = namesArray[index];
//            commentItemModel.firstUserId = @"666";
//            if (arc4random_uniform(10) < 5) {
//                commentItemModel.secondUserName = namesArray[arc4random_uniform((int)namesArray.count)];
//                commentItemModel.secondUserId = @"888";
//            }
//            commentItemModel.Comment = commentsArray[arc4random_uniform((int)commentsArray.count)];
//            [tempComments addObject:commentItemModel];
//        }
//        model.commentItemsArray = [tempComments copy];
//
//        // 模拟随机点赞数据
//        int likeRandom = arc4random_uniform(3);
//        NSMutableArray *tempLikes = [NSMutableArray new];
//        for (int i = 0; i < likeRandom; i++) {
//            SDTimeLineCellLikeItemModel *model = [SDTimeLineCellLikeItemModel new];
//            int index = arc4random_uniform((int)namesArray.count);
//            model.userName = namesArray[index];
//            model.userId = namesArray[index];
//            [tempLikes addObject:model];
//        }
//
//        model.likeItemsArray = [tempLikes copy];
//
//        [resArr addObject:model];
//    }
//    return [resArr copy];
//}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.dataArray addObjectsFromArray:arr];
    
    if (arr.count < 20) {
        
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
    self.tableView.mj_footer.hidden = NO;
    
    if (noMoreData) {
        if (self.dataArray.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.tableView reloadData];
}
#pragma mark - 发布

- (void)post_buttonAction{
    
    HHPostTimeLineVC *vc = [HHPostTimeLineVC new];
    [self.navigationController pushVC:vc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineModel *model = [SDTimeLineModel mj_objectWithKeyValues:weakSelf.dataArray[indexPath.row]];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath) {
            
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
        }];
        
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    cell.model = [SDTimeLineModel mj_objectWithKeyValues:weakSelf.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = [SDTimeLineModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
    _textField.placeholder = @"写评论";
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - SDTimeLineCellDelegate

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}
- (void)didClickcShareButtonInCell:(UITableViewCell *)cell{
    
    
    
}
- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
//    NSIndexPath *index = [self.tableView indexPathForCell:cell];
//    SDTimeLineCellModel *model = self.dataArray[index.row];
//    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
//
//    if (!model.isLiked) {
//        SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
//        likeModel.userName = @"GSD_iOS";
//        likeModel.userId = @"gsdios";
//        [temp addObject:likeModel];
//        model.liked = YES;
//    } else {
//        SDTimeLineCellLikeItemModel *tempLikeModel = nil;
//        for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
//            if ([likeModel.userId isEqualToString:@"gsdios"]) {
//                tempLikeModel = likeModel;
//                break;
//            }
//        }
//        [temp removeObject:tempLikeModel];
//        model.liked = NO;
//    }
//    model.likeItemsArray = [temp copy];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//    });
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        SDTimeLineModel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.ContentECSubjectCommentModel];
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        
        if (self.isReplayingComment) {
            commentItemModel.UserName = @"GSD_iOS";
            commentItemModel.UserId = @"GSD_iOS";
//            commentItemModel.secondUserName = self.commentToUser;
//            commentItemModel.secondUserId = self.commentToUser;
            commentItemModel.Comment = textField.text;
            
            self.isReplayingComment = NO;
        } else {
            commentItemModel.UserName = @"GSD_iOS";
            commentItemModel.Comment = textField.text;
            commentItemModel.UserId = @"GSD_iOS";
        }
        [temp addObject:commentItemModel];
        model.ContentECSubjectCommentModel = [temp copy];
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        _textField.placeholder = @"写评论";
        
        return YES;
    }
    return NO;
}



- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

@end
