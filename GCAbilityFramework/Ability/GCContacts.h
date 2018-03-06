//
//  GCContacts.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCContacts : NSObject

+ (instancetype)contacts;
/**
 *  @brief 添加Contacts的所有api
 *  @attention 此方法仅对交互有效
 */
- (void)gc_startEntireApi;
/**
 *  @brief 拨打电话
 *  @param param 所需参数  { param:{ telNum:xxxx,flag:x } }
 *  @attention 源生调用 param 必不为空；Javascript交互时置空即可
 */
- (void)gc_telephoneCall:(NSDictionary *)param;
/**
 *  @brief 获取联系人信息
 *  @attention 源生调用 response 必不为空；Javascript交互时置空即可
 */
- (void)gc_getContact:(responseData)response;
/**
 *  @brief 添加联系人
 *  @param param 所需参数  { param:{ telNum:xxxx,flag:x } }
 *  @attention 源生调用 param 必不为空；Javascript交互时置空即可
 */
- (void)gc_newContact:(NSDictionary *)param response:(responseData)response;
/**
 *  @brief 修改联系人
 *  @param param 所需参数  { param:{ telNum:xxxx,flag:x } }
 *  @attention 源生调用 param 必不为空；Javascript交互时置空即可
 */
- (void)gc_editContact:(NSDictionary *)param response:(responseData)response;

@end
