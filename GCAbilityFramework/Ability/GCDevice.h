//
//  GCDevice.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GCDevice : NSObject

+ (instancetype)device;
/**
 *  @brief 添加Device的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 获取设备类型
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getDeviceType:(responseData)response;
/**
 *  @brief 获取设备系统
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getDeviceSystemVersion:(responseData)response;
/**
 *  @brief 获取网络类型
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getNetworkType:(responseData)response;
/**
 *  @brief 获取wifi信息
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getWifiInfo:(responseData)response;
/**
 *  @brief 获取设备唯一标识
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getDeviceUDID:(responseData)response;
/**
 *  @brief 获取SIM卡信息
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getSimInfo:(responseData)response;
/**
 *  @brief 获取软件包名
 *  @param response 回传数据     交互时请置nil
 */
- (void)gc_getBundleIdentifier:(responseData)response;

- (void)gc_closeScreen:(responseData)response;

@end
