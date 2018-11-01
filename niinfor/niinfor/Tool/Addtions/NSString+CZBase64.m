//
//  NSString+CZBase64.m
//
//  Created by 刘凡 on 16/6/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSString+CZBase64.h"

@implementation NSString (CZBase64)

- (NSString *)cz_base64Encode {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)cz_base64Decode {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

///验证
- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

//手机号分服务商
- (BOOL)isMobileNumberClassification{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //  NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10     * 中国移动：China Mobile
     11     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15     * 中国联通：China Unicom
     16     * 130,131,132,152,155,156,185,186,1709
     17     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20     * 中国电信：China Telecom
     21     * 133,1349,153,180,189,1700
     22     */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //  NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([self isValidateByRegex:CM])
        || ([self isValidateByRegex:CU])
        || ([self isValidateByRegex:CT])
        || ([self isValidateByRegex:PHS]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//手机号有效性
- (BOOL)isMobileNumber{
    /**
     * 手机号以13、15、18、170开头，8个 \d 数字字符
     * 小灵通 区号：010,020,021,022,023,024,025,027,028,029 还有未设置的新区号xxx
     *///
    NSString *mobileNoRegex = @"^1((3\\d|5[0-35-9]|8[025-9])\\d|70[059])\\d{7}$";//除4以外的所有个位整数，不能使用[^4,\\d]匹配，这里是否iOS Bug?
    NSString *phsRegex = @"^0(10|2[0-57-9]|\\d{3})\\d{7,8}$";
    
    NSString * phsRegexs = @"^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$";
    
    BOOL ret = [self isValidateByRegex:mobileNoRegex];
    BOOL ret1 = [self isValidateByRegex:phsRegex];
    BOOL ret2 = [self isValidateByRegex:phsRegexs];
    
    return (ret || ret1 || ret2);
}

//邮箱
- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}



@end
