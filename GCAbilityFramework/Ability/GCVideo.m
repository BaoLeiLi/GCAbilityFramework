//
//  GCVideo.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/8.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCVideo.h"

@implementation GCVideo

+ (instancetype)video{
    
    static GCVideo *video;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        video = [[GCVideo alloc] init];
    });
    return video;
}

- (void)gc_recordVideo:(NSDictionary *)param response:(responseData)response{
    
    
    
    
}

@end
