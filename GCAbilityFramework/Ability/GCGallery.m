//
//  GCGallery.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCGallery.h"
#import "GCImagePicker.h"
#import "UIImage+Ability.h"
#import "UIImageView+WebCache.h"

@implementation GCGallery

+ (instancetype)gallery{
    
    static GCGallery *gallery = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        gallery = [[GCGallery alloc] init];
    });
    return gallery;
}

- (void)gc_startEntireApi{
    
    [self gc_pickPicture:nil response:nil];
    [self gc_watermark:nil response:nil];
    [self gc_screenshot:nil response:nil];
}

- (void)gc_pickPicture:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        [self pickPicture:param response:^(NSDictionary *result) {
            
            if (response) {
                response(result);
            }
        }];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:PickPic handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [self pickPicture:data response:^(NSDictionary *result) {
                
                responseCallback(result);
            }];
        }];
    }
}

- (void)gc_watermark:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        
        
    }else{
#warning handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithURL:@"" completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                UIImage *tmpImage = [UIImage imageWithData:data];
                UIImage *waterImage = [UIImage waterImageWithBg:tmpImage remark:@"test"];
                responseCallback(@{@"data":waterImage});
            }];
            [dataTask resume];
        }];
    }
}

- (void)gc_screenshot:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        [self screenshot:param response:response callback:nil];
        
    }else{
#warning handler 方法名
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [self screenshot:param response:nil callback:responseCallback];
            
        }];
    }
}


#pragma mark - private method

- (void)pickPicture:(NSDictionary *)param response:(responseData)response{
    
    NSDictionary *dict = [GCHelper jsonDictionary:param];
    
    NSString * _photoName = ((dict[@"keyword"])?dict[@"keyword"]:@"USTC");
    NSUInteger _picNum = [dict[@"picNum"] integerValue];
    
    [[GCImagePicker shareGCImagePicker] imagePickWithType:UIImagePickerControllerSourceTypePhotoLibrary multiSelect:YES picNum:_picNum handler:^(NSArray *imageArray) {
        
        NSMutableArray *imagePaths = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *aImage = imageArray[i];
            NSData *imageData = UIImageJPEGRepresentation(aImage, 1);
            NSString *imageFullPath = [GCHelper saveImage:imageData WithName:_photoName flag:i];
            NSArray *nameArr = [imageFullPath componentsSeparatedByString:@"/"];
            NSString *imageName = [nameArr lastObject];
            NSDictionary *pathDic = @{@"photoPath":imageFullPath,@"photoName":imageName};
            [imagePaths addObject:pathDic];
        }
        NSDictionary *resultDic = @{@"data":imagePaths};
        // JS回调和原生回调
        if(response){
            response(resultDic);
        }
    }];
}

- (void)screenshot:(NSDictionary *)param response:(responseData)response callback:(WVJBResponseCallback)callback{
#warning 参数 param 处理
    // 获取当前控制器
    UIViewController *currentVC = [GCHelper getCurrentShowController];
    // 创建图片上下文
    UIGraphicsBeginImageContext(currentVC.view.bounds.size);
    // 将我们的涂层渲染到上下文中
    [currentVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 从上下文中拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片的上下文
    UIGraphicsEndImageContext();
    
    // 图片存储
    NSString *imageFullPath = [GCHelper saveImage:UIImageJPEGRepresentation(image, 0.5) WithName:nil flag:1];
    // 图片路径处理
    NSMutableArray *imagePaths = [NSMutableArray array];
    NSArray *nameArr = [imageFullPath componentsSeparatedByString:@"/"];
    NSString *imageName = [nameArr lastObject];
    NSDictionary *pathDic = @{@"photoPath":imageFullPath,@"photoName":imageName};
    [imagePaths addObject:pathDic];
    NSDictionary *resultDic = @{@"data":imagePaths};
    
    if (response) {
        response(resultDic);
    }else{
        callback(resultDic);
    }
}

@end
