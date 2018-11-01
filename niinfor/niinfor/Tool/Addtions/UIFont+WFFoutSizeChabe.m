//
//  UIFont+WFFoutSizeChabe.m
//  niinfor
//
//  Created by 王孝飞 on 2017/12/14.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import "UIFont+WFFoutSizeChabe.h"




@implementation UIFont (WFFoutSizeChabe)


+(void)load{

    //获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(changeFontWith:fontSize:));
    //获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(fontWithName:size:));
    //然后交换类方法
    method_exchangeImplementations(newMethod, method);

}



+(UIFont*)changeFontWith:(NSString*)nameString fontSize:(CGFloat)fontSize{

    UIFont *newFont=nil;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        newFont = [self changeFontWith:nameString fontSize:fontSize];
    } else {
        // 针对 9.0 以下的iOS系统进行处理
        newFont = [self systemFontOfSize:fontSize];
    }

    return newFont;
}

@end
@implementation UIImage (Addtion)
-(NSData *)compressWithMaxLength:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    
    NSData *data = UIImageJPEGRepresentation(self, compression) == nil ? UIImagePNGRepresentation(self) : UIImageJPEGRepresentation(self, compression) ;
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.8) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}


// 使用UIColor创建UIImage
+ (UIImage *)createImageWithColor: (UIColor *)color{
    CGRect rect=CGRectMake(0, 0.0f, [UIScreen mainScreen].bounds.size.width, 0.5f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

+ (UIImage *)createImagWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0, 0.0f, 24.0f, 24.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
//    CGContextAddPath(context, _circlePath.CGPath);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage circleImage:theImage withParam:0];
    
}


+ (UIImage *)createThreeColorImagWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 40.0f, 40.0f);
    CGRect rect1 = CGRectMake(0, 0, 32.0f, 32.0f);
    CGRect rect2= CGRectMake(0, 0, 24.0f, 24.0f);
    
    UIImage *theImage;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    theImage = [UIImage circleImage:theImage withParam:8];
    
//    UIGraphicsBeginImageContext(rect1.size);
//    CGContextRef context1 = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context1, [color CGColor]);
//    CGContextFillRect(context1, rect1);
//
//    theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    theImage = [UIImage circleImage:theImage withParam:8];
//
//    UIGraphicsBeginImageContext(rect2.size);
//    CGContextRef context2 = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context2, [color CGColor]);
//    CGContextFillRect(context2, rect2);
//
//    theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    theImage = [UIImage circleImage:theImage withParam:8];
    
    
    
    
//    CGContextSetFillColorWithColor(context, [UIColor.lightGrayColor CGColor]);
//    CGContextFillRect(context, rect);
//
//
//    CGContextSetFillColorWithColor(context, [UIColor.whiteColor CGColor]);
//    CGContextFillRect(context, rect1);
       //theImage = [UIImage circleImag:theImage lineColor:UIColor.lightGrayColor withParam:4];
    return [UIImage circleImag:theImage lineColor:UIColor.greenColor withParam:1];
    //[UIImage circleImag:theImage withParam:8];
    
}


+(UIImage *) circleImag:(UIImage*) image lineColor:(UIColor*)lincolor  withParam:(CGFloat) inset {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, 8);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}



+(UIImage *) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end





