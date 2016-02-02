//
//  NSObject+TNAHUD.m
//  Toon
//
//  Created by likuiliang on 15/6/17.
//  Copyright (c) 2015年 思源. All rights reserved.
//

#import "NSObject+TNAHUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define kWINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kWINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
#define kiPhone4 kWINDOW_HEIGHT == 480.0
#define kiPhone5 kWINDOW_HEIGHT == 568.0
#define kiPhone6 (kWINDOW_HEIGHT == 667.0 || kWINDOW_HEIGHT == 736.0)
#define kScreenFull (CGRect){CGPointZero, {kWINDOW_WIDTH, kWINDOW_HEIGHT - 64}}

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation NSObject (TNAHUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    
    [[self HUD] removeFromSuperview];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showMessage:(NSString *)message inView:(UIView *)view {
    
    [self hideHud];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //  显示提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.alpha = 0.7f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    });
    
}

- (void)showHint:(NSString *)hint {
    
    [[self HUD] removeFromSuperview];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = kiPhone5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:5];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    
    [[self HUD] removeFromSuperview];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = kiPhone5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:5];
}

- (void)hideHud{
    [[self HUD] hide:YES];
}

- (void)hideHudAnimated:(BOOL)animated
{
    [[self HUD] hide:animated];
}

-(void)showProgressHudWithHint:(NSString *)hint{
    MBProgressHUD *HUD = nil;
    if ([self HUD]) {
        HUD = [self HUD];
    }else{
        HUD = [[MBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication].delegate window]];
        [self setHUD:HUD];
    }
    HUD.labelText = hint;
    HUD.mode = MBProgressHUDModeIndeterminate; //自转的菊花
    [[[UIApplication sharedApplication].delegate window] addSubview:HUD];
    [HUD show:YES];
}

-(void)hideHudWithHint:(NSString *)hint{
    MBProgressHUD *hud = nil;
    if ([self HUD]) {
        hud = [self HUD];
    }else {
        hud = [[MBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication].delegate window]];
    }
    if (hint.length) {
        hud.labelText = nil;
        hud.detailsLabelText = hint;
        hud.userInteractionEnabled = NO;
        hud.margin = 10.f;
        hud.mode = MBProgressHUDModeText; //纯文本
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    }
    else{
        [hud hide:NO];
    }
}

@end
