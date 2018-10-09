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
#import "SDListModel.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;

@interface SDTimeLineTableViewController () <SDTimeLineCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, assign)   NSInteger page;
@property(nonatomic,assign)   BOOL  isFooterRefresh;
@property(nonatomic,assign)   BOOL  isprogress;

@property (nonatomic, strong) UITableView *tabView;

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
- (void)loadView{
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView= [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAV_HEIGHT-50) tableViewStyle:UITableViewStylePlain delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    
    [self.view addSubview:self.tabView];
    self.tabView.tableFooterView = [UIView new];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tabView.mj_header beginRefreshing];
    
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.isprogress = YES;
    
    self.title = @"社区";

    self.page = 1;
    
    UIButton *post_button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 45, 40) target:self action:@selector(post_buttonAction) image:nil title:@"发布" titleColor:kWhiteColor font:FONT(14)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:post_button];
    
    UIButton *left_nav_button = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 45, 40) target:self action:@selector(backAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [left_nav_button setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];

    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self.tabView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];

//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addRefreshHeader];

    //获取社区数据
    [self getTimeLineData];
    
   
}

- (void)addRefreshHeader{
    
    //下拉刷新
    _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//      [self refreshDatas];
        [self.dataArray removeAllObjects];
        self.page=1;
        self.isFooterRefresh = NO;
        self.isprogress = YES;
        [self getTimeLineData];
    }];
    
    _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    _refreshHeader.stateLabel.hidden = YES;
    self.tabView.mj_header = _refreshHeader;
    
}
- (void)addRefreshFooter{
    // 上拉加载
    _refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.isFooterRefresh = YES;
        self.isprogress = YES;
        self.page++;
        [self getTimeLineData];
        [self.tabView reloadDataWithExistedHeightCache];
    }];
    self.tabView.mj_footer = _refreshfooter;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
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
    
}
- (void)getTimeLineData{
    
    [[[SDTimeLineAPI  GetContentECSubjectListWithPage:@(self.page) pageSize:@20] netWorkClient] getRequestInView:self.isFooterRefresh||self.isprogress?nil:self.view finishedBlock:^(SDTimeLineAPI *api, NSError *error) {
      
        if (!error) {
            if (api.State == 1) {
                SDListModel *model = [SDListModel mj_objectWithKeyValues:api.Data];
                if (self.isFooterRefresh==YES) {
                    [self loadDataFinish:model.List];
                }else{
                    [self addRefreshFooter];
                    [self.dataArray removeAllObjects];
                    [self loadDataFinish:model.List];
                }
            }
        }
    }];
}

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
    self.tabView.mj_footer.hidden = NO;
    
    if (noMoreData) {
        if (self.dataArray.count == 0) {
            self.tabView.mj_footer.hidden = YES;
        }else {
            [self.tabView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        
        [self.tabView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.tabView.mj_header.isRefreshing) {
        [self.tabView.mj_header endRefreshing];
    }
    
    if (self.tabView.mj_footer.isRefreshing) {
        [self.tabView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.tabView reloadData];
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
            SDTimeLineModel * model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            
            [weakSelf.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tabView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
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
    _currentEditingIndexthPath = [self.tabView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}
- (void)didClickcShareButtonInCell:(UITableViewCell *)cell{
    
    NSIndexPath *indexPath = [self.tabView indexPathForCell:cell];
    SDTimeLineModel *model = [SDTimeLineModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    
    [self shareActionWithText:model.SubjectContent pic:model.ContentECSubjectPicModel];
    
}
- (void)didClickLikeButtonInCell:(UITableViewCell *)cell likeButton:(UIButton *)likeButton
{
    
    NSIndexPath *indexPath = [self.tabView indexPathForCell:cell];
    SDTimeLineModel *model = [SDTimeLineModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];

    [[[SDTimeLineAPI postPriseUnPriseWithsubjectId:model.SubjectId] netWorkClient] postRequestInView:nil finishedBlock:^(SDTimeLineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                likeButton.selected = !likeButton.selected;
                NSRange range = NSMakeRange(3, likeButton.titleLabel.text.length - 4);
                NSString *PraiseCount = [likeButton.titleLabel.text substringWithRange:range];
                
                if (likeButton.selected) {
                    [likeButton setTitle:[NSString stringWithFormat:@"点赞(%ld)",PraiseCount.integerValue+1] forState:UIControlStateNormal];
                }else{
                    [likeButton setTitle:[NSString stringWithFormat:@"点赞(%ld)",PraiseCount.integerValue-1] forState:UIControlStateNormal];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }
    }];
};


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tabView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tabView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tabView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        SDTimeLineModel *model = [SDTimeLineModel mj_objectWithKeyValues:self.dataArray[_currentEditingIndexthPath.row]];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.ContentECSubjectCommentModel];
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            HJUser *user = [HJUser sharedUser];
            commentItemModel.UserName = user.mineModel.UserName;
            commentItemModel.UserId = @"0";
            commentItemModel.Comment = textField.text;
        [temp insertObject:commentItemModel atIndex:0];
        model.ContentECSubjectCommentModel = [temp copy];
        [self.dataArray replaceObjectAtIndex:_currentEditingIndexthPath.row withObject:model];
        [self.tabView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];

        if (_textField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请先填写评论内容～"];
        }else{
            [[[SDTimeLineAPI postCommentWithsubjectId:model.SubjectId comment:_textField.text] netWorkClient] postRequestInView:nil finishedBlock:^(SDTimeLineAPI *api, NSError *error) {
                if (!error) {
                    if (api.State == 1) {
                        
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }
            }];
        }
        
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
-(void)shareActionWithText:(NSString *)text pic:(NSArray *)pic{

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作

            [self shareVedioToPlatformType:platformType pic:pic Text:text];
    }];
}
//分享到不同平台
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType pic:(NSArray *)pic Text:(NSString *)text
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (pic.count>0) {
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:nil];
        SDContentECSubjectPicModel *picMode = pic[0];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picMode.PicUrl]];
        shareObject.shareImage = data;
        messageObject.shareObject = shareObject;
        
    }else{
        messageObject.text = text;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            
        }
    }];
}

@end
