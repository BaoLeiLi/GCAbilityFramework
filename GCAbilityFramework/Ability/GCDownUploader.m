//
//  GCDownUploader.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/18.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCDownUploader.h"
#import "AFURLSessionManager.h"


@interface GCDownUploader ()

@property (nonatomic,copy) WVJBResponseCallback downCallback;
@property (nonatomic,copy) WVJBResponseCallback upCallback;

@end

@implementation GCDownUploader

+ (instancetype)downuploader{
    
    static GCDownUploader *down_up;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        down_up = [[GCDownUploader alloc] init];
    });
    return down_up;
}

- (void)gc_startEntireApi{
    
    [self gc_downloader:nil response:nil];
    [self gc_uploader:nil response:nil];
}

dispatch_queue_t dispatch_async_downuploder_queue(){
    
    static dispatch_queue_t dispatch_async_downuploder_queue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async_downuploder_queue = dispatch_queue_create("com.ustcinfo.mobileFrame.downuploader", NULL);
    });
    return dispatch_async_downuploder_queue;
}

- (void)gc_downloader:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        [self downloader:param response:response];
        
    }else{
        
#warning Handler
        [[GCGlobal global].bridge registerHandler:@"" handler:^(id data, WVJBResponseCallback responseCallback) {
            _downCallback = responseCallback;
            [self downloader:(NSDictionary *)data response:nil];
            
        }];
    }
}




- (void)downloader:(NSDictionary *)param response:(responseData)responseCallback{
    
    NSDictionary *dict = [GCHelper jsonDictionary:param];
    // 下载文件的地址
    NSURL *url = [NSURL URLWithString:dict[@"url"]];
    // 文件保存的名称
    NSString *fileName = dict[@"fileName"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 下载文件夹
    NSString *directory = [__document_path stringByAppendingPathComponent:@"Downloader"];
    // 文件夹判断
    BOOL exist = [fileManager fileExistsAtPath:directory];
    if (!exist) {
        
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // 加入队列
    dispatch_async(dispatch_async_downuploder_queue(), ^{
        NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager =
        [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            //保存路径
            NSURL *documentsDirectoryURL =  [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            NSString *tmpFileName = [response suggestedFilename];
            
            if (![fileName isEqualToString:@""]) {
                
                tmpFileName = fileName;
            }
            
            return [[documentsDirectoryURL URLByAppendingPathComponent:@"Downloader" isDirectory:YES] URLByAppendingPathComponent:tmpFileName];
            
        }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            if (error == nil) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                if (responseCallback) {
                    
                    responseCallback(@{@"data":[filePath path]});
                }else{
                    
                    if (_downCallback) {
                        
                        _downCallback(@{@"data":[filePath path]});
                    }
                }
                
            } else { //下载失败
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            
        }];
        
        [downloadTask resume];
        
    });
    
}


@end
