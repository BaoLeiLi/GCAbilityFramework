//
//  GCDialingView.h
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDialingView : UIView
/**
 *  初始化拨号界面
 *  @param frame 拨号界面的frame
 *  @param defultNumber 默认的电话号码
 */
- (instancetype)initWithFrame:(CGRect)frame defultPhoneNumber:(NSString *)defultNumber;
/**
 *  显示拨号界面
 */
- (void)showDialing;

@end
