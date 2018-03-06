//
//  GCDialingButton.h
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DialingButtonType) {
    /// 退出
    DialingButtonTypeCancel = 0,
    /// 退格
    DialingButtonTypeBack
};

@interface GCDialingButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame type:(DialingButtonType)type;

@end
