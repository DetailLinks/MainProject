//
//  NSString+MD5.m
//  Ambulance
//
//  Created by 王孝飞 on 2017/4/17.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (MD5)


-(NSString *)MD5_Encrypt{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+(NSString*)encodeString:(NSString*)unencodedString{
    
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}






+ (NSString*)dictionaryToJson:(NSArray *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *jsonString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

/** 清理缓存的方法，这个方法会清除缓存类型为HTML类型的文件*/
+ (void)clearCache
{
    /* 取得Library文件夹的位置*/
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    /* 取得bundle id，用作文件拼接用*/
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* 取得目录下所有的文件，取得文件数组*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:webKitFolderInCachesfs error:&error];
    
   //HLog(@"路径==%@,fileList%@",webKitFolderInCachesfs,fileList);
    /* 遍历文件组成的数组*/
    for(NSString * fileName in fileList){
        /* 定位每个文件的位置*/
        NSString * path = [[NSBundle bundleWithPath:webKitFolderInCachesfs] pathForResource:fileName ofType:@""];
        /* 将文件转换为NSData类型的数据*/
        NSData * fileData = [NSData dataWithContentsOfFile:path];
        /* 如果FileData的长度大于2，说明FileData不为空*/
        if(fileData.length > 2){
            /* 创建两个用于显示文件类型的变量*/
            int char1 = 0;
            int char2 = 0;
            
            [fileData getBytes:&char1 range:NSMakeRange(0, 1)];
            [fileData getBytes:&char2 range:NSMakeRange(1, 1)];
            /* 拼接两个变量*/
            NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
            /* 如果该文件前四个字符是6033，说明是Html文件，删除掉本地的缓存*/
            if([numStr isEqualToString:@"6033"]){
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",webKitFolderInCachesfs,fileName] error:&error];
                continue;
            }
            
        }
    }
}

@end

