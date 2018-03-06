//
//  GCMessaging.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCMessaging.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface GCMessaging()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,copy) responseData messageResponse;

@property (nonatomic,copy) WVJBResponseCallback callback;

@end

@implementation GCMessaging

+ (instancetype)message{
    
    static GCMessaging *message = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        message = [[GCMessaging alloc] init];
    });
    return message;
}

- (void)gc_startEntireApi{
    
    [self gc_shortMessage:nil response:nil];
    [self gc_sendEmail:nil response:nil];
}

- (void)gc_shortMessage:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        [self shortMessage:param response:response];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:ShortMessage handler:^(id data, WVJBResponseCallback responseCallback) {
            
            _callback = responseCallback;
            
            [self shortMessage:param response:nil];
        }];
    }
}

- (void)gc_sendEmail:(NSDictionary *)param response:(responseData)response{
    
    
}




#pragma mark - private method
- (void)shortMessage:(NSDictionary *)param response:(responseData)response{
    
    if ([MFMessageComposeViewController canSendText])
    {
        _messageResponse = response;
        
        NSDictionary *message = [GCHelper jsonDictionary:param];
        
        NSString *number = message[@"telNum"];
        NSString *smsBody = message[@"smsBody"];
        
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        
        picker.messageComposeDelegate = self;
        
        picker.recipients = @[number];
        
        picker.body = smsBody;
        
        [[GCHelper getCurrentShowController] presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        [GCHelper alertTitle:@"提示" msg:@"设备不可发送短信,请检查设备"];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString *sendResult;
    switch (result)
    {
        case MessageComposeResultCancelled: //取消
            sendResult = @"Cancel";
            break;
        case MessageComposeResultSent: //发送
            sendResult = @"Sent";
            break;
        case MessageComposeResultFailed: //失败
            sendResult = @"Failed";
            break;
        default: //默认
            sendResult = @"Unknow";
            break;
    }
    
    NSDictionary *param = @{@"data":sendResult};
    
    if (_messageResponse) {
        
        _messageResponse(param);
        
    }else{
        
        if (_callback) {
            
            _callback(param);
        }
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
//        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
//        [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}
//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"eMail主题"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    //添加一个pdf附件
//    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = @"<font color='red'>eMail</font> 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [[GCHelper getCurrentShowController] presentModalViewController: mailPicker animated:YES];
//    [mailPicker release];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
//    [self alertWithMessage:msg];
}

@end
