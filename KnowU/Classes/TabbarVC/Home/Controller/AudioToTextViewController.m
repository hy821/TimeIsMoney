//
//  AudioToTextViewController.m
//  KnowU
//
//  Created by young He on 2018/4/18.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "AudioToTextViewController.h"
#import <Speech/Speech.h>
#import "CEBaseWebViewController.h"
#import "BaseWebViewController.h"

@interface AudioToTextViewController ()<SFSpeechRecognizerDelegate>
@property (nonatomic,weak) UIButton *btn;  //距离感应开关
@property (nonatomic,weak) UILabel *stateLab;  //是否开启距离感应
@property (nonatomic,weak) UITextField *timeTF;  //输入自动结束时间
@property (weak, nonatomic)  UILabel *resultLab;  //转换结果呈现

@property(nonatomic,strong)SFSpeechRecognizer * recognizer ;

//语音识别功能
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest * recognitionRequest ;
@property(nonatomic,strong)SFSpeechRecognitionTask * recognitionTask ;
@property(nonatomic,strong)AVAudioEngine * audioEngine ;

@property (nonatomic,assign) BOOL isJump;
@property (nonatomic,assign) BOOL isStop;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation AudioToTextViewController

//------Lasy------//
- (AVAudioEngine *)audioEngine {
    if  (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }return _audioEngine;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isJump = NO;
    self.isStop = NO;
    //关闭
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Guess The Image";
    
    [self createUI];
    
    //将设备识别语音设置为中文
    NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    self.recognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
    self.recognizer.delegate = self;
    //发送语音认证请求 (首先要判断设备是否支持语音识别功能)
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"可以语音识别");
                //                self.resultLab.text = @"可以语音识别";
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"用户拒绝访问语音识别,请去设置");
                //                self.resultLab.text = @"用户拒绝访问语音识别,请去设置";
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"不能在该设备上进行语音识别");
                //                self.resultLab.text = @"不能在该设备上进行语音识别";
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"没有授权语音识别");
                //                self.resultLab.text = @"没有授权语音识别";
                break;
            default:
                break;
        }
    }];
}

- (void)createUI {
    self.view.backgroundColor = ThemeColor;
    
    UILabel *stateLab = [[UILabel alloc]init];
    stateLab.textColor = [UIColor blackColor];
    stateLab.font =    [UIFont boldSystemFontOfSize:20];
    stateLab.textAlignment = NSTextAlignmentLeft;
    stateLab.text = @"距离感应: Off";
    [self.view addSubview:stateLab];
    self.stateLab = stateLab;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self contentOffset]+ 20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(50);
    }];
    
    UITextField *timeTF = [[UITextField alloc]init];
    timeTF.borderStyle = UITextBorderStyleRoundedRect;
    timeTF.keyboardType = UIKeyboardTypeNumberPad;
    timeTF.placeholder = @" 触发录制后自动结束录制的时间";
    [self.view addSubview:timeTF];
    self.timeTF = timeTF;
    [self.timeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(10);
        make.left.equalTo(self.stateLab).offset(-2);
        make.width.equalTo(300.f);
        make.height.equalTo(40.f);
    }];
    
    UILabel *secondLab = [[UILabel alloc]init];
    secondLab.textColor = [UIColor blackColor];
    secondLab.font =    [UIFont boldSystemFontOfSize:18];
    secondLab.textAlignment = NSTextAlignmentCenter;
    secondLab.text = @"秒";
    [self.view addSubview:secondLab];
    [secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeTF);
        make.left.equalTo(self.timeTF.mas_right).offset(8);
    }];
    
    UILabel *resultLab = [[UILabel alloc]init];
    resultLab.numberOfLines = 0;
    resultLab.textColor = [UIColor blackColor];
    resultLab.font =    [UIFont boldSystemFontOfSize:15];
    resultLab.textAlignment = NSTextAlignmentLeft;
    resultLab.text = @"音频转文字结果: ";
    [self.view addSubview:resultLab];
    self.resultLab = resultLab;
    [self.resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.f);
        make.right.equalTo(self.view).offset(-20.f);
        make.top.equalTo(self.timeTF.mas_bottom).offset(20);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8;
    [btn setTitle:@"Off" forState:UIControlStateNormal];
    [btn setTitle:@"On" forState:UIControlStateSelected];
    [btn.titleLabel setFont: [UIFont boldSystemFontOfSize:18]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor brownColor]];
    [self.view addSubview:btn];
    self.btn = btn;
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultLab.mas_bottom).offset(20);
        make.left.equalTo(self.stateLab);
        make.width.equalTo(150.f);
        make.height.equalTo(50.f);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - 开启距离感应
