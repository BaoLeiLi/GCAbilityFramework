//
//  GCDownUploader.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/18.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDownUploader : NSObject

+ (instancetype)downuploader;

- (void)gc_startEntireApi;

- (void)gc_downloader:(NSDictionary *)param response:(responseData)response;

- (void)gc_uploader:(NSDictionary *)param response:(responseData)response;

@end
