//
//  GCMessaging.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCMessaging : NSObject

+ (instancetype)message;
/**
 *  @brief 添加Messaging的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 发送短信
 *  @param param 短信参数
 *  @attention 如果交互调用，把 'param' 置空
 *  @param response 回调方法
 */
- (void)gc_shortMessage:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 发送邮件
 *  @param param 邮件参数
 *  @param response 回调方法
 */
- (void)gc_sendEmail:(NSDictionary *)param response:(responseData)response;

@end
