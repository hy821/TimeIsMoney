//
//  CETabBar.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/12/14.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "CETabBar.h"

@implementation CETabBar

#pragma mark - Override Methods
- (void)setFrame:(CGRect)frame
{
    if (self.superview &&CGRectGetMaxY(self.superview.bounds) !=CGRectGetMaxY(frame)) {
        frame.origin.y =CGRectGetHeight(self.superview.bounds) -CGRectGetHeight(frame);
    }
    [super setFrame:frame];
}

#pragma mark - Initial Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translucent =false;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
