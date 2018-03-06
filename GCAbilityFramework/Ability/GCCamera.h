//
//  GCCamera.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCCamera : NSObject

+ (instancetype)camera;
/**
 *  @brief 添加Camera的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 拍照
 *  @param param 所需参数 { param:{ keyword:xxx } },交互时置nil
 *  @param response 回调方法,返回照片信息,js交互时置nil
 */
- (void)gc_takePhoto:(NSDictionary *)param response:(responseData)response;

@end
