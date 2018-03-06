//
//  GCContacts.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2018/1/3.
//  Copyright © 2018年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCContacts.h"
#import "GCDialingView.h"
#import <AddressBookUI/AddressBookUI.h>

@interface GCContacts ()<ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate>
{
    BOOL _isEdit;  // 区分是添加联系人还是编辑联系人
}
@property (nonatomic,copy) responseData contantsResponseData;
@property (nonatomic,copy) WVJBResponseCallback contantsCallback;



@end

@implementation GCContacts

+ (instancetype)contacts{
    
    static GCContacts *contacts = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        contacts = [[GCContacts alloc] init];
    });
    return contacts;
}

- (void)gc_startEntireApi{
    
    [self gc_telephoneCall:nil];
    
    [self gc_getContact:nil];
    
    [self gc_newContact:nil response:nil];
    
    [self gc_editContact:nil response:nil];
}

- (void)gc_telephoneCall:(NSDictionary *)param{
    
    if (param) {
        
        [self telephoneCall:param];
        
    }else{
        
        [[GCGlobal global].bridge registerHandler:TelephoneCall handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [self telephoneCall:(NSDictionary *)data];
        }];
        
    }
}

- (void)gc_getContact:(responseData)response{
    
    if (response) {
        
        _contantsResponseData = response;
        
        _contantsCallback = nil;
        
        [self getContacts];
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"fetchContacts" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            _contantsCallback = responseCallback;
            
            _contantsResponseData = nil;
            
            [self getContacts];
            
        }];
    }
}

- (void)gc_newContact:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        _contantsResponseData = response;
        
        _contantsCallback = nil;
        
        [self addContact:param];
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"addContact" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            _contantsCallback = responseCallback;
            
            _contantsResponseData = nil;
            
            [self addContact:data];
            
        }];
    }
}

- (void)gc_editContact:(NSDictionary *)param response:(responseData)response{
    
    if (param) {
        
        _contantsResponseData = response;
        
        _contantsCallback = nil;
        
        [self editContact:param];
        
    }else{
#warning Handler 方法名
        [[GCGlobal global].bridge registerHandler:@"editContact" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            _contantsCallback = responseCallback;
            
            _contantsResponseData = nil;
            
            [self editContact:data];
            
        }];
    }
}


#pragma mark - private method
- (void)telephoneCall:(NSDictionary *)param{
    
    NSDictionary *dic = [GCHelper jsonDictionary:param];
    NSString *phoneNumber = dic[@"telNum"];
    NSString *callFlag = dic[@"callFlag"];
    
    if (phoneNumber != nil && phoneNumber != NULL) {
        
        if ([callFlag integerValue] == 1) {
            
            GCDialingView *dialingV = [[GCDialingView alloc] initWithFrame:[UIScreen mainScreen].bounds defultPhoneNumber:phoneNumber];
            [dialingV showDialing];
            
        }else{
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
        }
    }
}

- (void)getContacts{
    
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [[GCHelper getCurrentShowController] presentViewController:peoplePicker animated:YES completion:nil];
}

- (void)addContact:(NSDictionary *)param{
#warning 参数 param 处理
//    NSDictionary *dict = [GCHelper jsonDictionary:param];
    
    ABNewPersonViewController  *newPerson = [[ABNewPersonViewController alloc]init];
    newPerson.newPersonViewDelegate = self;
    
    CFTypeRef phoneRef = (__bridge CFTypeRef)(@"18010925563");
    CFTypeRef lastnameRef = (__bridge CFTypeRef)(@"李");
    CFTypeRef firstnameRef = (__bridge CFTypeRef)(@"保磊");
    
    ABRecordRef recordRef = ABPersonCreate();
    
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, lastnameRef, NULL);
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, firstnameRef, NULL);
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, phoneRef, kABPersonPhoneMobileLabel, NULL);
    
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multi, NULL);
    
    newPerson.displayedPerson = recordRef;
    
    UINavigationController *addContactNav = [[UINavigationController alloc] initWithRootViewController:newPerson];
    
    [[GCHelper getCurrentShowController] presentViewController:addContactNav animated:YES completion:nil];
}

- (void)editContact:(NSDictionary *)param{
#warning 参数 param 处理
//    NSDictionary *dic = [GCHelper jsonDictionary:param];
    
    _isEdit = YES;
    
    [self getContacts];
    
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    
    if (_isEdit) {
        
        [peoplePicker dismissViewControllerAnimated:NO completion:^{
            
            ABNewPersonViewController *editPerson = [[ABNewPersonViewController alloc] init];
            editPerson.newPersonViewDelegate = self;
            ABRecordID recordId = ABRecordGetRecordID(person);
            ABAddressBookRef addressBookRef = ABAddressBookCreate();
            ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(addressBookRef, recordId);
            editPerson.displayedPerson = recordRef;
            UINavigationController *editNav = [[UINavigationController alloc] initWithRootViewController:editPerson];
            [[GCHelper getCurrentShowController] presentViewController:editNav animated:YES completion:nil];
        }];
        
    }else{
        
        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        // (__bridge NSString *) : 将对象交给Foundation框架的引用来使用,但是内存不交给它来管理
        // (__bridge_transfer NSString *) : 将对象所有权直接交给Foundation框架的应用,并且内存也交给它来管理
        NSString *lastname = (__bridge_transfer NSString *)(lastName);
        NSString *firstname = (__bridge_transfer NSString *)(firstName);
        NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        NSLog(@"%@ %@", lastname, firstname);
        
        // 2.获取选中联系人的电话号码
        // 2.1.获取所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        NSMutableArray *phoneArray = [NSMutableArray array];
        
        // 2.2.遍历拿到每一个电话号码
        for (int i = 0; i < phoneCount; i++) {
            // 2.2.1.获取电话对应的key
            NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            
            // 2.2.2.获取电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            
            [phoneArray addObject:phoneValue];
            
            NSLog(@"%@ : %@", phoneLabel, phoneValue);
        }
        
        NSDictionary *contactDict = @{@"data":@{@"name":name,@"phones":phoneArray}};
        
        if (_contantsResponseData) {
            
            _contantsResponseData(contactDict);
            
        }else{
            
            _contantsCallback(contactDict);
        }
    }

}
#pragma mark - ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    
    if (_isEdit) {
        NSLog(@"edit new contact complete");
        _isEdit = NO;
    }else{
        NSLog(@"add new contact complete");
    }
    
    [newPersonView dismissViewControllerAnimated:YES completion:^{
        
        if (_contantsResponseData) {
            
            _contantsResponseData(@{@"data":@"success"});
            
        }else{
            
            _contantsCallback(@{@"data":@"success"});
            
        }
    }];
}




@end
