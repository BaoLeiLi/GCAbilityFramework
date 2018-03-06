//
//  GCScanQRViewController.h
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCScanQRViewController : UIViewController

/**
 *  扫描结果回调 block
 *  @param result 扫描结果
 */
@property (nonatomic,copy) void (^scanResultHandler)(NSString *result);

@end
