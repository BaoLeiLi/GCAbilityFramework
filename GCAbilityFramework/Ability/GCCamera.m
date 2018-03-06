//
//  GCCamera.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCCamera.h"
#import "GCImagePicker.h"

@implementation GCCamera

+ (instancetype)camera{
    
    static GCCamera *camera = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        camera = [[GCCamera alloc] init];
    });
    return camera;
}

- (void)gc_startEntireApi{
    
    [self gc_takePhoto:nil response:nil];
}

- (void)gc_takePhoto:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        [self takePhoto:param response:^(NSDictionary *result) {
            
            if (response) {
                
                response(result);
            }
        }];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:TakePhoto handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [self takePhoto:(NSDictionary *)data response:^(NSDictionary *result) {
                
                responseCallback(result);
            }];
        }];
    }
}

- (void)takePhoto:(NSDictionary *)param response:(responseData)response{
    
    NSDictionary *dic = [GCHelper jsonDictionary:param];
    NSString *keywords = dic[@"keyword"];
    
    [[GCImagePicker shareGCImagePicker] imagePickWithType:UIImagePickerControllerSourceTypeCamera multiSelect:NO picNum:0 handler:^(NSArray *imageArray) {
        
        NSString *imagePath = [GCHelper saveImage:[imageArray firstObject] WithName:keywords flag:1];
        
        NSArray *nameArr = [imagePath componentsSeparatedByString:@"/"];
        NSString *imageName = [nameArr lastObject];
        NSLog(@"imagePath : %@  \n  imageName : %@",imagePath,imageName);
        
        NSDictionary *returnDict = @{@"data":@{@"photoPath":imagePath,@"photoName":imageName}};
        
        if(response){
            response(returnDict);
        }
    }];
}

@end
