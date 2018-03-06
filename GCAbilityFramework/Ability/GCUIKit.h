//
//  GCUIKit.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCUIKit : NSObject

+ (instancetype)uikit;

/**
 *  @brief 添加UIKit的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 显示加载框
 *  @param param 文字内容 { param:{ showInfo:xx } }
 *  @note 交互项目 param 置nil
 */
- (void)gc_showLoading:(NSDictionary *)param;
/**
 *  @brief 取消加载框
 *  @param originate 是否是源生调用 默认NO
 */
- (void)gc_cancelLoading:(BOOL)originate;

@end
