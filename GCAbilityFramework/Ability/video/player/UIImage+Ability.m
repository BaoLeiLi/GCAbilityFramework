//
//  UIImage+Ability.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/10.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "UIImage+Ability.h"

@implementation UIImage (Ability)

+ (UIImage *)getImageWithColor:(UIColor *)color size:(CGSize)size type:(ColorImageType)type{
    // 开启上下文
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    // 拿到上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 填充颜色
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    if (type == ColorImageTypeRound) {
        // 椭圆形填充
        CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    }else{
        CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    }
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (instancetype)waterImageWithBg:(UIImage *)bgImage remark:(NSString *)remark{
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    // 绘制背景图片
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // logo图片
    UIImage *logoWaterImage = [UIImage imageNamed:@"icon_ustc_logo_water_remark"];
    // 属性字符串,设置字符串的颜色、大小属性
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:remark attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    // 计算文字的宽度
    CGRect remarkRect = [remark boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    // 间隙
    CGFloat margin = 5;
    // 位置计算
    CGFloat remarkX = bgImage.size.width - remarkRect.size.width - margin;
    CGFloat remarkY = bgImage.size.height - remarkRect.size.height - margin;
    CGFloat logoX = remarkX - 3 - 20;
    CGFloat logoY = remarkY;
    // 绘制文字
    [attributeString drawInRect:CGRectMake(remarkX, remarkY, remarkRect.size.width, 20)];
    // 绘制logo
    [logoWaterImage drawInRect:CGRectMake(logoX, logoY, 20, 20)];
    
    // 从上下文中取得制作完毕的UIImage对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
