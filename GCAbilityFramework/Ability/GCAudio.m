//
//  GCAudio.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCAudio.h"
#import "GCRecordView.h"

@implementation GCAudio

+ (instancetype)audio{
    
    static GCAudio *audio = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        audio = [[GCAudio alloc] init];
    });
    return audio;
}


- (void)gc_startEntireApi{
    
    [self gc_recordAudio:nil response:nil];
}



- (void)gc_recordAudio:(NSDictionary *)param response:(responseData)response{
    
    if (response) {
        
        [[GCRecordView shareRecordView] showWithMinTimeLength:5 keyword:@"ustc" handler:^(NSDictionary *voiceInfo) {
            
            
        }];
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [[GCRecordView shareRecordView] showWithMinTimeLength:5 keyword:@"ustc" handler:^(NSDictionary *voiceInfo) {
                
                
            }];
            
        }];
    }
    
}




#pragma mark - private method



@end
