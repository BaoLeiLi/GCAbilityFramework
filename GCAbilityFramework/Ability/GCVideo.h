//
//  GCVideo.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/8.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCVideo : NSObject

+ (instancetype)video;
/**
 *  @brief 加载本模块所有的Api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 视频录制
 *
 *  @param param 交互置空
 *  @param response 视频路径，交互置空-nil
 */
- (void)gc_recordVideo:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 视频播放
 *
 *  @param param 交互置空
 *  @param response 交互置空-nil
 */
- (void)gc_videoPlayer:(NSDictionary *)param response:(responseData)response;

@end
