//
//  BaseWebViewController.m
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "CEBaseWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "UIColor+Tools.h"
#import "UIViewController+BarButton.h"

@interface CEBaseWebViewController ()
<UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler>
@property (nonatomic,weak) YHWebViewProgressView * progressView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic,strong) WKWebView * wkWeb;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton * closeBtn;

@end

@implementation CEBaseWebViewController
-(UIButton *)backBtn {
    if(!_backBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = button;
    }return _backBtn;
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(64, 20, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = button;
    }return _closeBtn;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _closeItem;
}

#pragma mark - Action
- (void)backAction {
    if ([self.wkWeb canGoBack]) {
        [self.wkWeb goBack];
    } else {
        [self closeSelf];
    }
}

- (void)closeSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; //:UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = White_Color;
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(self.bannerUrl == nil)
    {
        self.bannerUrl = WebHome_Url;
    }
    
    if(self.isNavBarHidden)
    {
        [self.view addSubview:self.backBtn];
        [self.view addSubview:self.closeBtn];
        self.closeBtn.hidden = YES;
        [self.view bringSubviewToFront:self.closeBtn];
        [self.view bringSubviewToFront:self.backBtn];
    }
    
    [self createUI];
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.fd_prefersNavigationBarHidden = self.isNavBarHidden;
    
}

- (void)willChangeStatusBarFrame:(NSNotification*)notification;
{
    CGRect newBarFrame = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    if([self.wkWeb canGoBack]&&self.isNavBarHidden)
    {
        [self.wkWeb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).offset(UIEdgeInsetsMake([self contentOffset], 0, 0, 0));
        }];
        
    }else
    {
        if(self.isNavBarHidden)
        {
            [self.wkWeb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(newBarFrame.size.height , 0, 0, 0));
            }];
        }
    }
}

-(void)rightBtnClick:(UIButton*)sender {
    if(self.rightBarItemClick) {
        self.rightBarItemClick(self,self.wkWeb);
    }
}

- (void)createUI
{
    [self.view addSubview:self.wkWeb];
    if(self.isNavBarHidden) {
        CGFloat  height = self.isNavBarHidden?[UIApplication sharedApplication].statusBarFrame.size.height:[self contentOffset];
        self.wkWeb.frame = CGRectMake(0,height, ScreenWidth, ScreenHeight - height);
    }else{
        [self.wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(self.isNavBarHidden?20.f:[self contentOffset]);
        }];
    }
    
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.isNavBarHidden?[UIApplication sharedApplication].statusBarFrame.size.height :[self contentOffset],ScreenWidth, 3.f)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    // 添加到视图
    [self.view addSubview:progressView];
    self.progressView = progressView;
    [self.view bringSubviewToFront:_progressView];
    if(self.isNavBarHidden)
    {
        [self.view bringSubviewToFront:self.closeBtn];
        [self.view bringSubviewToFront:self.backBtn];
    }
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.wkWeb canGoBack]&&self.isNavBarHidden&&(self.navigationController.isNavigationBarHidden))
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.wkWeb canGoBack]&&self.isNavBarHidden)
    {
        self.wkWeb.y = [self contentOffset];
    }else
    {
        if(self.isNavBarHidden)
        {
            self.wkWeb.y = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.backBtn.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
   
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
   
    [self presentViewController:alertController animated:YES completion:nil];
}

-(WKWebView *)wkWeb
{
    if(_wkWeb == nil) {
        WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc] init];
        wkConfig.userContentController = [[WKUserContentController alloc] init];
        _wkWeb = [[WKWebView alloc]initWithFrame:CGRectZero];
        _wkWeb.UIDelegate = self;
        _wkWeb.navigationDelegate = self;
        //开启手势触摸
        [_wkWeb.scrollView setAlwaysBounceVertical:YES];
        // 这行代码可以是侧滑返回webView的上一级，而不是根控制器（*只针对侧滑有效）
        [_wkWeb setAllowsBackForwardNavigationGestures:true];
        _wkWeb.backgroundColor = [UIColor whiteColor];
    }return _wkWeb;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

