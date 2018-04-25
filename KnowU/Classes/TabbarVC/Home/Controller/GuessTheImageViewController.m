//
//  GuessTheImageViewController.m
//  KnowU
//
//  Created by young He on 2018/4/25.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "GuessTheImageViewController.h"
#import <Speech/Speech.h>
#import "CEBaseWebViewController.h"
#import "BaseWebViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface GuessTheImageViewController ()<SFSpeechRecognizerDelegate>
@property (nonatomic,weak) UILabel *stateLab;  //说明Lab
@property (nonatomic,weak) UITextField *timeTF;  //输入自动结束时间
@property (weak, nonatomic)  UILabel *resultLab;  //转换结果呈现

/** 开始---321---等待触发---已触发,录制中---321---录制结束  */
@property (nonatomic,strong) UIButton *timeBtn;

//语音识别功能
@property(nonatomic,strong)SFSpeechRecognizer * recognizer;
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest * recognitionRequest;
@property(nonatomic,strong)SFSpeechRecognitionTask * recognitionTask;
@property(nonatomic,strong)AVAudioEngine * audioEngine;

/** 运动管理者对象 */
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic,assign) BOOL isJump;
@property (nonatomic,assign) BOOL isStop;
@property (nonatomic,assign) NSInteger currentIndex;  //倒计时记录
@property (nonatomic,assign) double lastZ_num;  //记录z轴转动, 得到是否触发

@property (nonatomic,assign) CurrentState btnState;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation GuessTheImageViewController

//------Lasy------//
- (AVAudioEngine *)audioEngine {
    if  (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }return _audioEngine;
}

//------Lasy------//
- (CMMotionManager *)motionManager {
    if  (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }return _motionManager;
}

//------Lasy------//
-(UIButton *)timeBtn {
    if(_timeBtn == nil) {
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeBtn setTitle:@"开始" forState:UIControlStateNormal];
        self.btnState = CurrentStateStart;
        [_timeBtn setTitleColor:[Utils colorConvertFromString:@"#933BFF"] forState:UIControlStateNormal];
        [_timeBtn.titleLabel setFont: [UIFont boldSystemFontOfSize:18]];
        _timeBtn.layer.masksToBounds = YES;
        _timeBtn.layer.cornerRadius = 8;
        [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_timeBtn setBackgroundColor:[UIColor brownColor]];
        [_timeBtn addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    }return _timeBtn;
}

#pragma mark - 点击开始, 倒计时三秒, 放手机.
-(void)startAnimation:(UIButton*)sender {
    if(self.btnState == CurrentStateStart) {
        [self timeStart];
    }
}

-(void)timeStart {
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.btnState = CurrentStateCountDown;
    self.currentIndex = 3;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%zd",self.currentIndex] forState:UIControlStateNormal];
    self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)timeRun {
    if(self.currentIndex == 1) {
        self.timeBtn.userInteractionEnabled = YES;
        [self.timeBtn setTitle:@"等待触发" forState:UIControlStateNormal];
        
        if(self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        self.btnState = CurrentStateWaitForTigger;
        [self startTLY];
        return;
    }
    self.currentIndex--;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%zd",self.currentIndex] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isJump = NO;
    self.isStop = NO;
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
  
    
    
//    [self startRecordAccelerometer];
//    [self startTLY];
}

#pragma mark - 启动加速计 开始收集数据
- (void)startRecordAccelerometer {
    // 1.判断加速计是否可用
    if (!self.motionManager.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }

    //只获取一次
    
//    // 2.开始采样
//    [self.motionManager startAccelerometerUpdates];
//
//    // 在需要的时候,主动获取.获取加速计信息
//    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
//    SSLog(@"-----x:%f ------y:%f ------z:%f", acceleration.x, acceleration.y, acceleration.z);
    
    
    
    //持续获取数据
    
    // 2.设置采样间隔
    self.motionManager.accelerometerUpdateInterval = 1.0;
    
    // 3.开始采样
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (error) return;
        
        // 获取加速计的信息
        CMAcceleration acceleration = accelerometerData.acceleration;
        SSLog(@"---x: %.2f ---y: %.2f ---z: %.2f", acceleration.x, acceleration.y, acceleration.z);
        
    }];
    
}

