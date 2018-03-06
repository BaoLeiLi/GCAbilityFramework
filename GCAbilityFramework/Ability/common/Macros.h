//
//  Macros.h
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/16.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define __document_path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define __index_path @"src/index.html"
#define __config_path @"src/config-module.json"
#define __version_path @"src/src-version.json"
#define __splash_path [__document_path stringByAppendingPathComponent:@"src/splash"]


#ifdef DEBUG
#define _log(fmt,...) NSLog((@"%s[Line %d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define _log(...)
#endif

#endif /* Macros_h */
