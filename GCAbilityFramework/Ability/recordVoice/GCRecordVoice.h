//
//  GCRecordVoice.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2017/12/11.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kRecordVoiceTime;
extern NSString *const kRecordVoiceFileName;
extern NSString *const kRecordVoiceFilePath;
extern NSString *const kRecordVoiceFileSize;


@interface GCRecordVoice : NSObject

+ (instancetype)shareRecordVoice;

/**
 *  @brief 录音
 *  @param keyword 文件名关键字
 */
- (void)startRecord:(NSString *)keyword;
/**
 *  @brief 停止录音并返回文件信息
 */
- (NSDictionary *)stopRecord;

@end
