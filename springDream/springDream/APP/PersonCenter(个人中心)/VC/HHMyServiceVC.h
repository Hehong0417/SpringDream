//
//  HHMyServiceVC.h
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

typedef enum : NSUInteger {
    MyService_type_vipCenter,
    MyService_type_distributionCenter,
    MyService_type_storesManager,
    MyService_type_delegateCenter
} MyService_type;

#import <UIKit/UIKit.h>

@interface HHMyServiceVC : UIViewController

@property(nonatomic,assign)MyService_type  service_type;

@end
