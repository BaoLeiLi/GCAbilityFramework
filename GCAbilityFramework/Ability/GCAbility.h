//
//  GCAbility.h
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WebViewJavascriptBridge;


@interface GCAbility : NSObject
/**
 *  @brief 单例
 */
+ (instancetype)abilityInstnace;
/**
 *  @brief 启动
 *  @param webView 加载html的webView
 *
 *  @note 此方法仅对Web有效
 */
- (void)startEngine:(UIWebView *)webView;


@end
