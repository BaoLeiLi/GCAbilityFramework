//
//  GCImagePicker.m
//  GCAbility
//
//  Created by LBL on 2017/11/20.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCImagePicker.h"
#import "GCHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "GCAbilityStrings.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"

@interface GCImagePicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,copy) resultImage resultImg;
@end

@implementation GCImagePicker

+ (instancetype)shareGCImagePicker{
    
    static GCImagePicker *picker = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[GCImagePicker alloc] init];
    });
    return picker;
}

- (void)imagePickWithType:(UIImagePickerControllerSourceType)type multiSelect:(BOOL)multi picNum:(NSInteger)picNum handler:(resultImage)handler{
    
    _resultImg = handler;
    
    if (type == UIImagePickerControllerSourceTypeCamera) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 用户是否允许摄像头使用
            AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            // 不允许时弹出提示框
            if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
                
                [GCHelper alertTitle:CameraPermissionDeny msg:CameraPermissionDenyDesc];
                
            }else{
                // 摄像头处理逻辑
                [self setupPicker:type];
            }
        } else {
            // 硬件问题提示
            [GCHelper alertTitle:CameraMalfunction msg:CameraMalfunctionDesc];
        }
        
    }else if (type == UIImagePickerControllerSourceTypePhotoLibrary){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 用户是否允许摄像头使用
            AVAuthorizationStatus  authorizationStatus = [ALAssetsLibrary authorizationStatus];
            // 不允许时弹出提示框
            if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
                
                [GCHelper alertTitle:AlbumPermissionDeny msg:AlbumPermissionDenyDesc];
                
            }else{
                // 相册处理逻辑
                if (multi) {
                    
                    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:picNum delegate:self];
                    [[GCHelper getCurrentShowController] presentViewController:picker animated:YES completion:nil];
                }else{
                    
                    [self setupPicker:type];
                }
            }
        } else {
            // 硬件问题提示
            [GCHelper alertTitle:AlbumMalfunction msg:AlbumMalfunctionDesc];
        }
    }
}

- (void)setupPicker:(UIImagePickerControllerSourceType)type{
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [[GCHelper getCurrentShowController] presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭相册\相机
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 往数据数组拼接图片
    UIImage *tempImage = info[UIImagePickerControllerOriginalImage];
    // 压缩图片
    NSData *imageData = [self compressImage:tempImage];
    
    if (_resultImg) {
        
        self.resultImg(@[imageData]);
    }
}
/**
 *  @brief 图片压缩,这里指定压缩到1M以下
 */
- (NSData *)compressImage:(UIImage *)aImage{
    
    NSData *imageData = UIImageJPEGRepresentation(aImage, 0.5);
    
    while (imageData.length > 1024 * 1024) {
        
        UIImage *tempImage = [UIImage imageWithData:imageData];
        
        imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    }
    
    return imageData;
}

//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke{
    
    [picke dismissViewControllerAnimated:YES completion:nil];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    if (_resultImg) {
        
        self.resultImg(photos);
    }
}
/**
 *  @brief 识别图片中的二维码
 */
+ (NSArray *)readQRCodeFromImage:(UIImage *)image{
    // 创建一个CIImage对象
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    // 注意这里的CIDetectorTypeQRCode
    NSArray *features = [detector featuresInImage:ciImage];
    
    return features;
}

@end
