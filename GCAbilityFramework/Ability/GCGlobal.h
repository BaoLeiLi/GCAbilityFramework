//
//  GCGlobal.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2017/12/21.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridge.h"

typedef void(^responseData)(NSDictionary *result);

static inline UIColor * _color(NSInteger r,NSInteger b,NSInteger g,CGFloat a){
    return [UIColor colorWithRed:r/255.0 green:b/255.0 blue:g/255.0 alpha:a];
}

static inline CGFloat _width(){
    return [UIScreen mainScreen].bounds.size.width;
}
static inline CGFloat _height(){
    return [UIScreen mainScreen].bounds.size.height;
}

@interface GCGlobal : NSObject

+ (instancetype)global;

- (void)configuration:(UIWebView *)webView;

@property (nonatomic,strong,readonly) WebViewJavascriptBridge *bridge;



@end
