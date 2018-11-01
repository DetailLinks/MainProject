//
//  UIScreen+CZAddition.m
//
//  Created by 刘凡 on 16/5/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIScreen+CZAddition.h"

@implementation UIScreen (CZAddition)

+ (CGFloat)cz_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)cz_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)cz_scale {
    return [UIScreen mainScreen].scale;
}

+(void)rotationScreen{
    
    //强制归正：
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}

+(void)forceScreen{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarOrientation:)]){
        SEL selector = NSSelectorFromString(@"setStatusBarOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIApplication instanceMethodSignatureForSelector:selector]];
        UIDeviceOrientation orentation = UIDeviceOrientationPortrait;
        [invocation setSelector:selector];
        [invocation setTarget:[UIApplication sharedApplication]];
        [invocation setArgument:&orentation atIndex:2];
        [invocation invoke];
    }

}

@end
