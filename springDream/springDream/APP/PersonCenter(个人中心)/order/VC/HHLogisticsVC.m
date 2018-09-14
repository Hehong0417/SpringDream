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

@interface HHLogisticsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   HHMineModel *model;
@property (nonatomic, strong)  HHLogisticsHead *logisticsHead;


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
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHLogisticsCell0" bundle:nil] forCellReuseIdentifier:@"HHLogisticsCell0"];
       [self.tableView registerNib:[UINib nibWithNibName:@"HHLogisticsCell1" bundle:nil] forCellReuseIdentifier:@"HHLogisticsCell1"];
    
    self.logisticsHead = [[[NSBundle mainBundle] loadNibNamed:@"HHLogisticsHead" owner:self options:nil] firstObject];
    
    self.tableView.tableHeaderView = self.logisticsHead;
    
    [self getDatas];
    
}
- (void)getDatas{
    
    [[[HHMineAPI GetOrderExpressWithorderid:self.orderid giftId:nil] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
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
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }

    }];
    
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
