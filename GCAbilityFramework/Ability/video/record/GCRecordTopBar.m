//
//  GCRecordTopBar.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/9.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCRecordTopBar.h"
#import <objc/message.h>

@interface GCRecordTopBar()

@property (nonatomic,weak) UIViewController *parentVc;

@end

@implementation GCRecordTopBar

- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc{
    
    if ([super init]) {
        
        self.frame = frame;
        
        self.parentVc = parentVc;
        
        self.backgroundColor = _color(0, 0, 0, 0.4);
        
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    UIButton *closeBT = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    [closeBT setImage:[UIImage imageNamed:@"closeVideo"] forState:UIControlStateNormal];
    [closeBT addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBT];
    
    UIButton *changeCameraBT = [[UIButton alloc] initWithFrame:CGRectMake(_width()-45, 10, 30, 30)];
    [changeCameraBT setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    [changeCameraBT addTarget:self action:@selector(changeCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeCameraBT];
    self.changeCameraBT = changeCameraBT;
    
    UIButton *flashLightBT = [[UIButton alloc] initWithFrame:CGRectMake(_width()-90, 10, 30, 30)];
    [flashLightBT setImage:[UIImage imageNamed:@"flashlightOff"] forState:UIControlStateNormal];
    [flashLightBT setImage:[UIImage imageNamed:@"flashlightOn"] forState:UIControlStateSelected];
    [flashLightBT addTarget:self action:@selector(flashLightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:flashLightBT];
    self.flashLightBT = flashLightBT;
    
}

- (void)closeAction:(UIButton *)close{
    
    SEL closeSEL = NSSelectorFromString(@"dismissAction:");
    
    ((void(*)(id,SEL,UIButton*))objc_msgSend)(self.parentVc,closeSEL,close);
}

- (void)changeCameraAction:(UIButton *)changeCamera{
    
    SEL changeCameraSEL = NSSelectorFromString(@"changeCameraAction:");
    
    ((void(*)(id,SEL,UIButton*))objc_msgSend)(self.parentVc,changeCameraSEL,changeCamera);
}

- (void)flashLightAction:(UIButton *)flashLight{
    
    SEL flashLightSEL = NSSelectorFromString(@"flashLightAction:");
    
    ((void(*)(id,SEL,UIButton*))objc_msgSend)(self.parentVc,flashLightSEL,flashLight);
}

@end
