//
//  NSString+MD5.h
//  Ambulance
//
//  Created by 王孝飞 on 2017/4/17.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
/**
 *  MD5加密
 *
 *  @return 加密好的字符串
 */
-(NSString *)MD5_Encrypt ;


/**
 *  urlEncode编码
 *
 unencodedString 需要编码的字符串
 *
 *   编码后的字符串
 */
+(NSString*)encodeString:(NSString*)unencodedString;


//字典转json
+ (NSString*)dictionaryToJson:(NSArray *)dic;

+ (void)clearCache;
@end
