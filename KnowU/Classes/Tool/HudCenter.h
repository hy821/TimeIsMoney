//
//  HudCenter.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
@interface HudCenter : NSObject

/**
 * 纯文本
 **/
extern void SSTextHud(UIView * view,NSString *text);

/**
 * 圆圈_Loading
 **/
extern void SSGifShow(UIView * view,NSString * text);

/**
 * 菊花_Loading
 **/
extern void SSHudShow(UIView * view,NSString * text);

/**
 * 显示错误或者成功
 **/
extern void SSSuccessOrErrorHud(UIView * view,NSString *statues,BOOL isSuccess);

/**
 * 隐藏mbhud
 **/
extern void SSDissmissHud(UIView * view,BOOL isAnimated);

@end
