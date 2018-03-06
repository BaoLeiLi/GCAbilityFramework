//
//  GCUIKit.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCUIKit.h"
#import "GCLoadingView.h"

@implementation GCUIKit

+ (instancetype)uikit{
    
    static GCUIKit *uikit = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        uikit = [[GCUIKit alloc] init];
    });
    return uikit;
}

- (void)gc_startEntireApi{
    
    [self gc_showLoading:nil];
    [self gc_cancelLoading:NO];
}

- (void)gc_showLoading:(NSDictionary *)param{
    
    if (param) {
        
        // 获取关键字
        NSDictionary *dic = [GCHelper jsonDictionary:param];
        
        NSString *showInfo = dic[@"showInfo"];
        
        [[GCLoadingView shareGCLoadingView] startLoadingAnimation:showInfo coverScreen:YES];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:ShowLoading handler:^(id data, WVJBResponseCallback responseCallback) {
            
            // 获取关键字
            NSDictionary *dic = [GCHelper jsonDictionary:data];
            
            NSString *showInfo = dic[@"showInfo"];
            
            [[GCLoadingView shareGCLoadingView] startLoadingAnimation:showInfo coverScreen:YES];
            
        }];
    }
}

- (void)gc_cancelLoading:(BOOL)originate{
    
    if (originate) {
        
        [[GCLoadingView shareGCLoadingView] removeLoadingAnimation];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:CancelLoading handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [[GCLoadingView shareGCLoadingView] removeLoadingAnimation];
            
        }];
    }
}

@end
