//
//  GCPlayerItem.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/10.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCPlayerItem.h"

@implementation GCPlayerItem

-(void)dealloc{
    
    if (self.observer) {
        
        [self removeObserver:self.observer forKeyPath:@"status"];
        
        [self removeObserver:self.observer forKeyPath:@"loadedTimeRanges"];
    }
}

@end
