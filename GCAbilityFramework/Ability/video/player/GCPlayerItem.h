//
//  GCPlayerItem.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/10.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface GCPlayerItem : AVPlayerItem

@property (nonatomic,weak) id observer;

@end
