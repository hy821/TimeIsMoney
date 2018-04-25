//
//  BaseWebViewController.h
//  KnowU
//
//  Created by young He on 2018/4/19.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "CEBaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : CEBaseViewController

@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic,assign) WebType webType;
@property (nonatomic,assign) BOOL isNavBarHidden;

@end
