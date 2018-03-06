//
//  GCZip.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/13.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCZip : NSObject

+ (instancetype)zip;

- (void)gc_startEntireApi;
/**
 *  @brief 解压
 *  @param param 解压参数
 *  @param response 回调
 *  @attention 交互时 param 和 response 置空
 */
- (void)gc_unzip:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 压缩
 *  @param param 压缩参数
 *  @param response 回调
 *  @attention 交互时 param 和 response 置空
 */
- (void)gc_zip:(NSDictionary *)param response:(responseData)response;

@end
