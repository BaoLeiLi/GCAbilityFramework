//
//  GCScanView.m
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCScanView.h"

@implementation GCScanButton

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)imageName target:(id)target action:(SEL)action title:(NSString *)title{
    
    GCScanButton *button = [GCScanButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-25);
}

@end

@implementation GCScanView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 150, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100) cornerRadius:1] bezierPathByReversingPath]];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    
    CGRect drawRect = CGRectMake(50, 150, rect.size.width-100, rect.size.width-100);
    
    [[UIColor whiteColor] setStroke];
    
    CGContextSetLineWidth(ctxRef, 5);
    
    CGContextAddRect(ctxRef, drawRect);
    
    CGContextStrokePath(ctxRef);
}

@end
