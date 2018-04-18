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
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface CEBaseWebViewController ()
<UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
WKScriptMessageHandler>
@property (nonatomic,weak) YHWebViewProgressView * progressView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic,strong) UIView * showErrorView;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * nameLable;

@property (nonatomic,strong) WKWebView * wkWeb;

@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton * closeBtn;
@property (nonatomic,copy) NSString * currentAccid;
@property (nonatomic,copy) NSString * userId;

@property (nonatomic,assign) BOOL isFirstAppear;

@property (nonatomic,assign) BOOL isNeedSendJS;

@property (nonatomic,assign) BOOL isWhite;
//打电话监听
//@property (nonatomic, strong) CTCallCenter *callCenter;
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

- (UIImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithImage:Image_Named(@"netError")];
        _imageView.userInteractionEnabled = YES;
    }return _imageView;
}

-(UILabel *)nameLable {
    if(_nameLable == nil) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = Font_Size(16);
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.textColor = [UIColor colorWithHexString:@"333333"];
        _nameLable.text = @"网址加载失败,请点击再次加载!";
    }return _nameLable;
}

-(UIView *)showErrorView {
    if(_showErrorView == nil) {
        _showErrorView = [[UIView alloc]init];
        [_showErrorView addSubview:self.imageView];
        [_showErrorView addSubview:self.nameLable];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_showErrorView.center);
        }
         ];
        [self.nameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(16);
            make.height.mas_equalTo(20.f);
            make.left.right.equalTo(_showErrorView);
        }];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_showErrorView addGestureRecognizer:tap];
    }return _showErrorView;
}

