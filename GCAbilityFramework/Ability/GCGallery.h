//
//  GCGallery.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCGallery : NSObject

+ (instancetype)gallery;
/**
 *  @brief 添加Gallery的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 图片选择
 *  @param param 所需参数 { param:{ keyword:xxx,picNum:x } },交互时置nil
 *  @param response 回调方法,返回照片信息,js交互时置nil
 */
- (void)gc_pickPicture:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 水印
 *  @param param 所需参数 ,交互时置nil
 *  @param response 回调方法,返回照片信息,js交互时置nil
 */
- (void)gc_watermark:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 截图
 *  @param param ,交互时置nil
 *  @param response 回调方法,返回照片信息,js交互时置nil
 */
- (void)gc_screenshot:(NSDictionary *)param response:(responseData)response;

@end
