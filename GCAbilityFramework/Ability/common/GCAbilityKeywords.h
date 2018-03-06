//
//  GCAbilityKeywords.h
//  GCAbility
//
//  Created by LBL on 2017/11/17.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  相机
 */
extern NSString *const TakePhoto;
/**
 *  相册
 */
extern NSString *const PickPic;
/**
 *  扫码
 */
extern NSString *const ScanGetCode;
/**
 *  打电话
 */
extern NSString *const TelephoneCall;
/**
 *  加载动画
 */
extern NSString *const ShowLoading;
/**
 *  取消加载动画
 */
extern NSString *const CancelLoading;
/**
 *  获取定位信息
 */
extern NSString *const GetLocationInfo;
/**
 *  返回
 */
extern NSString *const Back;
/**
 *  @brief 短信
 */
extern NSString *const ShortMessage;
/**
 *  @brief 插入数据
 */
extern NSString *const InsertInfo;
/**
 *  @brief 创建表
 */
extern NSString *const CreateTableInfo;




/**
 *  高德地图的APIKey
 */
extern NSString *const AMapAPIKey;

@interface GCAbilityKeywords : NSObject

@end
