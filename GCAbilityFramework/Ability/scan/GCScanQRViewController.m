//
//  GCScanQRViewController.m
//  GCAbility
//
//  Created by LBL on 2017/11/23.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCScanQRViewController.h"
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "GCHelper.h"
#import "GCScanView.h"
#import "GCAbilityStrings.h"
#import "GCImagePicker.h"

@interface GCScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/** 定义一个管道 连接输入和输出流 */
@property (nonatomic,strong) AVCaptureSession * session;
/** 展示输出流到屏幕上 */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreLayer;

@property (nonatomic,weak) GCScanView *scanView;

@end

@implementation GCScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
        
        if ([self isAvailableOfCamera]) {
            
            // 获得后置设置摄像头管理对象
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            // 从摄像头中获得输入流
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error) {
                NSLog(@"%@",error);
                return;
            }
            // 创建输出流 --->把图形输出
            AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            CGRect rect = CGRectMake(50, 150, self.view.frame.size.width - 100, self.view.frame.size.width - 100);
            
            // 给管道赋值 连接输入和输出
            self.session = [AVCaptureSession new];
            [self.session addInput:input];
            [self.session addOutput:output];
            // 设置输出的图像质量
            [self.session setSessionPreset:AVCaptureSessionPresetHigh];
            // 设置识别类型
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,//二维码
                                           //条形码
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeUPCECode,
                                           AVMetadataObjectTypeCode39Code,
                                           AVMetadataObjectTypeCode39Mod43Code,
                                           AVMetadataObjectTypeCode93Code,
                                           AVMetadataObjectTypeCode128Code,
                                           AVMetadataObjectTypePDF417Code];
            
            // 把画面显示输出到屏幕 给用户看
            self.videoPreLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.videoPreLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.videoPreLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.view.layer addSublayer:self.videoPreLayer];
            CGRect intertRect = [self.videoPreLayer metadataOutputRectOfInterestForRect:rect];
            output.rectOfInterest = intertRect;
            __unused CGRect layerRect = [self.videoPreLayer rectForMetadataOutputRectOfInterest:intertRect];
            
            // 启动管道
            [self.session startRunning];
            
            GCScanView *scanV = [[GCScanView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.scanView = scanV;
            [self.view addSubview:scanV];
            
        }else{
            
            [GCHelper alertTitle:CameraPermissionDeny msg:CameraPermissionDenyDesc];
        }
        
    }else{
        
        [GCHelper alertTitle:CameraMalfunction msg:CameraMalfunctionDesc];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
        [self.session stopRunning];
        
        // 获取数据
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        
        if (_scanResultHandler) {
            // 返回结果
            self.scanResultHandler(obj.stringValue);
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                [self backMethod];
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setupOperation];
}


/**
 *  返回、相册、手电筒
 */
- (void)setupOperation{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 30, 30, 30);
    back.layer.cornerRadius = 15;
    back.layer.masksToBounds = YES;
    [back setImage:[UIImage imageNamed:@"icon_ability_back_white"] forState:UIControlStateNormal];
    back.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [back addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.scanView addSubview:back];
    
    GCScanButton *album = [GCScanButton buttonWithFrame:CGRectMake(55,self.view.frame.size.width-100+150+30, 60, 85) image:@"icon_ability_folder" target:self action:@selector(albumMethod) title:@"图片"];
    [self.scanView addSubview:album];
    
    GCScanButton *light = [GCScanButton buttonWithFrame:CGRectMake(self.view.frame.size.width-105,self.view.frame.size.width-100+150+30, 60, 85) image:@"icon_ability_light_normal" target:self action:@selector(lightMethod:) title:@"灯光"];
    [light setImage:[UIImage imageNamed:@"icon_ability_light_selected"] forState:UIControlStateSelected];
    [self.scanView addSubview:light];
}

/**
 *  相册选择图片
 */
- (void)albumMethod{
    
    NSLog(@"albumMethod");
    
    [[GCImagePicker shareGCImagePicker] imagePickWithType:UIImagePickerControllerSourceTypePhotoLibrary multiSelect:NO picNum:0 handler:^(NSArray *imageArray) {
        
        UIImage *aImage = [imageArray firstObject];
        // 识别图片中的二维码
        NSArray *array = [GCImagePicker readQRCodeFromImage:aImage];
        CIQRCodeFeature *feature = [array firstObject];
        if (_scanResultHandler) {
            // 返回识别结果
            self.scanResultHandler(feature.messageString);
        }
        [self backMethod];
    }];
}

/**
 *  开启/关闭手电筒
 */
- (void)lightMethod:(GCScanButton *)sender{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (!sender.selected) {
                
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
            
            sender.selected = !sender.selected;
        }
    }
    
    NSLog(@"lightMethod");
}
/**
 *  返回
 */
- (void)backMethod{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.videoPreLayer removeFromSuperlayer];
        self.session = nil;
        self.videoPreLayer = nil;
    }];
}
/**
 *  相机是否可以使用
 */
- (BOOL)isAvailableOfCamera{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问
        authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
