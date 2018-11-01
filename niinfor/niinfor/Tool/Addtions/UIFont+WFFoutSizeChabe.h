//
//  UIFont+WFFoutSizeChabe.h
//  niinfor
//
//  Created by 王孝飞 on 2017/12/14.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h> 

@interface UIFont (WFFoutSizeChabe)

+(UIFont*)changeFontWith:(NSString*)nameString fontSize:(CGFloat)fontSize;

+ (UIImage *)createImageWithColor: (UIColor *)color;
@end

@interface UIImage(Addtion)
-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;
+ (UIImage *)createImageWithColor: (UIColor *)color;
+ (UIImage *)createImagWithColor: (UIColor *)color;
+ (UIImage *)createThreeColorImagWithColor: (UIColor *)color;
@end
