//
//  UIViewController+LH.m
//  mengyaProject
//
//  Created by n on 2017/10/9.
//  Copyright © 2017年 n. All rights reserved.
//

#import "UIViewController+LH.h"

@implementation UIViewController (LH)

- (void)lh_showHudInView:(UIView *)view labText:(NSString *)text{

    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        [hud hide:YES];
    }
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = FONT(14);
    hud.detailsLabelColor = kWhiteColor;
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    hud.backgroundView.alpha = 0.5;
    [hud show:true];
    [hud hide:true afterDelay:1.5];
}

@end
