//
//  HHLogisticsVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHLogisticsVC.h"
#import "HHLogisticsCell1.h"
#import "HHLogisticsCell0.h"
#import "HHLogisticsHead.h"

@interface HHLogisticsVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   HHMineModel *model;
@property (nonatomic, strong)  HHLogisticsHead *logisticsHead;

@property(nonatomic,assign)   BOOL  isLoading;
@property(nonatomic,assign)   BOOL  isWlan;

@end

@implementation HHLogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物流信息";

    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64 ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHLogisticsCell0" bundle:nil] forCellReuseIdentifier:@"HHLogisticsCell0"];
       [self.tableView registerNib:[UINib nibWithNibName:@"HHLogisticsCell1" bundle:nil] forCellReuseIdentifier:@"HHLogisticsCell1"];
    
    self.logisticsHead = [[[NSBundle mainBundle] loadNibNamed:@"HHLogisticsHead" owner:self options:nil] firstObject];
    
    self.tableView.tableHeaderView = self.logisticsHead;
    
    [self getDatas];
    
}
- (void)getDatas{
    
    [[[HHMineAPI GetOrderExpressWithorderid:self.orderid giftId:nil] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.isLoading = YES;

        if (!error) {
            if (api.State == 1) {
                self.isWlan = YES;
                self.model = [HHMineModel mj_objectWithKeyValues:api.Data[@"express"]];
                self.logisticsHead.com_label.text =  [NSString stringWithFormat:@"物流公司  %@",api.Data[@"company"]];
                self.logisticsHead.orderNumber_label.text = [NSString stringWithFormat:@"运单编号  %@",self.model.nu.length>0?self.model.nu:@""];
                NSString * image_url =  api.Data[@"productIcon"];
                [self.logisticsHead.image_url sd_setImageWithURL:[NSURL URLWithString:image_url]];
                if ([self.model.ischeck isEqual:@1]) {
                    self.logisticsHead.status_label.text = [NSString stringWithFormat:@"物流状态  已签收"];
                }else{
                    self.logisticsHead.status_label.text = [NSString stringWithFormat:@"物流状态  运输中"];
                }
                [self.tableView reloadData];
                
            }else{
                self.isWlan = YES;
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            self.isWlan = NO;
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }

    }];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        if (self.isWlan) {
            return [UIImage imageNamed:@"record_icon_no"];
        }else{
            return [UIImage imageNamed:@"img_network_disable"];
        }
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *titleStr;
    if (self.isLoading) {
        if (self.isWlan) {
            titleStr = @"没有相关的记录喔";
        }else{
            titleStr = @"";
        }
    }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
    
    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20;
}
- (void)addAddressAction{
    
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    HHLogisticsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"HHLogisticsCell1"];
    cell.model =  self.model.data[indexPath.row];
    if (indexPath.row == 0) {
        cell.top_line.hidden = YES;
        cell.red_dot_imageV.image = [UIImage imageNamed:@"logistics1"];
        cell.express_messageLabe.textColor = APP_COMMON_COLOR;
    }else{
        cell.top_line.hidden = NO;
        cell.red_dot_imageV.image = [UIImage imageNamed:@"logistics"];
        cell.express_messageLabe.textColor = kGrayColor;
    }
        cell.separatorInset = UIEdgeInsetsMake(0, 55, 0, 0);
        gridCell = cell;
        
    return gridCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

@end
