//
//  HHMyStoreVC.h
//  springDream
//
//  Created by User on 2018/9/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHMyStoreVCDelagete<NSObject>

- (void)didSelectRowWithstoreModel:(HHMineModel *)storeModel;

@end
@interface HHMyStoreVC : UITableViewController

@property(nonatomic,assign) id<HHMyStoreVCDelagete>delegate;


@end
