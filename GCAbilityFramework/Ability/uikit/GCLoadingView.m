//
//  GCLoadingView.m
//  GCAbility
//
//  Created by LBL on 2017/11/20.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCLoadingView.h"
#import "GCHelper.h"
#import <objc/runtime.h>

static char *GC_LoadingKey = "GC_LoadingViewKey";
static char *GC_LoadingCoverKey = "GC_LoadingCoverKey";

@implementation GCLoadingView

+ (instancetype)shareGCLoadingView{
    
    static GCLoadingView *loadingV = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadingV = [[GCLoadingView alloc] init];
    });
    return loadingV;
}

- (void)startLoadingAnimation:(NSString *)aMsg coverScreen:(BOOL)cover{
    
    UIViewController *currentVC = [GCHelper getCurrentShowController];
    // 检查是否已经有加载框在
    if (objc_getAssociatedObject(currentVC, GC_LoadingKey)) {
        
        return;
        
    }else{    // 创建加载框
        
        UIView *loadingView;
        if (cover) {
            loadingView = [[UIView alloc] initWithFrame:currentVC.view.bounds];
            loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [currentVC.view addSubview:loadingView];
            [currentVC.view bringSubviewToFront:loadingView];
        }
        
        UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(currentVC.view.frame.size.width*0.5-60, 180, 120, 150)];
        animationView.tag = 9999;
        UIBezierPath *animationPath = [UIBezierPath bezierPathWithRoundedRect:animationView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *animationLayer = [CAShapeLayer layer];
        animationLayer.frame = animationView.bounds;
        animationLayer.path = animationPath.CGPath;
        animationView.layer.mask = animationLayer;
        if (cover) {
            animationView.backgroundColor = [UIColor whiteColor];
        }
        
        NSArray *images = @[[UIImage imageNamed:@"icon_ability_loading_1"],[UIImage imageNamed:@"icon_ability_loading_2"],[UIImage imageNamed:@"icon_ability_loading_3"]];
        
        UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 100, 100)];
        animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        animationImageView.animationImages = images;
        animationImageView.animationDuration = 0.3;
        animationImageView.animationRepeatCount = 0;
        [animationView addSubview:animationImageView];
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 120, 20)];
        msgLabel.font = [UIFont systemFontOfSize:15];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
        msgLabel.hidden = YES;
        msgLabel.text = aMsg;
        [animationView addSubview:msgLabel];
        
        if (cover) {
            [loadingView addSubview:animationView];
            // 将加载框和当前控制器动态绑定
            objc_setAssociatedObject(currentVC, GC_LoadingKey, loadingView, OBJC_ASSOCIATION_RETAIN);
            
        }else{
            [currentVC.view addSubview:animationView];
            [currentVC.view bringSubviewToFront:animationView];
            
            objc_setAssociatedObject(currentVC, GC_LoadingKey, animationView, OBJC_ASSOCIATION_RETAIN);
        }
        objc_setAssociatedObject(currentVC, GC_LoadingCoverKey, [NSNumber numberWithBool:cover], OBJC_ASSOCIATION_RETAIN);
        // 添加动画
        [self scaleAnimationFrom:0.3 to:1 view:animationView];
        // 延时操作，先执行动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 开始动画
            [animationImageView startAnimating];
            msgLabel.hidden = NO;
        });
    }
}

- (void)removeLoadingAnimation{
    
    UIViewController *currentVC = [GCHelper getCurrentShowController];
    // 检查是否有加载框
    if (objc_getAssociatedObject(currentVC, GC_LoadingKey)) {
        
        __block UIView *animationView;
        __block UIView *loadingView;
        
        NSNumber *cover = (NSNumber *)objc_getAssociatedObject(currentVC, GC_LoadingCoverKey);
        
        if ([cover boolValue]) {
            
            loadingView = (UIView *)objc_getAssociatedObject(currentVC, GC_LoadingKey);
            
            animationView = [loadingView viewWithTag:9999];
            
        }else{
            
            animationView = (UIView *)objc_getAssociatedObject(currentVC, GC_LoadingKey);
        }
        // 添加动画
        [self scaleAnimationFrom:1 to:0.5 view:animationView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([cover boolValue]) {
                
                [loadingView removeFromSuperview];
                loadingView = nil;
            }else{
                [animationView removeFromSuperview];
                animationView = nil;
            }
        });
    }
    // 解除加载框和当前控制器的绑定
    objc_setAssociatedObject(currentVC, GC_LoadingKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(currentVC, GC_LoadingCoverKey, nil, OBJC_ASSOCIATION_RETAIN);
}
/// 缩放动画
- (void)scaleAnimationFrom:(NSInteger)from to:(NSInteger)to view:(UIView *)view{
    
    CABasicAnimation *baseAniamtion = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    baseAniamtion.fromValue = @(from);
    baseAniamtion.toValue = @(to);
    baseAniamtion.duration = 0.25;
    baseAniamtion.removedOnCompletion = NO;
    baseAniamtion.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:baseAniamtion forKey:nil];
}

@end
