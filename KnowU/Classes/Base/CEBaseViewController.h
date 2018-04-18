//
//  CEBaseViewController.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/10/12.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEBaseViewController : UIViewController
/** * 设置导航栏名字 */
-(UILabel*)setTitleName:(NSString*)name andFont:(CGFloat)fontH;
/** * 设置导航按钮(有字)(无字) */
-(UIButton*)setNavButtonImageName:(NSString*)imageName andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector;
//带有pagecontroller的跳转
-(void)pushController:(UIViewController *)view;
//presend
-(void)presentController:(UIViewController*)view;
-(void)setNoNavBarBackBtn;
//present过来的界面
-(void)setPresentVCBackBtn;
#pragma mark--处理导航栏按钮间距
-(void)resoleBarItemForSpaceWithItem:(UIBarButtonItem *)item andIsLeft:(BOOL)isLeft;
#pragma mark--导航栏按钮纯文字
-(UIButton*)setNavWithTitle:(NSString *)title Font:(CGFloat)font andTextColor:(NSString*)color andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector;

@end
