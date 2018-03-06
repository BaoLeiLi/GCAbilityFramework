//
//  GCNetworking.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/15.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCNetworking.h"
#import "AFNetworking.h"

@interface GCNetworking()
{
    AFHTTPSessionManager *_manager;
}

@end

@implementation GCNetworking

+ (instancetype)networking{
    
    static GCNetworking *net ;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        net = [[GCNetworking alloc] init];
    });
    return net;
}

- (instancetype)init{
    
    if ([super init]) {
        
        _manager = [AFHTTPSessionManager manager];
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _net_connect_status = YES;
    }
    return self;
}

- (void)Get:(NSString *)url parameters:(NSDictionary *)param success:(SuccessCallback)success failure:(FailureCallback)failure{
    
    [_manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        
        NSDictionary *tmpDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        if (!error) {
            
            success(task,tmpDict);
            
        }else{
            
            failure(task,error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,error);
    }];
}

- (void)Post:(NSString *)url parameters:(NSDictionary *)param success:(SuccessCallback)success failure:(FailureCallback)failure{
    
    [_manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        
        NSDictionary *tmpDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        if (!error) {
            
            success(task,tmpDict);
            
        }else{
            
            failure(task,error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}


- (void)networkStatusMonitor{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
            default:
                break;
        }
    }];
}

@end
