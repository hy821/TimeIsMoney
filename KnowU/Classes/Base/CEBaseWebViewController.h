//
//  BaseWebViewController.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "CEBaseViewController.h"
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSUInteger, WebType) {
    /**
     *  webview
     */
    NormalType       = 0,
    /**
     *  wkWebView
     */
    WKType             = 1,
    
};
@interface CEBaseWebViewController : CEBaseViewController

@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,assign) WebType webType;
//点击
@property (nonatomic,assign) BOOL shouldTap;
@property (nonatomic,assign) NSString * pushClassName;

@property (nonatomic,copy) NSString * imageName;

@property (nonatomic,assign) BOOL isNavBarHidden;

@property (nonatomic,copy) void (^rightBarItemClick)(CEBaseWebViewController * VC,WKWebView * wkWeb);

@end

