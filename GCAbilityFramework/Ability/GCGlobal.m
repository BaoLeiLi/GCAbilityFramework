//
//  GCGlobal.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2017/12/21.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCGlobal.h"

@implementation GCGlobal

+ (instancetype)global{
    
    static GCGlobal *global;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        global = [[GCGlobal alloc] init];
    });
    return global;
}

- (void)configuration:(UIWebView *)webView{
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:nil handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"....");
    }];
}

@end
