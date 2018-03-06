//
//  GCScanView.h
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCScanButton:UIButton

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)imageName target:(id)target action:(SEL)action title:(NSString *)title;

@end;

@interface GCScanView : UIView

@end
