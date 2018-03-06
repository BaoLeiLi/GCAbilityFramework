//
//  GCRecordView.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2017/12/12.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^recordVoiceHandler)(NSDictionary *voiceInfo);

@interface GCRecordView : UIView

+ (instancetype)shareRecordView;
/**
 *  @brief 显示录音视图并录音
 *  @param mTimeLength 录音最小时长，单位: 秒
 *  @param keyword 文件名关键字
 */
- (void)showWithMinTimeLength:(NSInteger)mTimeLength keyword:(NSString *)keyword handler:(recordVoiceHandler)handler;

@end
