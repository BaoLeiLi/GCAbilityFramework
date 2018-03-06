//
//  GCNetworking.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/15.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessCallback)(NSURLSessionTask *task , NSDictionary *responseObject);
typedef void(^FailureCallback)(NSURLSessionTask *task , NSError *error);

@interface GCNetworking : NSObject

+ (instancetype)networking;
/// 网络连接状态  YES:有网络    NO:没有网路
@property (nonatomic,assign,readonly) BOOL net_connect_status;


- (void)Get:(NSString *)url parameters:(NSDictionary *)param success:(SuccessCallback)success failure:(FailureCallback)failure;

- (void)Post:(NSString *)url parameters:(NSDictionary *)param success:(SuccessCallback)success failure:(FailureCallback)failure;



/// 网络监测
- (void)networkStatusMonitor;

@end
