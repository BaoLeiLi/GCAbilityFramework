//
//  GCGeolocation.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GCHelper.h"


typedef void(^locationResult)(id locationData);

@interface GCGeolocation : NSObject

+ (instancetype)geolocation;

/**
 *  @brief 添加Geolocation的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;

/**
 *  开启定位服务
 *  @param handler 定位成功回调 (返回定位的信息)
 */
- (void)gc_startGCLocation:(locationResult)handler;
/**
 *  @brief 导航
 *  @param param 目的地经纬度
 */
- (void)gc_startNavigation:(NSDictionary *)param response:(responseData)response;

- (void)gc_distanceCalculate:(NSDictionary *)param response:(responseData)response;



@end
