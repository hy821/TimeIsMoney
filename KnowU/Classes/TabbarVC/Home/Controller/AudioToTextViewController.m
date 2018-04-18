//
//  AudioToTextViewController.m
//  KnowU
//
//  Created by young He on 2018/4/18.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "AudioToTextViewController.h"
#import <Speech/Speech.h>

@interface AudioToTextViewController ()<SFSpeechRecognizerDelegate>
@property (nonatomic,weak) UIButton *btn;  //距离感应开关
@property (nonatomic,weak) UILabel *stateLab;  //是否开启距离感应
@property (weak, nonatomic)  UILabel *resultLab;  //转换结果呈现

@property(nonatomic,strong)SFSpeechRecognizer * recognizer ;

//语音识别功能
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest * recognitionRequest ;
@property(nonatomic,strong)SFSpeechRecognitionTask * recognitionTask ;
@property(nonatomic,strong)AVAudioEngine * audioEngine ;

@end

#define ScreenWidth           [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight          [[UIScreen mainScreen]bounds].size.height


@implementation AudioToTextViewController

//------Lasy------//
- (AVAudioEngine *)audioEngine {
    if  (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }return _audioEngine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 150, 50)];
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
    
    UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-300)/2, 200, 300, 60)];
    stateLab.textColor = [UIColor blackColor];
    stateLab.font =    [UIFont boldSystemFontOfSize:30];
    stateLab.textAlignment = NSTextAlignmentCenter;
    stateLab.text = @"距离感应: Off";
    [self.view addSubview:stateLab];
    self.stateLab = stateLab;
    
    UILabel *resultLab = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenHeight-300, ScreenWidth-20, 280)];
    resultLab.numberOfLines = 0;
    resultLab.textColor = [UIColor blackColor];
    resultLab.font =    [UIFont boldSystemFontOfSize:15];
    resultLab.textAlignment = NSTextAlignmentLeft;
    resultLab.text = @"音频转文字结果: ";
    [self.view addSubview:resultLab];
    self.resultLab = resultLab;
}

#pragma mark - 开始录制
- (void)startAudioRecord {
    
}

#pragma mark - 开启距离感应
- (void)btnAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        // [UIApplication sharedApplication].proximitySensingEnabled = YES;
        [UIDevice currentDevice].proximityMonitoringEnabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }else {
        // [UIApplication sharedApplication].proximitySensingEnabled = YES;
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    self.stateLab.text = sender.selected ? @"距离感应: On" : @"距离感应: Off" ;
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
            NSString *resultStr = [[result bestTranscription] formattedString]; //语音转文本
            self.resultLab.text  = resultStr;
            isFinal = [result isFinal];
        }
        if (error || isFinal) {
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

//设备是否可以使用, 状态发生改变时
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        
    }else{
        
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

