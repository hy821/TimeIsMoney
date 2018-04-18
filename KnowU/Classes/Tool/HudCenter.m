//
//  HudCenter.m
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "HudCenter.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

/** 颜色(RGB) */
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation HudCenter

void SSTextHud(UIView * view,NSString *text)
{
    if(![text isEqualToString:@"不支持的 URL"])
    {
        if(!view) {
            view = MainWindow;
        }
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showText:text toView:view];
            });
        }else {
            [MBProgressHUD showText:text toView:view];
        }
    }
}

void SSSuccessOrErrorToast(UIView * view,NSString *statues,BOOL isSuccess)
{
    if(!view) {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSuccess)
            {
                [MBProgressHUD showSuccess:statues toView:view];
            }else
            {
                [MBProgressHUD showError:statues toView:view];
            }
        });
    }else{
        if(isSuccess)
        {
            [MBProgressHUD showSuccess:statues toView:view];
        }else
        {
            [MBProgressHUD showError:statues toView:view];
        }
    }
}

void SSHudShow(UIView * view,NSString * text)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            if(text){
                hud.detailsLabelText = text;
            }
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if(text){
            hud.detailsLabelText = text;
        }
    }
}

extern void SSGifShow(UIView * view,NSString * text)
{
    if(!view) {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            if(text){
                hud.detailsLabelText = text;
            }
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if(text){
            hud.detailsLabelText = text;
        }
    }
}

void  SSDissmissHud(UIView * view,BOOL isAnimated)
{
    if(!view) {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:isAnimated];
        });
    }else{
        [MBProgressHUD hideHUDForView:view animated:isAnimated];
    }
}

@end
