//
//  GCBarcode.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCBarcode : NSObject

+ (instancetype)barcode;
/**
 *  @brief 添加barcode的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 二维码、条形码 扫描
 *  @param response 回调方法,返回扫描信息
 *  @attention 交互时response置 nil
 */
- (void)gc_scanGetCode:(responseData)response;

@end
