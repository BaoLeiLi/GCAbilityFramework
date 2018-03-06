//
//  GCPlayerView.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/10.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPlayerView : UIView
/**
 *  @brief 单例
 */
+ (instancetype)playerView;
/**
 *  @brief 显示视频播放视图
 */
- (void)showPlayerView;
/**
 *  @brief 播放视频
 *  @param url 本地或者网络
 */
- (void)playWith:(NSURL *)url;
/**
 *  @brief 暂停播放
 */
- (void)pause;

@end
