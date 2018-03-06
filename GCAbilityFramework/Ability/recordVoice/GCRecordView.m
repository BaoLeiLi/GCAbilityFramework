//
//  GCRecordView.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2017/12/12.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

#define LSProgressHUDCircle 80
#define LSProgressHUDLeftMargin 15
#define LSProgressHUDMiddleMargin 10
#define LSProgressHUDTopMargin 10

#import "GCRecordView.h"
#import "GraintCircleLayer.h"
#import "GCRecordVoice.h"

@interface GCRecordView ()
{
    NSInteger _minTimeLength;    // 最小时长
    NSInteger _timeLen;
    NSTimer *_timer;
}

@property(nonatomic, weak) GraintCircleLayer *circleLayer;
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel *timeLength;   // 录音时长
@property (nonatomic,weak) UILabel *fileSize;    // 录音文件的大小
@property (nonatomic,weak) UIButton *endButton;   // 结束
@property (nonatomic,copy) recordVoiceHandler handler;

@end

@implementation GCRecordView

+ (instancetype)shareRecordView{
    
    static GCRecordView *view = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[GCRecordView alloc] init];
    });
    return view;
}

- (void)showWithMinTimeLength:(NSInteger)mTimeLength keyword:(NSString *)keyword handler:(recordVoiceHandler)handler{
    
    if (handler) {
        
        _handler = handler;
    }
    
    _minTimeLength = mTimeLength;
    
    [self setupViews];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    self.frame = CGRectMake(0, 0, SCREENW, SCREENH);
    
    [self setViewsFrame];
    
    _timeLen = 0;
    
    [[GCRecordVoice shareRecordVoice] startRecord:keyword];
    
    [self createTimer];
    
}
/**
 *  @brief 初始化控件
 */
- (void)setupViews{
    
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_record_voice"];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:label];
    self.timeLength = label;
    
    UILabel *size = [[UILabel alloc] init];
    size.textAlignment = NSTextAlignmentCenter;
    size.textColor = [UIColor whiteColor];
    size.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:size];
    self.fileSize = size;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"结束录音" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(endRecordMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.hidden = YES;
    self.endButton = button;
    //[UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1]
    GraintCircleLayer *layer = [[GraintCircleLayer alloc]
                                initGraintCircleWithBounds:CGRectMake(0, 0, 110,110)
                                Position:CGPointMake(0, 0)
                                FromColor:[UIColor colorWithWhite:1.000 alpha:0.318]
                                ToColor:[UIColor colorWithWhite:1 alpha:1]
                                LineWidth:5.0];
    [self.layer addSublayer:layer];
    self.circleLayer = layer;
}
/**
 *  @brief 初始化控件frame
 */
- (void)setViewsFrame {
    
    self.imageView.frame = CGRectMake(SCREENW*0.5 - 35, SCREENH*0.5-100, 70, 70);
    self.timeLength.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+50, SCREENW, 20);
    self.fileSize.frame = CGRectMake(0, CGRectGetMaxY(self.timeLength.frame)+30, SCREENW, 20);
    self.endButton.frame = CGRectMake(0, SCREENH-50, SCREENW, 50);
    self.endButton.transform = CGAffineTransformMakeTranslation(0, SCREENH);
    self.circleLayer.position = self.imageView.center;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI /6 ];
    rotationAnimation.duration = 0.1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [self.circleLayer addAnimation:rotationAnimation forKey:@"rotation"];
    
}
/**
 *  @brief 创建定时器
 */
- (void)createTimer{
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(remeberTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
/**
 *  @brief 计时
 */
- (void)remeberTime{
    
    _timeLen++;
    
    self.timeLength.text = [NSString stringWithFormat:@"%02ld : %02ld",_timeLen/60,_timeLen%60];
    
    if (_timeLen > _minTimeLength && self.endButton.hidden) {
        
        self.endButton.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.endButton.transform = CGAffineTransformIdentity;
        }];
    }
}
/**
 *  @brief 结束录音
 */
- (void)endRecordMethod{
    
    [self invalidateTimer];
    
    CGFloat sizeMB = 0;
    NSDictionary *tmpDict = [[GCRecordVoice shareRecordVoice] stopRecord];
    NSMutableDictionary *voiceInfo = [[NSMutableDictionary alloc] initWithDictionary:tmpDict];
    CGFloat sizeKB = [voiceInfo[kRecordVoiceTime] floatValue];
    [self.circleLayer removeAnimationForKey:@"rotation"];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.endButton.transform = CGAffineTransformMakeTranslation(0, SCREENH);
    }];
    
    if (sizeKB > 1024 && sizeKB > 0) {
        
        sizeMB = sizeKB/1024.0;
    }
    
    if (sizeMB > 0) {
        
        NSString *size_mb = [NSString stringWithFormat:@"%.02f MB",sizeMB];
        
        self.fileSize.text = [NSString stringWithFormat:@"文件大小: %@",size_mb];
        
        [voiceInfo setObject:size_mb forKey:kRecordVoiceFileSize];
        
    }else{
        
        NSString *size_kb = [NSString stringWithFormat:@"%.02f KB",sizeKB];
        
        self.fileSize.text = [NSString stringWithFormat:@"文件大小: %@",size_kb];
        
        [voiceInfo setObject:size_kb forKey:kRecordVoiceFileSize];
    }
    
    if (_handler) {
        
        self.handler(voiceInfo);
        
        _handler = nil;
    }
}
/**
 *  @brief 销毁定时器
 */
- (void)invalidateTimer{
    
    if (_timer) {
        
        [_timer invalidate];
        
        _timer = nil;
    }
}

@end
