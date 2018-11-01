//
//  SWJiaMi.m
//  ShenWaiInfor
//
//  Created by 辉 on 16/3/12.
//  Copyright © 2016年 辉. All rights reserved.
//




#import "SWJiaMi.h"


@implementation SWJiaMi


+ (NSString *)jiami:(NSString *)userName passWord:(NSString *)passWord {

    
    const char* string = [userName UTF8String];
    const char *p = [passWord UTF8String];
    
    char pass[1024];
    strcpy(pass, p);
    
    unsigned char code = 0;
    for (int i = 0; i < strlen(string); i++) {
        
        code ^= ((unsigned char)(string[i]));
    }
    unsigned long length = strlen(pass);
    char pass2[2048];
    
    int k = 0;
    for(int j = 0; j < length; j++){
        pass[j] ^= code;
        
        pass2[k] = (pass[j]>>4);
        if(pass2[k] >= 0 && pass2[k] <= 9){
            pass2[k] += '0';
        }
        else
            pass2[k] = 'a' + (pass2[k]-0x0a);
        
        ++k;
        pass2[k] = pass[j]&0x0f;
        if(pass2[k] >= 0 && pass2[k] <= 9){
            pass2[k] += '0';
        }
        else
            pass2[k] = 'a' + (pass2[k]-0x0a);
        
        ++k;
        
    }
    pass2[k] = 0;

    NSString *strings = [NSString stringWithUTF8String: pass2];

    return strings;
    
    
}


@end
