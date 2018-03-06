//
//  GCAudio.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAudio : NSObject

+ (instancetype)audio;
/**
 *  @brief 添加Audio的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 录音
 */
- (void)gc_recordAudio:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 播音
 */
- (void)gc_playAudio:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 格式转换
 */
- (void)gc_audioTransform:(NSDictionary *)param response:(responseData)response;

@end
