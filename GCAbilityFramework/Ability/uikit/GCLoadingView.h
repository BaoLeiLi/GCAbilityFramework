//
//  GCLoadingView.h
//  GCAbility
//
//  Created by LBL on 2017/11/20.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//
/// 加载框动画视图

#import <UIKit/UIKit.h>

@interface GCLoadingView : NSObject

+ (instancetype)shareGCLoadingView;
/**
 *  开始加载动画
 *  @param aMsg 加载提示语(建议不要太长)
 *  @param cover 是否覆盖当前界面
 */
- (void)startLoadingAnimation:(NSString *)aMsg coverScreen:(BOOL)cover;
/**
 *  移除加载动画
 */
- (void)removeLoadingAnimation;

@end