/*
 平放着:  ---x: 0.01 ---y: 0.01 ---z: -0.99      手机趴着:  z:1
 竖着拿:  ---x: -0.00 ---y: -1.00 ---z: 0.07     倒着: y:1
 右横着拿:  ---x: 1.00 ---y: 0.00 ---z: -0.02      左横着: x:-1
 */

#pragma mark - 开启陀螺仪
- (void)startTLY {
    //如果CMMotionManager的支持获取陀螺仪数据
    if (self.motionManager.gyroAvailable) {
        //设置CMMOtionManager的陀螺仪数据更新频率为0.1；
        self.motionManager.gyroUpdateInterval = 0.2;
        //使用代码块开始获取陀螺仪数据
         NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData *gyroData, NSError *error) {
            NSString *labelText;
            // 如果发生了错误，error不为空
            if (error){
                // 停止获取陀螺仪数据
                [self.motionManager stopGyroUpdates];
                labelText = [NSString stringWithFormat:@"获取陀螺仪数据出现错误: %@", error];
            }else{
                // 分别获取设备绕X轴、Y轴、Z轴上的转速
                labelText = [NSString stringWithFormat: @"绕各轴的转速为\n--------\nX轴: %+.2f\nY轴: %+.2f\nZ轴: %+.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
                SSLog(@"%@",self.resultLab.text);
                /*
                 abs（a） 处理int类型a的取绝对值
                 fabsf(a)  处理float类型a的取绝对值
                 fabs(a)   处理double类型a的取绝对值
                 */
                if (fabs(self.lastZ_num - gyroData.rotationRate.z)>2) {
                    
                    [self.motionManager stopGyroUpdates];
                    
                    self.btnState = CurrentStateRecording;
                    [self startRecording];
                }
                
                self.lastZ_num = gyroData.rotationRate.z;
                
            }
            // 在主线程中更新gyroLabel的文本，显示绕各轴的转速
            [self.resultLab performSelectorOnMainThread:@selector(setText:)withObject:labelText waitUntilDone:NO];
        }];
    }else{
        [self.resultLab performSelectorOnMainThread:@selector(setText:) withObject:@"该设备不支持获取陀螺仪数据！" waitUntilDone:NO];
    }
}

- (void)createUI {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *stateLab = [[UILabel alloc]init];
    stateLab.textColor = [UIColor blackColor];
    stateLab.font =    [UIFont boldSystemFontOfSize:16];
    stateLab.textAlignment = NSTextAlignmentLeft;
    stateLab.numberOfLines = 0;
    stateLab.text = @"说明:\n1,点击开始按钮, 倒计时3秒时间用来平放手机, 倒计时结束按钮变为""等待触发""; \n2,手机平放后, 移动手机将触发录制(触发成功伴有轻微震动提示); \n3,录制时间默认2秒, 可手动设置为2~5秒.";
    [self.view addSubview:stateLab];
    self.stateLab = stateLab;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self contentOffset]+ 20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-50);
    }];
    
    UITextField *timeTF = [[UITextField alloc]init];
    timeTF.borderStyle = UITextBorderStyleRoundedRect;
    timeTF.keyboardType = UIKeyboardTypeNumberPad;
    timeTF.placeholder = @" 录制时间(2~5秒)";
    [self.view addSubview:timeTF];
    self.timeTF = timeTF;
    [self.timeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(10);
        make.left.equalTo(self.stateLab).offset(-2);
        make.width.equalTo(150.f);
        make.height.equalTo(50.f);
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

    [self.view addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
}


- (void)proximityStateDidChange {

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

#pragma mark - 触发: 开始录制
- (void)startRecording {
    
    self.isStop = NO;
    
    if(self.btnState == CurrentStateRecording) {
        
    }else {
        return;
    }
    
    
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
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc{
    [self removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