-(void)tap {
    self.showErrorView.hidden = YES;
    //    SSHudShow(self.view, @"加载中");
    [self.view bringSubviewToFront:self.progressView];
    //    [self.webView reload];
    //    if(self.webType == NormalType){
    //        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];
    //    }else
    //    {
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];
    //    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return self.isWhite?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.isWhite = self.isNavBarHidden;
    self.webType = WKType;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else
    {
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
        
        // register for orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    [self createUI];
    [self resolveURL];
    if (self.titleStr) {
        self.title = _titleStr;
    }
    self.navigationItem.leftBarButtonItem = self.backItem;
    //    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = self.isNavBarHidden;
    if(self.imageName)
    {
        [self setNavButtonImageName:self.imageName andIsLeft:NO andTarget:self andAction:@selector(rightBtnClick:)];
    }
    
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

-(void)rightBtnClick:(UIButton*)sender
{
    if(self.rightBarItemClick)
    {
        self.rightBarItemClick(self,self.wkWeb);
    }
}

- (void)createUI
{
    if(self.webType == NormalType) {
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }else {
        [self.view addSubview:self.wkWeb];
        if(self.isNavBarHidden)
        {
            CGFloat  height = self.isNavBarHidden?[UIApplication sharedApplication].statusBarFrame.size.height:[self contentOffset];
            self.wkWeb.frame = CGRectMake(0,height, ScreenWidth, ScreenHeight - height);
//            CTCallCenter *callCenter = [[CTCallCenter alloc] init];
//            WS()
//            callCenter.callEventHandler = ^(CTCall* call) {
//                if ([call.callState isEqualToString:CTCallStateDisconnected])
//                {
//                    weakSelf.wkWeb.y = height;
//                    NSLog(@"挂断了电话咯Call has been disconnected");
//                }
//                else if ([call.callState isEqualToString:CTCallStateConnected])
//                {
//                    weakSelf.wkWeb.y = 0.f;
//                    NSLog(@"电话通了Call has just been connected");
//                }
//                else if([call.callState isEqualToString:CTCallStateIncoming])
//                {
//                    NSLog(@"来电话了Call is incoming");
//                }
//                else if ([call.callState isEqualToString:CTCallStateDialing])
//                {
//                    weakSelf.wkWeb.y = 0.f;
//                    NSLog(@"正在播出电话call is dialing");
//                }
//                else
//                {
//                    NSLog(@"嘛都没做Nothing is done");
//                }
//            };
//            self.callCenter = callCenter;
        }else{
            [self.wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.view).offset(self.isNavBarHidden?20.f:[self contentOffset]);
            }];
        }
    }
    if(self.shouldTap)
    {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPage)];
        tap.delegate = self;
        if(self.webType == NormalType)
        {
            [self.webView addGestureRecognizer:tap];
        }else
        {
            [self.wkWeb addGestureRecognizer:tap];
        }
    }
    [self.view addSubview:self.showErrorView];
    self.showErrorView.hidden = YES;
    self.showErrorView.backgroundColor = [UIColor whiteColor];
    [self.showErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
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

// 允许多个手势并发 webView中已经内部集成了点击、滑动等手势，当我们自己新建了一个tap手势，设置代理，添加手势后，仍需要实现允许多个手势并发的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)pushToPage
{
    Class class = NSClassFromString(self.pushClassName);
    CEBaseViewController * VC = [[class alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)resolveURL
{
    [self.wkWeb addObserver:self
                 forKeyPath:@"loading"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"title"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"estimatedProgress"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
//    [self.wkWeb addObserver:self
//                 forKeyPath:goGack
//                    options:NSKeyValueObservingOptionNew
//                    context:nil];
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];

}

#pragma mark--KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
//    if ([keyPath isEqualToString:@"loading"])
//    {
//        //         self.navigationItem.title = @"加载中...";
//        
//    } else if ([keyPath isEqualToString:@"title"])
//    {
//        self.navigationItem.title = self.wkWeb.title;
//    } else if ([keyPath isEqualToString:@"estimatedProgress"])
//    {
//        [self.progressView setProgress:[change[@"new"] doubleValue] animated:YES];
//        
//    }else if ([keyPath isEqualToString:goGack])
//    {
//        [self updateButtonItems];
//    }
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
            if(!self.isFirstAppear)
            {
                self.isFirstAppear = YES;
                return;
            }
            self.wkWeb.y = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.backBtn.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
}
- (void)updateButtonItems
{
    if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count!=2) {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        if(self.isNavBarHidden)
        {
            self.progressView.y = [self contentOffset];
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.y = [self contentOffset];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.closeBtn.hidden = NO;
            self.fd_interactivePopDisabled = YES;
        }
    } else  if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count==2)
    {
        if(self.isNavBarHidden)
        {
            self.progressView.y = [self contentOffset];
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.y = [self contentOffset];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.closeBtn.hidden = NO;
            self.fd_interactivePopDisabled = YES;
        }
    }
    else
    {
        
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        if(self.isNavBarHidden)
        {
            self.fd_interactivePopDisabled = NO;
            self.closeBtn.hidden = YES;
            self.progressView.y = [UIApplication sharedApplication].statusBarFrame.size.height ;
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.y = [UIApplication sharedApplication].statusBarFrame.size.height;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    if(self.isNavBarHidden){
        self.isWhite = ![self.wkWeb canGoBack];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //     SSDissMissMBHud(self.view, YES);
    if(!self.showErrorView.isHidden)
    {
        self.showErrorView.hidden = YES;
    }
    if (_titleName && _titleName.length > 0) {
        return;
    }
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (title && title.length > 0) {
        [self setTitleName:title];
    }else {
        [self setTitleName:@"Banner广告"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //     SSDissMissMBHud(self.view, YES);
    if(self.showErrorView.isHidden)
    {
        self.showErrorView.hidden = NO;
        [self.view bringSubviewToFront:self.showErrorView];
        [self.view bringSubviewToFront:self.progressView];
        //        [self.view insertSubview:self.progressView aboveSubview:self.showErrorView];
    }
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

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.scalesPageToFit = YES;
        _webView.autoresizesSubviews = NO;
        _webView.backgroundColor = White_Color;
    }return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

