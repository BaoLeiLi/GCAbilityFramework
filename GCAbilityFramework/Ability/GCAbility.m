//
//  GCAbility.m
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCAbility.h"
#import "WebViewJavascriptBridge.h"
#import "GCNetworking.h"
#import <objc/message.h>



@interface GCAbility()


@end

@implementation GCAbility

+ (instancetype)abilityInstnace{
    
    static GCAbility *able = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        able = [[GCAbility alloc] init];
    });
    return able;
}

/// 启动能力封装
- (void)startEngine:(UIWebView *)webView{
    
    [[GCGlobal global] configuration:webView];
    
    [[GCBarcode barcode] gc_startEntireApi];
    [[GCCamera camera] gc_startEntireApi];
    [[GCGallery gallery] gc_startEntireApi];
    [[GCDatabase database] gc_startEntireApi];
    [[GCGeolocation geolocation] gc_startEntireApi];
    [[GCAudio audio] gc_startEntireApi];
    [[GCContacts contacts] gc_startEntireApi];
    [[GCMessaging message] gc_startEntireApi];
    
//    NSString *configJsonPath = [__document_path stringByAppendingPathComponent:__config_path];
//    NSString *srcVersionJsonPath = [__document_path stringByAppendingPathComponent:__version_path];
//    // 导入模块和API
//    [self engineModule:configJsonPath];
//    // 更新检测
//    [self updateCheck:srcVersionJsonPath];
    
}

- (void)engineModule:(NSString *)path{
    
    NSData *configData = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:&error];
    
    if (!error) {
        
        if (config) {
            
            NSArray *moduleArray = config[@"configuration"];
            
            for (NSDictionary *module in moduleArray) {
                
                BOOL available = [module[@"available"] boolValue];
                
                if (available) {
                    
                    NSString *tmp = module[@"moduleName"];
                    
                    NSString *lower = [tmp lowercaseString];
                    
                    NSString *moduleName = [NSString stringWithFormat:@"GC%@",tmp];
                    
                    _log(@">>>>>>> insert moduleName : %@",moduleName);
                    
                    Class moduleClass = NSClassFromString(moduleName);
                    
                    SEL singleton = NSSelectorFromString(lower);
                    
                    id target = ((id(*)(id,SEL))objc_msgSend)(moduleClass,singleton);
                    
                    SEL startMethod = NSSelectorFromString(@"gc_startEntireApi");
                    
                    ((void(*)(id,SEL))objc_msgSend)(target,startMethod);
                }
            }
        }
    }
}

- (void)updateCheck:(NSString *)path{
    
    // 资源包更新
    [self srcUpdate:path];
    
    // 框架更新
    [self frameUpadte];
    
}
- (void)srcUpdate:(NSString *)path{
    
    dispatch_async(dispatch_async_update_queue(), ^{
        
        // 本地资源包版本
        NSData *tmpData = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *localSrcJson = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            NSDictionary *versionInfo = localSrcJson[@"version"];
            NSString *localSrcVersion = versionInfo[@"version"];
            NSArray *localSrcVersionArray = [localSrcVersion componentsSeparatedByString:@"."];
            __unused NSInteger localSrcVersion_first = [[localSrcVersionArray firstObject] integerValue];
            __unused NSInteger localSrcVersion_middle = [localSrcVersionArray[1] integerValue];
            __unused NSInteger localSrcVersion_last = [[localSrcVersionArray lastObject] integerValue];
            _log(@">>>>>>> localSrcVersion : %@",localSrcVersion);
        }
        
    });
    
}

- (void)frameUpadte{
    
    dispatch_async(dispatch_async_update_queue(), ^{
        
        // 本地框架版本
        NSString *localFrameVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSArray *localFrameVersionArray = [localFrameVersion componentsSeparatedByString:@"."];
        __unused NSInteger localFrameVersion_first = [[localFrameVersionArray firstObject] integerValue];
        __unused NSInteger localFrameVersion_middle = [localFrameVersionArray[1] integerValue];
        __unused NSInteger localFrameVersion_last = [[localFrameVersionArray lastObject] integerValue];
        _log(@">>>>>>> localFrameVersion : %@",localFrameVersion);
    });
}

dispatch_queue_t dispatch_async_update_queue(){
    
    static dispatch_queue_t queue;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        queue = dispatch_queue_create("com.ustcinfo.mobileFrame.update", NULL);
    });
    return queue;
}

@end
