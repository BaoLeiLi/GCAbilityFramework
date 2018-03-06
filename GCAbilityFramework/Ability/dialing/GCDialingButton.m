//
//  GCDialingButton.m
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCDialingButton.h"

@interface GCDialingButton()

@property (nonatomic,assign) DialingButtonType dbType;

@end

@implementation GCDialingButton

- (instancetype)initWithFrame:(CGRect)frame type:(DialingButtonType)type{
    
    self = [super init];
    
    if (self) {
        
        self.frame = frame;
        
        self.dbType = type;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    
    if (self.dbType == DialingButtonTypeBack) {
        
        // 直线
        CGContextMoveToPoint(ctxRef, rect.size.width/3, rect.size.height-5);
        CGContextAddLineToPoint(ctxRef, 0, centerY);
        CGContextAddLineToPoint(ctxRef, rect.size.width/3, 5);
        // 圆角
        CGContextAddArcToPoint(ctxRef, rect.size.width/3, 5, rect.size.width, 5, 2);
        CGContextAddArcToPoint(ctxRef, rect.size.width, 5, rect.size.width, rect.size.height-5, 3);
        CGContextAddArcToPoint(ctxRef, rect.size.width, rect.size.height-5, rect.size.width/3, rect.size.height-5, 3);
        CGContextAddArcToPoint(ctxRef, rect.size.width/3, rect.size.height-5, 0, centerY, 2);
        
        [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1] set];
        
        CGContextFillPath(ctxRef);
        
        CGContextRef aCtx = UIGraphicsGetCurrentContext();
        // 属性设置
        CGContextSetLineJoin(aCtx, kCGLineJoinRound);
        CGContextSetLineCap(aCtx, kCGLineCapRound);
        CGContextSetLineWidth(aCtx, 2);
        [[UIColor blackColor] setStroke];
        // 计算四个点的位置
        CGFloat x = sqrt(0.07*pow(rect.size.width*0.6, 2));
        CGFloat firstY = rect.size.height * 0.5 - x;
        CGFloat firstX = rect.size.height/3 + firstY-5;
        CGFloat secondY = firstY;
        CGFloat secondX = rect.size.width - firstY + 5;
        CGFloat thirdY = rect.size.height- firstY;
        CGFloat thirdX = secondX;
        CGFloat forthY = thirdY;
        CGFloat forthX = firstX;
        // 画线
        CGContextMoveToPoint(aCtx, firstX, firstY);
        CGContextAddLineToPoint(aCtx, thirdX, thirdY);
        CGContextMoveToPoint(aCtx, secondX, secondY);
        CGContextAddLineToPoint(aCtx, forthX, forthY);
        
        CGContextStrokePath(aCtx);
        
    }else if (self.dbType == DialingButtonTypeCancel){
        
        CGContextAddArc(ctxRef, centerX, centerY, rect.size.width*0.5, 0, M_PI*2, 0);
        [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1] set];
        CGContextFillPath(ctxRef);
        
        CGContextRef tempRef = UIGraphicsGetCurrentContext();
        
        CGFloat firstY = rect.size.height*0.5 - sqrt(0.04)*rect.size.width;
        CGFloat firstX = firstY;
        CGFloat secondY = firstY;
        CGFloat secondX = rect.size.width - firstY;
        CGFloat thirdY = rect.size.height- firstY;
        CGFloat thirdX = secondX;
        CGFloat forthY = thirdY;
        CGFloat forthX = firstX;
        
        CGContextMoveToPoint(tempRef, firstX, firstY);
        CGContextAddLineToPoint(tempRef, thirdX, thirdY);
        CGContextMoveToPoint(tempRef, secondX, secondY);
        CGContextAddLineToPoint(tempRef, forthX, forthY);
        
        CGContextSetLineJoin(tempRef, kCGLineJoinRound);
        CGContextSetLineCap(tempRef, kCGLineCapRound);
        CGContextSetLineWidth(tempRef, 2);
        [[UIColor blackColor] setStroke];
        
        CGContextStrokePath(tempRef);
    }
}

@end
