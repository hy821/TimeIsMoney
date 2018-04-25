//
//  GuessTheImageViewController.h
//  KnowU
//
//  Created by young He on 2018/4/25.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "CEBaseViewController.h"

typedef enum : NSUInteger {
    CurrentStateStart,  //初始状态, 开始
    CurrentStateCountDown,  //倒计时, 321
    CurrentStateWaitForTigger,  //等待触发
    CurrentStateRecording,  //已触发, 录制中
    CurrentStateEnd,  //录制结束
} CurrentState;

@interface GuessTheImageViewController : CEBaseViewController

@end
