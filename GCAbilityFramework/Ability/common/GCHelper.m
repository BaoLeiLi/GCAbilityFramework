//
//  GCHelper.m
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SSKeychain.h"

@implementation GCHelper

+ (UIViewController *)getCurrentShowController{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [GCHelper getCurrentVCFrom:rootViewController];
    
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

+ (NSString *)saveImage:(NSData *)imageData WithName:(NSString *)imageName flag:(NSInteger)flag{
    NSString *newName = @"";
    if(imageName == nil || [imageName isEqualToString:@""] || imageName == NULL){
        newName = [NSString stringWithFormat:@"USTC_%@.jpg",[GCHelper getDateWithFlag:flag]];
    }else{
        newName = [NSString stringWithFormat:@"%@_%@.jpg",imageName,[GCHelper getDateWithFlag:flag]];
    }
    
    NSString* paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *imagesFolder = [paths stringByAppendingPathComponent:@"abilityImages"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesFolder]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 全路径
    NSString* fullPathToFile = [imagesFolder stringByAppendingPathComponent:newName];
    // 写入文件
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    return fullPathToFile;
}
/**
 *  @brief 根据当前时间和标识生成字符串
 */
+ (NSString *)getDateWithFlag:(NSInteger)flag{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@%ld",dateStr,flag];
}


+ (NSDictionary *)getWifiInfo{
    
    CFArrayRef myArray =CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            return dict;
            
        }else{
            
            return nil;
        }
    }else{
        
        return nil;
    }
}

+ (NSString *)getUUID{
    
    NSString *strUUID = [SSKeychain passwordForService:KeyChainService account:KeyChainAccount];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        [SSKeychain setPassword:strUUID forService:KeyChainService account:KeyChainAccount];
        
    }
    return strUUID;
    
}


+ (void)alertTitle:(NSString *)title msg:(NSString *)msg{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:action];
    [[GCHelper getCurrentShowController] presentViewController:alertC animated:YES completion:nil];
}

+ (NSDictionary *)jsonDictionary:(id)data{
    
    NSString *params = data[@"params"];
    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

+(NSString*)JSONString:(id)data
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return [[NSString alloc] initWithData:result
                                 encoding:NSUTF8StringEncoding];
}

@end