- (void)btnAction:(UIButton*)sender {
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (![self.audioEngine isRunning]) {  //没有录制的话, 开始录制
            [self startRecording];
            
        }
        
    } else {
        if ([self.audioEngine isRunning]) {
            [self.audioEngine stop];
            [self.recognitionRequest endAudio];
        }
    }
    
//    if (sender.selected) {
//        // [UIApplication sharedApplication].proximitySensingEnabled = YES;
//        [UIDevice currentDevice].proximityMonitoringEnabled = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
//    }else {
//        // [UIApplication sharedApplication].proximitySensingEnabled = YES;
//        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
//    self.stateLab.text = sender.selected ? @"距离感应: On" : @"距离感应: Off" ;

}


- (void)proximityStateDidChange {
    if (!self.btn.selected) {
        return;
    }
    
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有物品靠近");
        
        if (![self.audioEngine isRunning]) {  //没有录制的话, 开始录制
            [self startRecording];
            
        }
        
    } else {
        NSLog(@"有物品离开");
        if ([self.audioEngine isRunning]) {
            [self.audioEngine stop];
            [self.recognitionRequest endAudio];
        }
    }
}

#pragma mark - 开始录制
- (void)startRecording {
    
    self.isStop = NO;
    
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bool  audioBool = [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    bool  audioBool1= [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    bool  audioBool2= [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (audioBool || audioBool1||  audioBool2) {
        NSLog(@"可以使用");
    }else{
        NSLog(@"这里说明有的功能不支持");
    }
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    self.recognitionRequest.shouldReportPartialResults = true;
    
    //开始识别任务
    self.recognitionTask = [self.recognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        bool isFinal = false;
        if (result) {
            NSString *keyWord = [[result bestTranscription] formattedString]; //语音转文本
            self.resultLab.text  = keyWord;
            isFinal = [result isFinal];
            
            SSLog(@"---------------->>>>KeyWord:%@",keyWord);
            
            if (!self.isJump && self.isStop) {
                self.isJump = YES;
                SSLog(@"---------------->>>>KeyWord:%@",keyWord);
                BaseWebViewController *vc = [[BaseWebViewController alloc]init];
                NSString *imageUrlStr = [NSString stringWithFormat:@"https://image.baidu.com/search/index?tn=baiduimage&ie=utf-8&word=%@",keyWord];
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)imageUrlStr,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
                vc.bannerUrl = encodedString;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if (error || isFinal) {
             SSLog(@"---------------->>>>结束");
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    bool audioEngineBool = [self.audioEngine startAndReturnError:nil];
    NSLog(@"---->%d",audioEngineBool);
}


#pragma mark - 开启定时器
- (void)addTimer {
    
    /*
     scheduledTimerWithTimeInterval:  滑动视图的时候timer会停止
     这个方法会默认把Timer以NSDefaultRunLoopMode添加到主Runloop上，而当你滑tableView的时候，就不是NSDefaultRunLoopMode了，这样，你的timer就会停了。
     self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
     */
    
    NSInteger duration = [self.timeTF.text integerValue];
    if (duration==0) {
        duration = 3;
    }
    self.timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(StopRecord) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)StopRecord {
    [self removeTimer];
    self.isStop = YES;
}


- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    [self removeTimer];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

