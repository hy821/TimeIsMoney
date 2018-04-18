//
//  TabBarController.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/10/9.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "CETabBarController.h"
#import "CETabBar.h"
#import "CEBaseViewController.h"
#import "CEBaseNavViewController.h"
#import "SSLayerAnimation.h"

//#import "LEEAlert.h"
//#import "UIImage+NTESColor.h"
//#import "NTESCustomNotificationDB.h"
//#import "NTESNotificationCenter.h"
//#import "NTESNavigationHandler.h"
//#import "NTESNavigationAnimator.h"
//#import "NTESBundleSetting.h"
//#import "LoginViewController.h"
//#import "NIMKitUtil.h"
//#import "NTESSessionViewController.h"
//#import "MessageViewController.h"
//#import "JDStatusBarNotification.h"
//#import "NTESRedPacketAttachment.h"
//#import "NTESRedPacketTipAttachment.h"
//#import "FlockRedPacketsViewController.h"
//#import "AppDelegate+AliyunSDK.h"
//#import "GroupMemberViewController.h"
//#import "CatCircleViewController.h"
//#import "NewVersionTipView.h"
//#import "ZJAnimationPopView.h"

@interface CETabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger indexFlag;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation CETabBarController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configVC];
    self.delegate = self;
    CETabBar *tabbar = [[CETabBar alloc]init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

-(void)configVC
{
    NSArray * classNames = @[@"HomeViewController",@"MineViewController"];
    NSArray * titles = @[@"KnowU",@"Home"];
    NSArray * normalImg = @[@"tab_homeUnSelect",@"tab_mineUnSelect"];
    NSArray * selectImg = @[@"tab_homeSelect",@"tab_mineSelect"];
    for(int i=0;i<classNames.count;i++)
    {
        Class class=NSClassFromString(classNames[i]);
        CEBaseViewController * root=[[class alloc]init];
        [self addChildController:root title:titles[i] imageName:normalImg[i] selectedImageName:selectImg[i] navVc:[CEBaseNavViewController class]];
    }
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc {
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#933BFF") }forState:UIControlStateSelected];
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#999999") }forState:UIControlStateNormal];
    UINavigationController * nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(UIViewController*)childViewControllerForStatusBarStyle {
    UINavigationController * nav = self.selectedViewController;
    return nav.topViewController;
}

#pragma mark - Notification
- (void)onCustomNotifyChanged:(NSNotification *)notification
{
    //    NTESCustomNotificationDB *db = [NTESCustomNotificationDB sharedInstance];
}

#pragma mark- UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
}
// 动画
- (void)animationWithIndex:(NSInteger) index {
    [SSLayerAnimation animationWithTabbarIndex:index type:BounceAnimation];
    self.indexFlag = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

