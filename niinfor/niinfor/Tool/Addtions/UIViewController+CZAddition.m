//
//  UIViewController+CZAddition.m
//
//  Created by 刘凡 on 16/5/18.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIViewController+CZAddition.h"
#import <objc/runtime.h>
//#import "UMMobClick/MobClick.h"
#import <UMAnalytics/MobClick.h>

@implementation UIViewController (CZAddition)
//+(void)load{
//
//    {//获取替换后的类方法
//        Method newMethod = class_getInstanceMethod([self class], @selector(view_um_WillAppear:));
//        //获取替换前的类方法
//        Method method = class_getClassMethod([self class], @selector(viewWillAppear:));
//        //然后交换类方法
//        method_exchangeImplementations(newMethod, method);
//    }
//    {//获取替换后的类方法
//        Method newMethod = class_getInstanceMethod([self class], @selector(view_um_WillDisappear:));
//        //获取替换前的类方法
//        Method method = class_getClassMethod([self class], @selector(viewWillDisappear:));
//        //然后交换类方法
//        method_exchangeImplementations(newMethod, method);
//    }
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        // When swizzling a class method, use the following:
//        // Class class = object_getClass((id)self);
//        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
//        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
//    });
//}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)   {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

-(void)aop_viewWillAppear:(BOOL)animated {
    [self aop_viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
#ifdef DEBUG
    NSLog(@"👀👀👀👀👀👀👀开启👀👀viewVillAppear:%@",NSStringFromClass([self class]));
#endif
    
}
-(void)aop_viewWillDisappear:(BOOL)animated {
    [self aop_viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
#ifdef DEBUG
    NSLog(@"👀👀👀👀👀👀👀关闭👀👀viewDISAppear:%@",NSStringFromClass([self class]));
#endif
}


//- (void)view_um_WillAppear:(BOOL)animated{
//    [self view_um_WillAppear:animated];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
//    NSLog(@"[MobClick beginLogPageView:NSStringFromClass([self class])];");
//}
//
//- (void)view_um_WillDisappear:(BOOL)animated{
//    [self view_um_WillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
//    NSLog(@"[MobClick endLogPageView:NSStringFromClass([self class])];");
//}

- (void)cz_addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}

@end
