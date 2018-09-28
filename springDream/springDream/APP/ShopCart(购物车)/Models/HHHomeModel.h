//
//  HHHomeModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHhomeProductsModel;

@interface HHHomeModel : BaseModel

@property(nonatomic,strong) NSString *category_id;
@property(nonatomic,strong) NSString *category_name;
@property(nonatomic,strong) NSString *category_type;
@property(nonatomic,strong) NSArray *product;

//门店
@property(nonatomic,strong) NSString *store_id;
@property(nonatomic,strong) NSString *store_name;

//月成交记录
@property(nonatomic,strong) NSString *user_name;
@property(nonatomic,strong) NSString *score;
@property(nonatomic,strong) NSString *sku;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSString *finish_date;

@end
@interface HHhomeProductsModel : BaseModel

@property(nonatomic,strong) NSString *product_id;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *product_icon;
@property(nonatomic,strong) NSString *product_max_price;
@property(nonatomic,strong) NSString *product_min_price;
@property(nonatomic,strong) NSString *product_s_intergral;
@property(nonatomic,strong) NSString *product_type;


@end
