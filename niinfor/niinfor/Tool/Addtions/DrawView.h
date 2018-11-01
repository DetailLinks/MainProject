//
//  DrawView.h
//  Animation-OC
//
//  Created by 王孝飞 on 2017/7/25.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic,strong)UIBezierPath *path;

@property (nonatomic,strong)UIColor *strokColor;

- (void)rewritter;
- (UIImage*)cutCurrentImageView;

@end
