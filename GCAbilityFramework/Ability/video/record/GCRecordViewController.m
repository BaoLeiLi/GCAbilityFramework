//
//  GCRecordViewController.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/9.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCRecordViewController.h"
#import "GCRecordEngine.h"
#import "GCRecordProgress.h"
#import "GCRecordTopBar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GCRecordViewController ()<RecordEngineDelegate>
{
    BOOL _showTopBar;    // 顶部的topBar是否在显示
}

@property (nonatomic,weak) UIButton *recordBT;
@property (nonatomic,weak) GCRecordTopBar *topBar;
@property (weak, nonatomic) GCRecordProgress *progressView;
@property (strong, nonatomic) GCRecordEngine         *recordEngine;
@property (assign, nonatomic) BOOL                    allowRecord;//允许录制
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;
@property (nonatomic,strong) NSTimer *timer;   // 5秒计时,顶部工具条的显示和隐藏

@end

@implementation GCRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allowRecord = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *recordBt = [[UIButton alloc] initWithFrame:CGRectMake(_width()*0.5-40, _height()-100, 80, 80)];
    [recordBt setImage:[UIImage imageNamed:@"videoRecord"] forState:UIControlStateNormal];
    [recordBt setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateSelected];
    [recordBt addTarget:self action:@selector(singleTapAction:) forControlEvents:UIControlEventTouchDown];
    [recordBt addTarget:self action:@selector(stopRecordAction:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.view addSubview:recordBt];
    self.recordBT = recordBt;
    
    GCRecordProgress *progress = [[GCRecordProgress alloc] initWithFrame:CGRectMake(0, _height()- 120, _width(), 5)];
    progress.progressBgColor = _color(186, 186, 186, 1);
    progress.progressColor = _color(248, 48, 46, 1);
    [self.view addSubview:progress];
    self.progressView = progress;
    
    self.topBar.tag = 10;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recordEngine shutdown];
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:aTap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    }
    [self.recordEngine startUp];
}
// 双击
- (void)stopRecordAction:(UIButton *)sender{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAction:) object:self.recordBT];
    
    [self.recordEngine shutdown];
    
}
- (void)recordAction:(UIButton *)sender {
    
    if (self.allowRecord) {
        
        self.recordBT.selected = !self.recordBT.selected;
        if (self.recordBT.selected) {
            if (self.recordEngine.isCapturing) {
                [self.recordEngine resumeCapture];
            }else {
                [self.recordEngine startCapture];
            }
        }else {
            [self.recordEngine pauseCapture];
        }
        [self adjustViewFrame];
    }
}
// 单击
- (void)singleTapAction:(UIButton *)button{
    
    [self performSelector:@selector(recordAction:) withObject:self.recordBT afterDelay:0.5];
}

// 调整顶部工具栏的frame
- (void)adjustViewFrame {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.recordBT.selected) {
            
            if (_showTopBar) {
                self.topBar.frame = CGRectMake(0, -64, _width(), 50);
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                self.topBar.frame = CGRectMake(0, 0, _width(), 50);
            }
            
        }else {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            self.topBar.frame = CGRectMake(0, 0, _width(), 50);
        }
        
        [self.view layoutIfNeeded];
    } completion:nil];
}
// 界面点击,用来显示和隐藏顶部的
- (void)tapAction:(UITapGestureRecognizer *)aTap{
    
    if (self.recordBT.selected) {
        
        [self invalidateTimer];
        
        [self adjustViewFrame];
        
        if (_showTopBar) {
            
            _showTopBar = NO;
            
        }else{
            
            [self startTimer];
            
            _showTopBar = YES;
        }
    }
}

- (void)dismissAction:(UIButton *)sender {
    // 返回视频路径
    if (_recordVideoCallback) {
        self.recordVideoCallback(@{@"data":self.recordEngine.videoPath});
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//开关闪光灯
- (void)flashLightAction:(UIButton *)flashLight{
    if (self.topBar.changeCameraBT.selected == NO) {
        flashLight.selected = !flashLight.selected;
        if (flashLight.selected == YES) {
            [self.recordEngine openFlashLight];
        }else {
            [self.recordEngine closeFlashLight];
        }
    }
}
//切换前后摄像头
- (void)changeCameraAction:(UIButton *)changeCamera{
    changeCamera.selected = !changeCamera.selected;
    if (changeCamera.selected == YES) {
        //前置摄像头
        [self.recordEngine closeFlashLight];
        self.topBar.flashLightBT.selected = NO;
        [self.recordEngine changeCameraInputDeviceisFront:YES];
    }else {
        [self.recordEngine changeCameraInputDeviceisFront:NO];
    }
}
// 初始化定时器
- (void)startTimer{
    __weak typeof(self)weakSelf = self;
    if (@available(iOS 10.0, *)) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerAction];
        }];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    }
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}
// 定时器执行方法
- (void)timerAction{
    
    [self adjustViewFrame];
    _showTopBar = NO;
}
// 销毁定时器
- (void)invalidateTimer{
    
    if (_timer) {
        
        [_timer invalidate];
        
        _timer = nil;
    }
}

#pragma mark - RecordEngineDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self recordAction:self.recordBT];
        self.allowRecord = NO;
    }
    self.progressView.progress = progress;
}

#pragma mark - getter
- (GCRecordTopBar *)topBar{
    
    if (!_topBar) {
        
        GCRecordTopBar *topBar = [[GCRecordTopBar alloc] initWithFrame:CGRectMake(0, 0, _width(), 50) parentVc:self];
        self.topBar = topBar;
        [self.view addSubview:topBar];
    }
    return _topBar;
}
- (GCRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[GCRecordEngine alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

- (void)dealloc {
    _recordEngine = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:[_playerVC moviePlayer]];
}


@end
