//
//  GCRecordTopBar.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/9.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCRecordTopBar : UIView

- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc;

@property (nonatomic,weak) UIButton *changeCameraBT;
@property (nonatomic,weak) UIButton *flashLightBT;

@end
