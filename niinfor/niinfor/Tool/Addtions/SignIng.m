//
//  SignIng.m
//  Ambulance
//
//  Created by 王孝飞 on 2017/4/17.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import "SignIng.h"
#import "NSString+MD5.h"

@implementation SignIng

+ (instancetype)singleton
{
    static SignIng* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}
-(NSDictionary *)signingParam:(NSDictionary *)paramsDict requestType:(NSString*)requestStyle andNetWorkStyle:(NSString *)POSTORGET
{
    
    NSString *paramsEncryptedString =[NSString stringWithFormat:@"%@%@",requestStyle,POSTORGET];
    
    //签名日期串
    NSDate *date = [NSDate date];
    NSString*dateString = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    NSMutableDictionary *Mdict ;
    if (paramsDict)    Mdict = [paramsDict mutableCopy];
    else  Mdict = [NSMutableDictionary new];
    [Mdict setObject:dateString forKey:@"timestamp"];
    paramsDict = [Mdict copy];
    
    NSArray* arr = [paramsDict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    
    for (int i=0; i<arr.count; i++) {
        paramsEncryptedString = [paramsEncryptedString stringByAppendingFormat:@"%@=%@", arr[i], [paramsDict objectForKey:arr[i]]];
    }
    
    paramsEncryptedString =  [paramsEncryptedString stringByAppendingString:@"JvzMQSh5rg3MmkKQF+S9dKGWz3Fqsrkhhmyc65dPr6C0nY3DLd2BGVZN38zmiL8kHPM8qYJ3n583yKmNJnPgq/uCa+rnbK5UiJzbBVaEcGwq343p5NJ+ynVzYqWtJpk+R0ndhC0CmMcxyEXEfsRJSrCJDD9eLle+pA8pw6Ob7Js="];
    
    //对代签字符串先进行 urlencode编码  在进行MD5加密
    NSString *sign = [[NSString encodeString:paramsEncryptedString] MD5_Encrypt];
    
    NSMutableDictionary* tempDict;
    if (!paramsDict) {
        tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:sign forKey:@"sign"];
    }
    else
    {
        
        tempDict = [paramsDict mutableCopy];
        [tempDict setObject:sign forKey:@"sign"];
    }
    
    
    return tempDict;
    
}

-(NSDictionary *)constructSigningParam:(NSDictionary *)paramsDict requestType:(NSString*)requestStyle andNetWorkStyle:(NSString *)POSTORGET{
    NSString *paramsEncryptedString =[NSString stringWithFormat:@"%@%@",requestStyle,POSTORGET];
    
    
    //签名日期串
    NSDate *date = [NSDate date];
    NSString*dateString = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    NSMutableDictionary *Mdict = [paramsDict mutableCopy];
    [Mdict setObject:dateString forKey:@"timestamp"];
    paramsDict = [Mdict copy];
    
    NSArray* arr = [paramsDict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    
    for (int i=0; i<arr.count; i++) {
        paramsEncryptedString = [paramsEncryptedString stringByAppendingFormat:@"%@=%@", arr[i], [paramsDict objectForKey:arr[i]]];
    }
    
    paramsEncryptedString =  [paramsEncryptedString stringByAppendingString:@"JvzMQSh5rg3MmkKQF+S9dKGWz3Fqsrkhhmyc65dPr6C0nY3DLd2BGVZN38zmiL8kHPM8qYJ3n583yKmNJnPgq/uCa+rnbK5UiJzbBVaEcGwq343p5NJ+ynVzYqWtJpk+R0ndhC0CmMcxyEXEfsRJSrCJDD9eLle+pA8pw6Ob7Js="];
    
    //对代签字符串先进行 urlencode编码  在进行MD5加密
    NSString *sign = [[NSString encodeString:paramsEncryptedString] MD5_Encrypt];
    
    NSMutableDictionary* tempDict;
    if (!paramsDict) {
        tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:sign forKey:@"sign"];
    }
    else
    {
        
        tempDict = [paramsDict mutableCopy];
        [tempDict setObject:sign forKey:@"sign"];
    }
    
    
    return tempDict;
    
}


@end
