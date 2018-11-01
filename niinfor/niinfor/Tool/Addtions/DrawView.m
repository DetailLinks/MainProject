//
//  DrawView.m
//  Animation-OC
//
//  Created by 王孝飞 on 2017/7/25.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import "DrawView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DrawView()
{
    CAShapeLayer *shapeLayer;
}

@end

@implementation DrawView


- (UIImage*)cutCurrentImageView{
    
    //此处的CGSizeMake是根据需要制定截取图片的宽、高；NO/YES表示是否透明
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);  //NO，YES 控制是否透明
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    return image;
}



+(Class)layerClass{
    return [CAShapeLayer class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.path = [[UIBezierPath alloc]init];
        
        shapeLayer = (CAShapeLayer*)self.layer;
        
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        
        shapeLayer.fillColor = [UIColor greenColor].CGColor;
        
        shapeLayer.lineCap = kCALineCapRound;
        
        shapeLayer.lineWidth = 5.f;
        
        shapeLayer.lineJoin = kCALineJoinRound;

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_createPath];
    }
    return self;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.path addLineToPoint:point];
    
    ((CAShapeLayer*)self.layer).path = self.path.CGPath;
}

- (void)rewritter{
    
    ((CAShapeLayer*)self.layer).path = nil;
    [self p_createPath];
    
}


- (void)p_createPath{
    self.path = [[UIBezierPath alloc]init];
    
    shapeLayer = (CAShapeLayer*)self.layer;
    
    shapeLayer.strokeColor = _strokColor.CGColor;//[UIColor redColor].CGColor;
    
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineCap = kCALineCapRound;
    
    shapeLayer.lineWidth = 6.f;
    
    shapeLayer.lineJoin = kCALineJoinRound;

}

@end
