//
//  GCBarcode.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCBarcode.h"
#import "GCScanQRViewController.h"

@implementation GCBarcode

+ (instancetype)barcode{
    
    static GCBarcode *barcode = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        barcode = [[GCBarcode alloc] init];
    });
    
    return barcode;
}

- (void)gc_startEntireApi{
    
    [self gc_scanGetCode:nil];
}

- (void)gc_scanGetCode:(responseData)response{
    
    if (response) {
        
        [self scanGetCode:^(NSDictionary *result) {
            
            if (response) {
                
                response(result);
            }
        }];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:ScanGetCode handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSLog(@"bridge : %@ \n",[GCGlobal global].bridge);
            NSLog(@">>>>>> 3.scanGetCode <<<<<<<<");
            
            [self scanGetCode:^(NSDictionary *result) {
                
                responseCallback(result);
            }];
            
        }];
    }
}

- (void)scanGetCode:(responseData)response{
    
    GCScanQRViewController *qrVC = [[GCScanQRViewController alloc] init];
    
    qrVC.scanResultHandler = ^(NSString *result) {
        
        NSLog(@"scanRecult : %@",result);
        
        NSDictionary *objDict = @{@"data":result};
        
        if (response) {
            
            response(objDict);
        }
    };
    
    [[GCHelper getCurrentShowController] presentViewController:qrVC animated:YES completion:nil];
}

@end
