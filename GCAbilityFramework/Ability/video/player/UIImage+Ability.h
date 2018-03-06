//
//  UIImage+Ability.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/10.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ColorImageType){
    
    ColorImageTypeRound = 0,
    ColorImageTypeRect
};

@interface UIImage (Ability)

// 根据颜色来生成图片
+ (UIImage *)getImageWithColor:(UIColor *)color size:(CGSize)size type:(ColorImageType)type;
/**
 *  水印
 *
 *  @param bgImage   背景图片
 *  @param remark 文字
 */
+ (instancetype)waterImageWithBg:(UIImage *)bgImage remark:(NSString *)remark;

@end
