//
//  HHPostTimeLineVC.h
//  springDream
//
//  Created by User on 2018/9/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHPostTimeLineVCDelegate<NSObject>

- (void)postTimeLineComplete;

@end

@interface HHPostTimeLineVC : UIViewController

@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;
@property (nonatomic ,assign) NSInteger section;

@property(nonatomic, assign) id<HHPostTimeLineVCDelegate> delegate;

@end
