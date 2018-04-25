//
//  BaseWebViewController.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "CEBaseViewController.h"
#import <WebKit/WebKit.h>

@interface CEBaseWebViewController : CEBaseViewController

@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic,assign) BOOL isNavBarHidden;
@property (nonatomic,copy) void (^rightBarItemClick)(CEBaseWebViewController * VC,WKWebView * wkWeb);

@end

