//
//  GCHelper.h
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GCHelper : NSObject

/**
 *  @brief 获取当前正在显示的控制器
 */
+ (UIViewController *)getCurrentShowController;
/**
 *  @brief 存储图片到沙盒路径并返回图片的路径
 *  @param imageData 图片数据
 *  @param imageName 图片名称
 *  @param flag 序号
 *  @return 图片的实际路径
 */
+ (NSString *)saveImage:(NSData *)imageData WithName:(NSString *)imageName flag:(NSInteger)flag;


/**
 *  @brief 获取Wifi相关信息
 *
 *  @note SSID wifi的名称； BSSID 路由器的MAC地址
 */
+ (NSDictionary *)getWifiInfo;
/**
 *  @brief 获取设备的UUID
 *
 *  @note 先从KeyChain中查询有没有UUID，没有就获取UUID后存储到KeyChain中
 */
+ (NSString *)getUUID;

/**
 *  @brief 根据当前时间和标识生成字符串
 */
+ (NSString *)getDateWithFlag:(NSInteger)flag;
/**
 *  @brief 提示框
 */
+ (void)alertTitle:(NSString *)title msg:(NSString *)msg;
/**
 *  @brief json格式的数据转换成字典
 */
+ (NSDictionary *)jsonDictionary:(id)data;

+(NSString*)JSONString:(id)data;

@end
