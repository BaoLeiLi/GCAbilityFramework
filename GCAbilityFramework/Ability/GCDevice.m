//
//  GCDevice.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCDevice.h"
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SSKeychain.h"


@implementation GCDevice

+ (instancetype)device{
    
    static GCDevice *device = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        device = [[GCDevice alloc] init];
    });
    return device;
}

- (void)gc_startEntireApi{
    
    [self gc_getDeviceType:nil];
    [self gc_getDeviceSystemVersion:nil];
    [self gc_getNetworkType:nil];
    [self gc_getWifiInfo:nil];
    [self gc_getDeviceUDID:nil];
    [self gc_getSimInfo:nil];
    [self gc_getBundleIdentifier:nil];
}

- (void)gc_getDeviceType:(responseData)response{
    
    if (response) {
        
        NSString *type = [self getDeviceType];
        
        NSDictionary *param = @{@"data":type};
        
        response(param);
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *type = [self getDeviceType];
            
            NSDictionary *param = @{@"data":type};
            
            responseCallback(param);
            
        }];
    }
}

- (void)gc_getDeviceSystemVersion:(responseData)response{
    
    if (response) {
        
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        
        NSDictionary *param = @{@"data":phoneVersion};
        
        response(param);
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
            
            NSDictionary *param = @{@"data":phoneVersion};
            
            responseCallback(param);
            
        }];
    }
}

- (void)gc_getNetworkType:(responseData)response{
    
    if (response) {
        
        NSString *type = [self getNetworkType];
        
        NSDictionary *param = @{@"data":type};
        
        response(param);
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *type = [self getNetworkType];
            
            NSDictionary *param = @{@"data":type};
            
            responseCallback(param);
        }];
    }
}

- (void)gc_getWifiInfo:(responseData)response{
    
    if (response) {
        
        NSDictionary *info = [self getWifiInfo];
        
        NSDictionary *param = @{@"data":info};
        
        response(param);
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSDictionary *info = [self getWifiInfo];
            
            NSDictionary *param = @{@"data":info};
            
            responseCallback(param);
        }];
    }
}

- (void)gc_getSimInfo:(responseData)response{
    
    if (response) {
        
        NSDictionary *info = [self getSimInfo];
        
        NSDictionary *param = @{@"data":info};
        
        response(param);
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSDictionary *info = [self getSimInfo];
            
            NSDictionary *param = @{@"data":info};
            
            responseCallback(param);
        }];
    }
}

- (void)gc_getBundleIdentifier:(responseData)response{
    
    if (response) {
        
        NSString *info = [self getBundleIdentifier];
        
        NSDictionary *param = @{@"data":info};
        
        response(param);
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *info = [self getBundleIdentifier];
            
            NSDictionary *param = @{@"data":info};
            
            responseCallback(param);
            
        }];
    }
}

- (void)gc_getDeviceUDID:(responseData)response{
    
    if (response) {
        
        NSString *udid = [self getUDID];
        
        NSDictionary *param = @{@"data":udid};
        
        response(param);
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSString *info = [self getBundleIdentifier];
            
            NSDictionary *param = @{@"data":info};
            
            responseCallback(param);
        }];
        
    }
}

- (void)gc_closeScreen:(responseData)response{
    
    if (response) {
        
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            // 禁止自动锁屏
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            // 启用自动锁屏
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            
        }];
    }
}


#pragma mark - private method

- (NSString*)getDeviceType{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return  @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

- (NSString *)getNetworkType{
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *networkType = nil;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            networkType = @"无服务";
            break;
            
        case 1:
            networkType = @"2G";
            break;
            
        case 2:
            networkType = @"3G";
            break;
            
        case 3:
            networkType = @"4G";
            break;
            
        case 4:
            networkType = @"LTE";
            break;
            
        case 5:
            networkType = @"Wifi";
            break;
            
        default:
            break;
    }
    return networkType;
}

- (NSDictionary *)getWifiInfo{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [ifs count]) {
            
            break;
        }
    }
    return (NSDictionary *)info;
}

- (NSDictionary *)getSimInfo{
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    
    [info setValue:carrier.carrierName forKey:@"carrierName"];
    [info setValue:carrier.mobileCountryCode forKey:@"mobileCountryCode"];
    [info setValue:carrier.mobileNetworkCode forKey:@"mobileNetworkCode"];
    [info setValue:carrier.isoCountryCode forKey:@"isoCountryCode"];
    NSString *voip = carrier.allowsVOIP ? @"YES":@"NO";
    [info setValue:voip forKey:@"allowsVOIP"];
    
    return info;
}

- (NSString *)getBundleIdentifier{
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    NSString *identifier = info[@"CFBundleIdentifier"];
    
    return identifier;
    
}

- (NSString *)getUDID{
    
    NSString *udid = [SSKeychain passwordForService:KeyChainService account:KeyChainAccount];
    
    if (udid) {
        
        return udid;
        
    }else{
        
        NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
        
        [SSKeychain setPassword:uuid.UUIDString forService:KeyChainService account:KeyChainAccount];
        
        return uuid.UUIDString;
        
    }
}



@end
