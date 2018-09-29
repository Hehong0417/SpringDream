//
//  HHSubmitOrdersVC.h
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHaddress_type_add_cart,
    HHaddress_type_add_productDetail,
    HHaddress_type_Spell_group,
    HHaddress_type_package,
    HHaddress_type_another
    
} HHenter_type;

@interface HHSubmitOrdersVC : UIViewController
@property(nonatomic,strong) NSString *sku_Id;
@property(nonatomic,assign) HHenter_type enter_type;
@property(nonatomic,strong) NSNumber *mode;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSNumber *sendGift;
@property(nonatomic,strong) NSString *gbId;
//购物车ids
@property(nonatomic,strong) NSString *cartIds;
@property(nonatomic,strong) NSString *storeId;

@end

