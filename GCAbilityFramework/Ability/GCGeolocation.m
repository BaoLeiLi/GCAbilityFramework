//
//  GCGeolocation.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCGeolocation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MapKit/MapKit.h>
#import "GCHelper.h"
#import "GCAbilityStrings.h"


@interface GCGeolocation()<AMapLocationManagerDelegate>{
    
    CLLocation *selfLocation;   // 当前自己的位置
}

@property (nonatomic,strong) CLLocationManager *manager;

@property (nonatomic,copy) locationResult callBack;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation GCGeolocation

+ (instancetype)geolocation{
    
    static GCGeolocation *geolocation = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        geolocation = [[GCGeolocation alloc] init];
    });
    return geolocation;
}

- (CLLocationManager *)manager{
    
    if (!_manager) {
        
        _manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setDistanceFilter:10.f];
    
    //设置允许在后台定位
    //    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
}

- (void)gc_startEntireApi{
    
    [self gc_startGCLocation:nil];
//    [self gc_startNavigation:nil response:nil];
}

- (void)gc_startGCLocation:(locationResult)handler{
    
    [AMapServices sharedServices].apiKey = AMapAPIKey;
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        [GCHelper alertTitle:LocationPermissionDeny msg:LocationPermissionDenyDesc];
        
        return;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // 如果没有授权则请求用户授权
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [self.manager requestWhenInUseAuthorization];
        }
    } else if (status == kCLAuthorizationStatusDenied) {
        
        [GCHelper alertTitle:LocationPermissionDeny msg:LocationPermissionDenyDesc];
        
        return;
    }
    
    [self initCompleteBlock];
    
    [self configLocationManager];
    
    if (handler) {
        
        _callBack = handler;
    }
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)initCompleteBlock
{
    __weak typeof(self)weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作
            CLLocationCoordinate2D coordinate = location.coordinate; //位置坐标
            selfLocation = location;
            
            NSString *longtitude = [NSString stringWithFormat:@"%.6f", coordinate.longitude];
            NSString *latitude = [NSString stringWithFormat:@"%.6f", coordinate.latitude];
            //拼接位置信息
            NSDictionary *locationDict = @{@"longitude":longtitude,@"latitude":latitude,@"address":regeocode.formattedAddress,@"province":regeocode.province,@"city":regeocode.city,@"district":regeocode.district,@"street":regeocode.street,@"cityCode":regeocode.citycode,@"adCode":regeocode.adcode};
            
            if (weakSelf.callBack) {
                
                weakSelf.callBack(@{@"data":locationDict});
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    };
}


- (void)startNavigation:(CLLocationCoordinate2D)coordinate{
    
    // 先判断是否安装了高德地图 -------  因为ios10可以卸载系统自带的高德地图
    BOOL mapCanOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    
    if (!mapCanOpen) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Please go to the appStore to download AMAP" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sure];
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    // 获取开始位置的地标
    [geocoder reverseGeocodeLocation:selfLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count ==0 ||error != nil) {
            
            [GCHelper alertTitle:@"提示" msg:@"获取位置失败,请稍后重试"];
            
            return ;
        }
        
        CLPlacemark *startPlacemark = [placemarks firstObject];
        
        // 获得终点位置的地标
        CLLocation *endLoaction = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [geocoder reverseGeocodeLocation:endLoaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count ==0 ||error != nil) {
                
                [GCHelper alertTitle:@"提示" msg:@"获取位置失败,请稍后重试"];
                
                return ;
            }
            
            CLPlacemark * endPlacemark = [placemarks firstObject];
            
            // 开始导航
            //0,创建起点
            MKPlacemark * startMKPlacemark = [[MKPlacemark alloc]initWithPlacemark:startPlacemark];
            //0,创建终点
            MKPlacemark * endMKPlacemark = [[MKPlacemark alloc]initWithPlacemark:endPlacemark];
            
            //1,设置起点位置
            MKMapItem * startItem = [[MKMapItem alloc]initWithPlacemark:startMKPlacemark];
            //2,设置终点位置
            MKMapItem * endItem = [[MKMapItem alloc]initWithPlacemark:endMKPlacemark];
            //3,起点,终点数组
            NSArray * items = @[ startItem ,endItem];
            
            //4,设置地图的附加参数,是个字典
            NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
            //导航模式(驾车,步行)
            dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
            //地图显示的模式
            dictM[MKLaunchOptionsMapTypeKey] = MKMapTypeStandard;
            
            //只要调用MKMapItem的open方法,就可以调用系统自带地图的导航
            //Items:告诉系统地图从哪到哪
            //launchOptions:启动地图APP参数(导航的模式/是否需要先交通状况/地图的模式/..)
            
            [MKMapItem openMapsWithItems:items launchOptions:dictM];
            
        }];
        
    }];
}

@end
