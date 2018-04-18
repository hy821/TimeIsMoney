//
//  AppDelegate.h
//  KnowU
//
//  Created by young He on 2018/4/17.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CETabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) CETabBarController * tabBarVC;
- (void)restoreRootViewController:(UIViewController *)rootViewController;

@end

