//
//  GCDialingView.m
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCDialingView.h"
#import "GCDialingButton.h"

@interface GCDialingView()
@property (nonatomic,copy) NSString *defultNumber;
@property (nonatomic,weak) UILabel *phoneNumber;
@property (nonatomic,weak) GCDialingButton *backButton;
@end

@implementation GCDialingView

- (instancetype)initWithFrame:(CGRect)frame defultPhoneNumber:(NSString *)defultNumber{
    
    self = [super init];
    
    if (self) {
        
        self.frame = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _defultNumber = defultNumber;
        
        self.alpha = 0;
        
    }
    
    return self;
}

- (void)showDialing{
    
    // 229 229 229   数字按键背景色
    // 83  216 105   拨打按键背景色
    // 0   0   0     数字颜色
    NSArray *numbers = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"#"];
    
    UILabel *pNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 80)];
    pNumber.font = [UIFont boldSystemFontOfSize:35];
    pNumber.textAlignment = NSTextAlignmentCenter;
    pNumber.text = _defultNumber;
    self.phoneNumber = pNumber;
    [self addSubview:pNumber];
    
    CGFloat padding = 45;
    CGFloat marginX = 25;
    CGFloat marginY = 15;
    CGFloat buttonWH = (self.frame.size.width - padding*2 - marginX*2)/3;
    CGFloat maxY = 0;
    
    for (int i = 0; i < numbers.count; i++) {
        
        NSInteger row = i/3;
        NSInteger col = i%3;
        
        CGFloat buttonX = padding + col*(buttonWH+marginX);
        CGFloat buttonY = 120 + row * (buttonWH+marginY);
        
        maxY = buttonY + buttonWH;
        
        CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonWH, buttonWH);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        button.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:numbers[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 切圆角
        UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(buttonWH*0.5, buttonWH*0.5)];
        CAShapeLayer *cornerShape = [CAShapeLayer layer];
        cornerShape.frame = button.bounds;
        cornerShape.path = cornerPath.CGPath;
        button.layer.mask = cornerShape;
        
    }
    // 取消
    GCDialingButton *cancelButton = [[GCDialingButton alloc] initWithFrame:CGRectMake(padding + buttonWH*0.5-15, maxY+15 + buttonWH*0.5-15, 30, 30) type:DialingButtonTypeCancel];
    [cancelButton addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    // 退格
    GCDialingButton *backButton = [[GCDialingButton alloc] initWithFrame:CGRectMake(self.frame.size.width-45-30-buttonWH*0.5+15, maxY+15 + buttonWH*0.5-15, 30, 30) type:DialingButtonTypeBack];
    [backButton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backButton;
    [self addSubview:backButton];
    // call
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callButton.frame = CGRectMake(padding + marginX + buttonWH, maxY+marginY, buttonWH, buttonWH);
    callButton.layer.masksToBounds = YES;
    callButton.layer.cornerRadius = buttonWH*0.5;
    callButton.backgroundColor = [UIColor colorWithRed:83/255.0 green:216/255.0 blue:105/255.0 alpha:1];
    [callButton setImage:[UIImage imageNamed:@"icon_phone_white"] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:callButton];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.alpha = 1;
        
    } completion:nil];
}
/**
 *  输入号码
 */
- (void)inputNumber:(UIButton *)button{
    
    NSString *tempStr = self.phoneNumber.text;
    
    self.phoneNumber.text = [NSString stringWithFormat:@"%@%@",tempStr,button.titleLabel.text];
    
    if (self.backButton.hidden) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.backButton.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            self.backButton.hidden = NO;
        }];
    }
}
/**
 *  打电话
 */
- (void)callMethod{
    
    if (self.phoneNumber.text.length > 0) {
        
        NSString *phoneString = [NSString stringWithFormat:@"tel:%@",self.phoneNumber.text];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneString]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
        }
    }
}
/**
 *  退格
 */
- (void)backMethod{
    
    if (self.phoneNumber.text.length > 0) {
        
        NSString *tempStr = self.phoneNumber.text;
        
        self.phoneNumber.text = [tempStr substringToIndex:tempStr.length-1];
        
    }
    
    if (self.phoneNumber.text.length == 0) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.backButton.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.backButton.hidden = YES;
        }];
    }
}
/**
 *  取消，退出拨号界面
 */
- (void)cancelMethod{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
/**
 *  已经加载到父视图
 */
- (void)didMoveToSuperview{
    
    if ([self.defultNumber isEqualToString:@""] || self.defultNumber == nil || self.defultNumber == NULL) {
        self.backButton.alpha = 0;
        self.backButton.hidden = YES;
    }
}

@end
