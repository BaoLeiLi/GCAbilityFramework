//
//  GCImagePicker.h
//  GCAbility
//
//  Created by LBL on 2017/11/20.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//
/// 图片选择

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^resultImage)(NSArray *imageArray);
@interface GCImagePicker : NSObject
+ (instancetype)shareGCImagePicker;
/**
 *  创建图片选择控制器
 *  @param type 类型：相机、相册
 *  @param multi 是否是多张图片选择(相册类型)
 *  @param picNum 选择图片张数(multi=YES)
 *  @param handler 操作结束回调
 */
- (void)imagePickWithType:(UIImagePickerControllerSourceType)type multiSelect:(BOOL)multi picNum:(NSInteger)picNum handler:(resultImage)handler;
/**
 *  读取图片中的二维码
 *  @param image 图片
 *  @return 图片中的二维码数据集合 CIQRCodeFeature对象
 */
+ (NSArray *)readQRCodeFromImage:(UIImage *)image;

@end
