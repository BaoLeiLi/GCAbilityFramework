//
//  GraintCircleLayer.h
//  LeranWL
//
//  Created by 李保磊 on 17/4/7.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface GraintCircleLayer : CALayer

-(instancetype)initGraintCircleWithBounds:(CGRect)bounds
                                 Position:(CGPoint)position
                                FromColor:(UIColor *)fromColor
                                  ToColor:(UIColor *)toColor
                                LineWidth:(CGFloat) linewidth;
+(instancetype)layerWithWithBounds:(CGRect)bounds
                          Position:(CGPoint)position
                         FromColor:(UIColor *)fromColor
                           ToColor:(UIColor *)toColor
                         LineWidth:(CGFloat) linewidth;

@end
