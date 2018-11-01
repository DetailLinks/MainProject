//
//  SignIng.h
//  Ambulance
//
//  Created by 王孝飞 on 2017/4/17.
//  Copyright © 2017年 孝飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignIng : NSObject

+ (instancetype)singleton;

-(NSDictionary *)signingParam:(NSDictionary *)paramsDict requestType:(NSString*)requestStyle andNetWorkStyle:(NSString *)POSTORGET;

-(NSDictionary *)constructSigningParam:(NSDictionary *)paramsDict requestType:(NSString*)requestStyle andNetWorkStyle:(NSString *)POSTORGET;
@end
